# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'urls#index'

  resources :urls, only: %i[index create show], param: :url
  get ':url', to: 'urls#visit', as: :visit

  get '/404', :to => redirect('/404.html'), as: :not_found
end
