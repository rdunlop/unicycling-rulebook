module PunditViewPolicy
  extend ActiveSupport::Concern

  class ActionView::Base # rubocop:disable Style/ClassAndModuleChildren
    def policy(_args)
      Class.new do
        def method_missing(*_args, &_block)
          true
        end
      end.new
    end
  end
end

RSpec.configure do |config|
  config.include PunditViewPolicy, type: :view
end
