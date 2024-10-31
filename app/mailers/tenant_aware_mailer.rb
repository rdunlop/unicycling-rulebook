class TenantAwareMailer < ApplicationMailer
  include SubdomainHelper

  # add_template_helper(ApplicationHelper)
end
