# == Schema Information
#
# Table name: public.rulebooks
#
#  id                 :integer          not null, primary key
#  rulebook_name      :string
#  front_page         :text
#  faq                :text
#  created_at         :datetime
#  updated_at         :datetime
#  copyright          :string
#  subdomain          :string
#  admin_upgrade_code :string
#  proposals_allowed  :boolean          default(TRUE), not null
#
# Indexes
#
#  index_rulebooks_on_subdomain  (subdomain) UNIQUE
#

class Rulebook < ApplicationRecord
  validates :subdomain, uniqueness: true

  def rulebook
    rulebook_name || "Generic IUF Rulebook"
  end

  def copyright_description
    copyright || "#{Date.current.year} International Unicycling Federation"
  end

  def url
    "http://#{permanent_url}"
  end

  def permanent_url
    "#{subdomain}.#{Rails.configuration.domain}"
  end

  def self.current_rulebook
    find_by(subdomain: Apartment::Tenant.current)
  end

  def self.find_first_by_hostname(hostname)
    find_by(subdomain: hostname.split('.')[0])
  end
end
