# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Rails.application.config.secret_token = if Rails.env.development? or Rails.env.test? or Rails.env.naucc?
                                          ('x' * 30) # meets minimum requirement of 30 chars long
                                        else
                                          Rails.configuration.secret
                                        end
