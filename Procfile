web: bundle exec puma -C config/puma.rb
worker: env TERM_CHILD=1 QUEUE=photo_uploader,mailers,photo_deleter bundle exec rake resque:work
