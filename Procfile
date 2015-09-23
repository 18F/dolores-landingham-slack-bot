web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: bin/delayed_job run
clock: bundle exec clockwork config/clock.rb
