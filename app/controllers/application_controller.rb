class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #修改服务器地址
  $host = 'ch-experiment.herokuapp.com'
end
