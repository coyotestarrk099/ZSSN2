Rails.application.routes.draw do
  resources :report_lists, format: "json"
  resources :survivors, format: "json"
  patch 'survivors_location/:id' => 'survivors#update_location'
  patch 'survivors_infected/:id' => 'survivors#update_infected'
  post 'survivors_trade/:id' => 'survivors#trade'
  get 'survivors_report' => 'survivors#report_resource'
  get 'survivors_zombie' => 'survivors#report_zombie'
  get 'survivors_number' => 'survivors#report_survivor'
  get 'survivors_lost' => 'survivors#report_lost'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
