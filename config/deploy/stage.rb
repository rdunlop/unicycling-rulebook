set :deploy_to, '/home/ec2-user/unicycling-rulebook'
set :rails_env, 'stage'
set :branch, ENV["CIRCLE_SHA1"] || ENV["REVISION"] || ENV["BRANCH_NAME"] || "main"

# server '52.25.119.104', user: 'ec2-user', roles: %w[web app db]
server '35.164.69.42', user: 'ec2-user', roles: %w[web app db]

set :no_deploytags, true
