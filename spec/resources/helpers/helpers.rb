# helpers
module Helpers
  def wait_until(
    time = 60,
    sleep_time = 0.5,
    msg = 'Condition was not achieved in time!',
    should_break: true
  )

    raise 'no block given!' unless block_given?

    retries = 0
    begin
      sleep(sleep_time)
      yield ? (return true) : (raise 'still false!')
    rescue RuntimeError
      retries += 1
      retry if retries < (time / sleep_time)
    end

    should_break == true ? (raise msg) : (return false)
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def setup_config
    configurations = {}
    setup_files = Dir['./spec/resources/files/*'].select { |f| File.file? f }.map { |f| File.basename f }

    setup_files.each do |each_file|
      configurations[each_file.split('.json').first.to_sym] =
        JSON.parse(File.read("./spec/resources/files/#{each_file}"))
    end
    configurations
  end

  def clear_session
    Capybara.reset_session!
  end
end
