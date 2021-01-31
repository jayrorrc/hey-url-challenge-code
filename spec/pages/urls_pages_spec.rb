require 'rails_helper'

RSpec.describe 'URL', type: :feature do
  describe 'GET #show' do
    it 'shows stats about the given URL' do
      url = FactoryBot.create(:url)
      visit url_path(url.short_url)

      expect(page).to have_content(url.short_url)
    end

    it 'throws 404 when the URL is not found' do
      visit url_path(' *&#@')

      expect(page).to have_content "The page you were looking for doesn't exist."
      expect(page).to have_content 'You may have mistyped the address or the page may have moved.'
      expect(page).to have_content 'If you are the application owner check the logs for more information.'
    end
  end

  describe 'GET #visit' do
    it 'throws 404 when the URL is not found' do
      url = FactoryBot.create(:url)
      url.original_url = 'http://asddsa.com'
      url.save

      visit visit_path(url.short_url)

      expect(page).to have_content "The page you were looking for doesn't exist."
      expect(page).to have_content 'You may have mistyped the address or the page may have moved.'
      expect(page).to have_content 'If you are the application owner check the logs for more information.'
    end
  end
end