module SubdomainHelper
  def default_url_options(_options = {})
    current_tenant = Apartment::Tenant.current
    tenant = Rulebook.find_by(subdomain: current_tenant)
    raise Errors::TenantNotFound unless tenant

    { host: tenant.url }
  end
end
