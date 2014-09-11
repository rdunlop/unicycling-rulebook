# == Schema Information
#
# Table name: app_configs
#
#  id            :integer          not null, primary key
#  rulebook_name :string(255)
#  front_page    :text
#  faq           :text
#  created_at    :datetime
#  updated_at    :datetime
#  copyright     :string(255)
#

class AppConfig < ActiveRecord::Base
  attr_accessible :rulebook_name, :front_page, :faq, :copyright

  validate :only_one_model_allowed

  def only_one_model_allowed
    if self.new_record? and AppConfig.all.count > 0
      errors[:base] << "Only a single App Config may exist"
    end
  end
end
