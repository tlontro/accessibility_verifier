$VERBOSE = nil
RSpec.configure do |_config|
  require 'axe-rspec'
  require 'capybara'
  require 'capybara/dsl'
  require 'faker'
  require 'json'
  require 'selenium-webdriver'
  require 'pry'
  require 'webdrivers'

  Dir["#{File.expand_path('.')}/spec/resources/**/*.rb"].each { |each_file| require_relative each_file }

  include Capybara::DSL
  include Helpers

  @@start_time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
  FileUtils.mkdir_p "reports/#{@@start_time}"

  user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.106 Safari/537.36'
  arguments = %W[window-size=1920,1600 user-agent=#{user_agent}]

  arguments.concat(%w[headless disable-gpu no-sandbox]) if ENV['debug'] != 'true'

  ENV['browser'] ||= 'chrome'
  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Chrome::Options.new(
      args: arguments
    )
    Capybara::Selenium::Driver.new(app, browser: ENV['browser'].to_s.to_sym, options: options)
  end

  Capybara.javascript_driver = :chrome
  Capybara.default_driver = :selenium
  Capybara.default_max_wait_time = 20
  Capybara.ignore_hidden_elements = false

  Capybara.app_host = case ENV['environment']
                      when 'integration'
                        'https://integration.hopin.com'
                      when 'live'
                        'https://www.hopin.com'
                      when 'staging'
                        'https://staging.hopin.to'
                      else
                        'https://integration.hopin.com'
                      end

  _config.after(:each) do |scenario|
    if scenario.exception
      specname = scenario.metadata[:file_path].split('/').last.delete_suffix!('.rb')
      if scenario.metadata[:identifier]
        identifier = scenario.metadata[:identifier] + "/"
      end
      report_path = "reports/#{@@start_time}/#{specname}/#{identifier}#{scenario.metadata[:path]}"
      FileUtils.mkdir_p report_path
      File.open("#{report_path}/report.txt", 'w') do |file|
        file.write(scenario.exception)
      end
      Capybara.save_path = report_path
      save_screenshot(path: report_path)
    end
  end
end
