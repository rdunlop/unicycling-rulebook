# == Schema Information
#
# Table name: public.rulebooks
#
#  id                 :integer          not null, primary key
#  rulebook_name      :string(255)
#  front_page         :text
#  faq                :text
#  created_at         :datetime
#  updated_at         :datetime
#  copyright          :string(255)
#  subdomain          :string(255)
#  admin_upgrade_code :string(255)
#  proposals_allowed  :boolean          default(TRUE), not null
#

class Rulebook < ActiveRecord::Base
  validates :subdomain, uniqueness: true

  def rulebook
    rulebook_name || "Generic IUF Rulebook"
  end

  def copyright_description
    copyright || "#{Date.today.year} International Unicycling Federation"
  end

  def self.current_rulebook
    find_by(subdomain: Apartment::Tenant.current) || Rulebook.first || Rulebook.new
  end
end
