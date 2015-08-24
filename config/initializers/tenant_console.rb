# rubocop:disable Rails/Output
if defined?(Rails::Console)
  def switch_tenant
    if Rails.env.test?
      puts "skipping tenant selection in test mode"
      return
    end
    puts "Select your tenant:"
    Rulebook.all.each do |tenant|
      puts tenant.subdomain
    end
    print "Enter tenant: "
    Apartment::Tenant.switch!(gets.strip)
    puts "Tenant Switched to #{Apartment::Tenant.current}"
  end
  switch_tenant()
end
