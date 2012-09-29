class AppConfig < ActiveRecord::Base
  attr_accessible :rulebook_name, :front_page, :faq

  validate :only_one_model_allowed

  def only_one_model_allowed
    if self.new_record? and AppConfig.all.count > 0
      errors[:base] << "Only a single App Config may exist"
    end
  end
end
