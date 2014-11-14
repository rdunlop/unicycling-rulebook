set :deploy_to, '/home/ec2-user/unicycling-rulebook'
set :rails_env, 'production'
set :branch, 'master'
set :stage, 'prod'

server '54.69.105.140', user: 'ec2-user', roles: %w(web app db)
