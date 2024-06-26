describe 'accessibility check' do
  context 'when logged out' do
    setup_config[:logged_out_pages]['paths'].each do |each_page|
      it "validate a11y checks for: #{each_page}", path: each_page do
        clear_session
        visit each_page
        expect(page).to be_axe_clean
      end
    end
  end

  context 'when logged in' do
    before(:context) do
      visit '/sign_in'
      find('[data-testid="google"]').click
      find('#identifierId').set(setup_config[:setup]['email'])
      find('#identifierNext button span').click
      find('[name="password"]').set(setup_config[:setup]['password'])
      find('#passwordNext button span').click
      wait_until { current_url.include? Capybara.app_host }
    end

    setup_config[:logged_in_pages]['paths'].each do |each_page|
      it "validate a11y checks for: #{each_page}", path: each_page do |_scenario|
        visit each_page
        expect(page).to be_axe_clean
      end
    end
  end
end
