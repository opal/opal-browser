Integrations
============

It's possible to combine Opal-Browser with a lot of different workflows. Some are
better than others, but some are more suited at certain applications.

If you plan to do a static website, possibly you would like to base your work on
some static-* template. The downside is that you will need to recompile your work
each time you change something (except for static-rake-guard and
static-bash-opal-parser which is interesting only from experimentation viewpoint).

The dynamic-* templates will most of the time allow you to create a website with
both a frontend and a backend (some, like dynamic-rack-opal-sprockets-server won't
make your life easy though).

The sprockets integrations have a unique property, that you can name files like
`file.rb.erb` and then they will be preprocessed by ERB.

This directory is meant in general as a guideline, so the examples are as brief
as possible. I took a lot of time trying to understand how to integrate Opal, so
you can treat this directory as a library of my knowledge that you will be able
to use to get to use Opal as soon as possible!

TODO: dynamic-rails-opal-rails-with-sprockets