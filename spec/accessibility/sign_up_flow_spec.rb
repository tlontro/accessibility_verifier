describe 'accessibility check - sign up form' do
  context 'when on sign up flow form' do
    sign_up_page = setup_config[:sign_up_form]['paths'].first
    it "validate a11y checks for: #{sign_up_page}", path: sign_up_page do |scenario_details|
      clear_session
      visit sign_up_page
      find('[data-testid="identity"]').set('potatoe@potatoe.com')
      find('[data-testid="next_button"]').click
      expect(page).to be_axe_clean
    end

    it "validate a11y checks for errors on: #{sign_up_page}", path: sign_up_page, identifier: 'errors validation' do |scenario_details|
      clear_session
      visit sign_up_page
      find('[data-testid="identity"]').set('potatoe@potatoe.com')
      find('[data-testid="next_button"]').click
      find('[data-testid="otp-auth-preference"]').click
      find('[data-testid="marketing-consent"]').click
      find('[data-testid="next_button"]').click
      expect(page).to be_axe_clean
    end
  end
end
