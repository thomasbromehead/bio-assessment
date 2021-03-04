require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

$redis = nil

module BionicHtml
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.autoload_paths += %W(#{Rails.root}/lib/modules)
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoloader = :classic

    # Don't generate system test files.
    config.generators.system_tests = nil
  end

  def self.redis_config
    Rails.application.config.redis.with_indifferent_access
  end

  Rails::Railtie::Configuration.new.after_initialize do
    $redis = RedisService.start(::BionicHtml.redis_config[:host], ::BionicHtml.redis_config[:port])
    puts "Redis started: #{::BionicHtml.redis_config}"
  end
end
