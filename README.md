# About

HolidayCheckers blogging about things they care about. Live version of this blog is [techblog.holidaycheck.com][blog-url]

# Run the blog locally, via nix

The site can be built and run locally using nix.
1) Make sure to have nix installed (see [nixos.org/nix][nix]) and then 
2) run `nix-shell default.nix` (or simply `nix-shell`) and you should have the blog 
3) running locally at http://localhost:4000.

Details about how to get jekyll to run locally via [nix], the instructions
how I set it up can be found on [this site][nixos-via-jekyll].

[nix]: http://nixos.org/nix/
[nixos-via-jekyll]: http://stesie.github.io/2016/08/nixos-github-pages-env
[blog-url]: http://techblog.holidaycheck.com

# How to add a new blog post

## If you are a new author:

1. Add your picture to the “img/” directory.
2. Create your author page in the “authors/” directory.
3. Use this template:
```			
---
layout: author
title: Author
permalink: author/{name_of_this_file}/
feature_image: {the name of the picture to be displayed on the left}
author_avatar: {the name of the file you added to the "img" directory}
author_name: {your name here}
title: {again your name}
---
			{some description of you, you can use markdown here}
```
		ii. feature_image -> choose the “feature” image from the “img/” directory and use it’s name as the value of this variable


## Writing a new blog post
1. Create a new image directory for your post in the “img/posts/” directory.
2. Add the header image to that directory (optional).
3. Create a new markdown (.md) file in the “_posts/” directory and use the following template:
```
---
layout: post
title: "{title of your blog post}"
date: {the publication date, for example: 2018-12-03 12:0:00 +0200}
categories: {category of the blog post, category names are defined in "category/" directory (use the directory name)}
author_name: {put your name here}
author_url : {the link to your author page (without the file extension)}
author_avatar: {the name of your avatar file}
read_time : {the time required to read your blog post in minutes}
excerpt: "{the text to be used as a subtitle of your blog post. If you leave it empty, the first paragraph will be used.}"
feature_image: {a link to the header image, for example: posts/2018-12-03-greenfield/header.jpg, only if you added the image in step 2b}
---
		{here is the content, you can use markdown}
```
4. Build the project according to the instructions in the README.md file.
5. Create a new pull request (you must fork the tech-blog repository) and get it approved by someone.
6. Ask someone with write access to merge your pull request.
