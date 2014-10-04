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
#

class Rulebook < ActiveRecord::Base
  validate :only_one_model_allowed

  def only_one_model_allowed
    if self.new_record? && Rulebook.all.count > 0
      errors[:base] << "Only a single App Config may exist"
    end
  end

  def rulebook
    rulebook_name || "Generic IUF Rulebook"
  end

  def copyright_description
    copyright || "#{Date.today.year} International Unicycling Federation"
  end
end
