class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'find'
  require 'socket'
  require 'json'

  $host = 'ch-exp.herokuapp.com/'
  #$host = '10.0.4.85:3000'
end
