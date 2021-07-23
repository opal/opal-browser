#!/bin/sh
bundle install
bundle exec opal -c -q opal-browser -p native -p promise -p browser/setup/full -e '#' -E > opal-browser.js
bundle exec opal -Oc -p opal-parser -e '#' -E > opal-parser.js
