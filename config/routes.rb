Rails.application.routes.draw do
  # Accept all type requests GET, POST, PUT, PATCH etc.
  match '*path', to: 'pings#handle', via: :all
end
