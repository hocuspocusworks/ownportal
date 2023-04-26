#!/bin/bash

cd ~/ownportal/api

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

bundle exec rails db:migrate RAILS_ENV=production
bundle exec rails s -e production &
sleep 5
bundle exec sidekiq -e production &
