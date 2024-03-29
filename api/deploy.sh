#!/bin/bash

SIDEKIQ_PID=`ps aux | grep sidekiq`

while read -r pid; do
        echo "KILLING SIDEKIQ $pid"
        kill -9 $pid
done <<< "$SIDEKIQ_PID"

WORKER_PIDS=`ps aux | grep puma | awk '{print $2}'`

while read -r pid; do
	echo "KILLING PUMA $pid"
	kill -9 $pid
done <<< "$WORKER_PIDS"

git pull origin prod --no-edit

~/.rbenv/shims/bundle install
~/.rbenv/shims/bundle exec rails db:migrate RAILS_ENV=production
~/.rbenv/shims/bundle exec rails s -e production &
sleep 5
~/.rbenv/shims/bundle exec sidekiq -e production &
