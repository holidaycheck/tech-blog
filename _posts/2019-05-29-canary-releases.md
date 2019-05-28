---
layout: post
title: Canary Releases with Traefik on GKE at HolidayCheck
date: 2019-05-29 12:0:00 +0200
author_name: Periklis Tsirakidis
author_url : /author/periklistsirakidis
author_avatar: periklistsirakidis
read_time : 10
feature_image: posts/2019-05-29-canary-releases/canary-in-a-coal-mine.jpg
---

In this post, I would like to introduce you into how [Traefik](https://traefik.io/) helped us shape our cloud ecosystem at [HolidayCheck](https://www.holidaycheckgroup.com/?lang=en). In particular, I will give a brief introduction on how we implemented our canary release process for our microservice architecture with Traefik on Google Kubernetes Engine (GKE).

## Background

Our teams strive to keep a high level of urgency for delivery. Therefore they maintain their delivery pipelines themselves. An inquiry across our continuous delivery (CD) pipelines showed that our teams use one of the following designs:

- *Production follows Staging*: This is the most classic design among all. It prevails in services with older staged workflows where changes are tested in an isolated staging environment without real user traffic.
- *Production with Feature Flags*: This workflow is in place for a constant high pace of changes, especially with UX impact.
- *Production with A/B Tests*: Another variation of the last design is to keep multiple versions of the system online (e.g., A and B version) and split user traffic manually by an operator.

Although all three designs have a positive impact on our release quality already, they are still very tedious to operate or widen the human error vector. To minimize toil and human errors, we introduced another complementary release strategy — canary releases.

## Canary Releases: Our Design

In short canary releases is an automation extension for our CD pipelines to compare a new release (*the canary group*) against the previous version. Ideally, the old deployment (*the main group*) is not touched by this operation. Instead, a new deployment with the old configuration, *the control group*, is created at the same time as the canary.

Our design is based upon a strict set of decisions:

1. User traffic needs to be split across the main deployment and the other two groups, whereas canary and control need an equal traffic share to keep comparisons sane.
2. The CD pipeline needs a data source (e.g., metrics, logs, etc.) to evaluate the canary soundness in comparison to the control instance. The decisions can vary from shifting more traffic to the canary/control group, take canary down or replace the current main with the canary.
3. The three instance groups need to operate independently from each other in isolation.

## Enter Traefik Splitting

One of the significant benefits to using Traefik is that we can rely on building on low-entry barrier features. Although our platform is hosted on GKE, we still need to tailor features according to our use cases. Canary releases being one of them requires us to split traffic across deployments.

Traefik being our single proxy to route traffic to our deployments, has a [built-in feature](https://docs.traefik.io/user-guide/kubernetes/#traffic-splitting) to split traffic across deployment groups through a single Ingress. Therefore a canary deployment can be accomplished with the following Ingress specification:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    traefik.ingress.kubernetes.io/service-weights: |
      my-service: 60%
      my-service-canary: 20%
      my-service-control: 20%
  name: my-service
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: my-service
          servicePort: 80
        path: /
      - backend:
          serviceName: my-service-canary
          servicePort: 80
        path: /
      - backend:
          serviceName: my-service-control
          servicePort: 80
        path: /
```

## Our Canary Workflow

Despite that traffic splitting is a cornerstone to enable canary releases, it is not sufficient. We still need to handle our canary deployments on GKE automatically. Our CDs should be able to automatically make one of the following decisions by comparing the canary with the control group:

- Split more traffic from the main group to the canary and control groups.
- Demote the canary and control groups because of an unacceptable error rate and shift full traffic back to the main group.
- Promote the canary group to become the new main group and remove the control and old main groups.

Furthermore, before traffic splitting we need to provide resources for our canary and control deployments. On the one hand, this ensures that an appropriate replica count exists to handle the traffic. On the other hand, traffic splitting can only happen from a third-party inside Kubernetes that can observe the replica count of the canary and control deployments.

In short, the above CD decisions are accomplished by sending updates for the canary and control deployments to the Kubernetes API server. A separate canary controller handles the rest.

### The Canary Controller

After sending the updates to Kubernetes the deployments of the canary and control groups, as well as the Ingress object, will be reconciled by a canary controller. The controller is responsible for the following actions:

1. *Scale the canary and control deployments*: The number of replicas for the canary and control deployments is based on the traffic share:
```
canaryReplicas = controlGroupReplicas =
  ceil(appReplicas * canaryTrafficPercent / 100)
```
2. *Enable the canary and control deployments*: This means to identify the Ingress object of the main deployment and add the service weights annotation for each deployment.
3. *Disable the canary and control deployments*: In case of promotion/demotion of the canary release, the controller removes the service weights from the Ingress object.

<img src="{{site.baseurl}}/img/posts/2019-05-29-canary-releases/canary-workflow.jpg" alt="HC Canary Releease Workflow" class="centered" />

## A Canary Release from Kubernetes Perspective

If you are using Kubernetes, a simple deployment can contain multiple annotations to express use case specific information. Thus, our CD pipelines communicate each action by updating the annotations of the required deployment specifications. These annotations declare the requested state of our canary release, which in turn is reconciled by the canary controller.

Our canary release implementation requires the following annotations to express the state, as well as the Traefik service weight per deployment:

- `holidaycheck.com/canary-active: bool`: Represents the current state of the canary release in each canary and control deployment.
- `holidaycheck.com/canary-percent: float`: Represents the service weight which should be applied for each the canary and control deployment.

Let’s say we have a service my-service at version v1.6:
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: my-service
  namespace: my-namespace
spec:
  replicas: 10
  template:
      name: my-service
    spec:
      automountServiceAccountToken: false
      containers:
      - image: our-registry/my-service:v1.6
        imagePullPolicy: IfNotPresent
```
We want to evaluate a newer version v1.7 of this service with a canary release, e.g.:
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    holidaycheck.com/canary-active: "false"
    holidaycheck.com/canary-percent: "20.0"
  name: my-service-canary
  namespace: my-namespace
spec:
  replicas: 1
  template:
    metadata:
      name: my-service-canary
    spec:
      containers:
      - image: our-registry/my-service:v1.7
```
Accordingly, a control deployment will be an almost identical copy of the main deployment specification. The only addition here is the extra annotations, e.g.:
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    holidaycheck.com/canary-active: "false"
    holidaycheck.com/canary-percent: "20.0"
  name: my-service-control
  namespace: my-namespace
spec:
  replicas: 1
  template:
    metadata:
      name: my-service-control
    spec:
      containers:
      - image: our-registry/my-service:v1.6
```
Next, the canary controller will reconcile the state of our three deployments to adhere to our replica count specification. Therefore splitting 20% of our traffic from a deployment with ten replicas results in canary and control deployments with two replicas each.

Finally, the controller will translate the canary annotation canary-percent for each deployment to the appropriate Traefik service weights annotation in the Ingress object. Also the canary-active will be set to true for the canary and control deployments:
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    traefik.ingress.kubernetes.io/service-weights: |
      my-service: 60%
      my-service-control: 20%
      my-service-canary: 20%
  name: my-service
```
*Note: To minimize toil creating the above specifications, our teams use a small CLI tool that generates and applies those for them to Kubernetes.*

## Challenges

One challenge remains, namely how to separate Traefik backend metrics per endpoint. The current Traefik v1.7 implementation does not provide a distinction of metrics per backend endpoint. However, you can circumvent this issue by relying on application level metrics, which can be separated by custom labels for the canary, control, and main group accordingly.

## Conclusion

I hope this article has been helpful and will help you to tailor your canary release workflow for your platform based on Traefik’s excellent features.

In summary, we met our main goal to build a slim solution for canary releases with Traefik without introducing the complexity of a full service mesh.

The above implementation is based on:

- Traefik v1.7
- Kubernetes v1.12

*This article was originally published on the Containo.us blog [link](https://blog.containo.us/canary-releases-with-traefik-on-gke-at-holidaycheck-d3c0928f1e02).*
