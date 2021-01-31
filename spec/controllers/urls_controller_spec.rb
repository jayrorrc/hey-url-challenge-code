# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    it 'shows the latest 10 URLs' do
      urls = FactoryBot.create_list(:url, 11)

      get :index

      urls.shift
      urls.reverse()

      expect(assigns(:urls)).to match_array(urls)
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    it 'creates a new url' do
      post :create, :params => {
        :url => {
          :original_url => 'http://foo.com',
        }
      }

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #show' do
    it 'shows stats about the given URL' do
      url = FactoryBot.create(:url_with_clicks)

      get :show, params: { url: url.short_url }

      expect(response).to render_template(:show)
      expect(assigns(:url).clicks_count).to eq(assigns(:daily_clicks).inject(0) { |sum, clicks| sum + clicks[1] })
      expect(assigns(:url).clicks_count).to eq(assigns(:browsers_clicks).inject(0) { |sum, clicks| sum + clicks[1] })
      expect(assigns(:url).clicks_count).to eq(assigns(:platform_clicks).inject(0) { |sum, clicks| sum + clicks[1] })
    end
  end

  describe 'GET #visit' do
    it 'tracks click event and stores platform and browser information' do
      url = FactoryBot.create(:url)
      numbersOfCick = url.clicks.length()

      get :visit, params: { url: url.short_url}

      expect(assigns(:url).clicks.length()).to eq(numbersOfCick + 1)
    end

    it 'redirects to the original url' do
      url = FactoryBot.create(:url)
      numbersOfCick = url.clicks.length()

      get :visit, params: { url: url.short_url}

      expect(response).to redirect_to(url.original_url)
    end
  end
end
