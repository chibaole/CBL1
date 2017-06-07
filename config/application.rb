require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CVS
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #
    # Warden::Manager.serialize_into_session do |user|
    #   user.id
    # end
    #
    # Warden::Manager.serialize_from_session do |id|
    #   User.find_by_id(id)
    # end
    config.autoload_paths << Rails.root.join('lib')

    config.time_zone = 'Asia/Shanghai'

    config.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = Admin::UnauthorizedController
    end
    config.i18n.default_locale = 'zh-CN'

    config.active_record.time_zone_aware_types = [:datetime, :time]
  end
end
