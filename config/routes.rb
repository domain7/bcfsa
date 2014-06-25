Rails.application.routes.draw do
  resources :district_skill_assessments, :skill_assessments, only: [:index], defaults: { format: 'json' }
  root 'map#index'
end
