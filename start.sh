#!/bin/bash

eval bundle exec unicorn -p 3000 -c config/unicorn/production.rb