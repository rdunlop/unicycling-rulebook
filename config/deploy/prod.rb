set :deploy_to, '/home/ec2-user/unicycling-rulebook'
set :rails_env, 'production'
set :branch, 'master'

# new prod
server '54.148.66.79', user: 'ec2-user', roles: %w(web app db)
