class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #$host = '10.0.4.85'
  $host = 'ch-experiment.herokuapp.com'
end
