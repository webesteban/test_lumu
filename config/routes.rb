Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/result'
  post 'home/process_text'

end
