set :deploy_to, '/home/ec2-user/unicycling-rulebook'
set :rails_env, 'stage'
set :branch, 'develop'

server '52.25.119.104', user: 'ec2-user', roles: %w(web app db)

set :no_deploytags, true
