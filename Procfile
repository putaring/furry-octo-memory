web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q critical -q default -q mailers -q low -c 5
