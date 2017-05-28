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

    config.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = UnauthorizedController
    end
  end
end
