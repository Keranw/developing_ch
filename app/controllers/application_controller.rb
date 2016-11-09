class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  $host = '10.0.4.85:3000'
end
