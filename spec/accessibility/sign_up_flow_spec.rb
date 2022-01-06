describe 'accessibility check - sign up form' do
  context 'when on sign up flow form' do
    sign_up_page = setup_config[:sign_up_form]['paths'].first
    it "validate a11y checks for: #{sign_up_page}" do
      clear_session
      visit sign_up_page
      find('[data-testid="identity"]').set('potatoe@potatoe.com')
      find('[data-testid="next_button"]').click
      begin
        expect(page).to be_axe_clean
      rescue RSpec::Expectations::ExpectationNotMetError => e
        sign_up_page = sign_up_page.split('https:/').last
        context_text = self.class.description.tr(' ', '_')
        specname = self.class.metadata[:file_path].split('/').last.delete_suffix!('.rb')
        $issues_found.push({
          "/#{specname}/#{context_text}#{sign_up_page}" => e
          })
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end
  end
end
