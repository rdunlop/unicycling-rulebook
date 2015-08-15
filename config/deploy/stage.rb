set :deploy_to, '/home/ec2-user/unicycling-rulebooktest'
set :rails_env, 'stage'
set :branch, 'master'

server '52.25.119.104', user: 'ec2-user', roles: %w(web app db)
