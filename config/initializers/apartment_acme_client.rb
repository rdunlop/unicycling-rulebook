# A callback method which lists the possible domains to be checked
# We will verify each of them before requesting a certificate from Let's Encrypt for all of them
ApartmentAcmeClient.domains_to_check = lambda do
  # always assume base domain URL is correct
  domains = []

  # there are no customized domains for the rulebook
  domains
end
ApartmentAcmeClient.wildcard_domain = Rails.configuration.domain

# The base domain, a domain which is always going to be accessible.
# because we need a common domain to be used on each request.
# if not defined, the first 'domain_to_check' which succeeds will be used
ApartmentAcmeClient.common_name = Rails.configuration.domain

# Directory where to store the challenge files, Must be accessible via the internet
ApartmentAcmeClient.public_folder = '/home/ec2-user/unicycling-rulebook/current/public'

# Directory where to store certificates locally
# must persist between deployments, so that nginx can reference it permanently
ApartmentAcmeClient.certificate_storage_folder = '/home/ec2-user/unicycling-rulebook/current/public/system'

# for s3 storage
ApartmentAcmeClient.aws_region = Rails.configuration.aws_region
ApartmentAcmeClient.aws_bucket = Rails.configuration.aws_bucket

# For use in the nginx configuration
ApartmentAcmeClient.socket_path = "/tmp/unicorn-unicycling-rulebook.socket"
ApartmentAcmeClient.nginx_config_path = "/etc/nginx/conf.d/rulebook.conf"

ApartmentAcmeClient.verify_over_https = true
