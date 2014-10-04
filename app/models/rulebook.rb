# == Schema Information
#
# Table name: rulebooks
#
#  id            :integer          not null, primary key
#  rulebook_name :string(255)
#  front_page    :text
#  faq           :text
#  created_at    :datetime
#  updated_at    :datetime
#  copyright     :string(255)
#  subdomain     :string(255)
#
# Indexes
#
#  index_rulebooks_on_subdomain  (subdomain) UNIQUE
#

class Rulebook < ActiveRecord::Base
  validates :subdomain, uniqueness: true

  def rulebook
    rulebook_name || "Generic IUF Rulebook"
  end

  def copyright_description
    copyright || "#{Date.today.year} International Unicycling Federation"
  end
end
