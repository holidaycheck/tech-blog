---
layout: post
title:  "Build Custom UI Extensions for Contentful"
date:   2017-07-01 02:00:00 +0200
category: javascript
author_name: Sergii Paryzhskyi
author_url : /author/sergii_paryzhskyi
author_avatar: sergii_paryzhskyi
read_time : 7
square_related: recommend-wolf
feature_image: posts/2017-07-contentful-extensions/hero.png
---

[Contentful][contentful] is a powerful and developer-friendly CMS solution. In this article I will assume that the reader is already familiar with Contentful itself. Let us also skip the part about managing the content and concentrate on content models and how this can be customized. It is an important concept in contentful that gives flexibility to declare data structures, its appearance and restrictions of different kinds.

## Built-in fields for content models

Introducing a new field in content model is a multiple-step process that is nicely visualized and simplified to couple of choices that user has to make. Here are the available fields:

<img src="{{site.baseurl}}/img/posts/2017-07-contentful-extensions/fields.png" alt="Add New Field to Content Model" />

The appearance of each field is customizable and depends on its type. For instance the basic text-field can be displayed as a url-field, dropdown or normal text input. For each field there is a list of predefined appearances, for text-field it looks like this:

<img src="{{site.baseurl}}/img/posts/2017-07-contentful-extensions/appearance.png" alt="Setting Up an Appearance for a Field" />

This list is not complete since not all appearances fit on the screen. You can read more about all possible [editing widgets][editing_widgets] in their guide on how to customize entry editor.

## Custom UI Extensions

It’s all great until you stay in the borders of what they are offering, but it’s getting even more interesting when you want to go beyond and add custom fields that are very specific to your case. For instance, there is an entry that represents a Hotel. Each Hotel requires to have a certain amount of stars. We can start with a simple text-field that has a validation which proves that value is a number from 1 to 5. Afterwards this can be upgraded to be a dropdown with five possible choices. What will be even more user-friendly is to have stars, so that user will need to click in order to make a choice, it could look something like this:

<img src="{{site.baseurl}}/img/posts/2017-07-contentful-extensions/stars.jpg" alt="Stars as a Possible Representation of a Field" width="300" />

This is all possible with the concept of custom UI Extensions that Contentful offers us. Extensions are available per space, you can also re-use them in multiple spaces by sharing a code if needed.

## Build Your Own Extension

It is required to have a token with Management API Access in order to update and upload the extension. Here is a page with some sample implementations of such [extensions][all_samples]. There you’ll find extensions like Youtube-Field, Integrated Translator, Chess Board and many more. [This page][rating_dropdown_example] will guide you on how to  create, upload and use your first UI Extension.
Although there are many samples already developed by someone, there is still a need to build something specific to your case. Based on our requirements, we built an extension that communicates with an external API and makes it possible to Download/Buy photos from Getty Images.

## Conclusion and Some More Links

Even though this topic is pretty well documented by Contentful, at the same time the information is quite difficult to find among many other described concepts and topics. To avoid repetitions and duplication of original docs (which might also change in the future), I will just link couple of pages that contain important information on this topic:

[UI Extensions SDK][ui-extension-sdk]<br />
[UI Extensions API Reference][extension_api_reference]<br />
[FAQ to this subject][faq]<br />
[Styleguide (common UI elements)][styleguide]<br />
[CLI to manage UI Extensions on Contentful] [extension_cli]<br />
[Samples of Custom Extensions][sample_extensions]

[all_samples]: https://www.contentful.com/developers/docs/concepts/uiextensions/
[rating_dropdown_example]: https://github.com/contentful/extensions/tree/master/samples/rating-dropdown
[editing_widgets]: https://www.contentful.com/r/knowledgebase/editing-widgets/
[contentful]: http://contentful.com
[ui-extension-sdk]: https://github.com/contentful/ui-extensions-sdk
[extension_api_reference]: https://github.com/contentful/ui-extensions-sdk/blob/master/docs/ui-extensions-sdk-frontend.md
[faq]: https://github.com/contentful/ui-extensions-sdk/blob/master/FAQ.md
[styleguide]: http://contentful.github.io/ui-extensions-sdk/styleguide/
[extension_cli]: https://github.com/contentful/contentful-extension-cli
[sample_extensions]: https://www.contentful.com/developers/docs/concepts/uiextensions/
