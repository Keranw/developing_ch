class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  require 'find'
  require 'socket'
  require 'json'
end
