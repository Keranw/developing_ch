class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  $host = 'ch-experiment.herokuapp.com'
end
