export ELASTICSEARCH_URL=$BONSAI_URL
bundle exec rake db:migrate db:seed assets:precompile search:index
