#!/bin/sh
bundle install
bundle exec opal -c -q opal-browser -p native -p promise -p browser/setup/full -e '#' -E > opal-browser.js
bundle exec opal -Oc -s opal -s native -s promise -s browser/setup/full app/application.rb > application.js
