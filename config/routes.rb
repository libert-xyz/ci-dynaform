Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "application#index", as: "root"

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#delete", as: "logout"

  get "/signup", to: "users#new", as: "signup"
  post "/signup", to: "users#create"

  post "/dyna_forms/:id/publish", to: "dyna_forms#publish", as: :dyna_form_publish
  post "/dyna_forms/:id/unpublish", to: "dyna_forms#unpublish", as: :dyna_form_unpublish
  post "/dyna_forms/:id/details", to: "dyna_forms#details", as: :dyna_form_details
  get "/dyna_forms/:id/take_survey", to: "dyna_forms#take_survey", as: :take_survey
  post "/dyna_forms/:id/results", to: "dyna_forms#results", as: :dyna_form_results
  get "/published_surveys", to: "dyna_forms#published_surveys", as: :published_surveys

  delete "form_inputs/:id", to: "form_inputs#destroy", as: :form_input_delete
  post "form_inputs/:id/edit",to: "form_inputs#edit", as: :form_input_edit

  post "submitted_forms/build_survey", to: "submitted_forms#build_survey"
  post "submitted_forms/:id/save_progress", to: "submitted_forms#save_progress", as: :submitted_form_response_save_progress
  resources :submitted_forms, only: [:show]

  resources :dyna_forms do
    resources :form_inputs, except: [:destroy]
    post 'form_inputs/sample', to: 'form_inputs#sample', as: "form_inputs_sample"
  end

  get "/dashboard", to: "dashboard#index", as: "dashboard"

end
