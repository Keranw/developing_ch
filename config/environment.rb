# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

=begin
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  :address              => 'smtp.gmail.com',
  :port                 => 587,
  :user_name            => 'huntercuriosity@gmail.com',
  :password             => 'kieran0911',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}

config.action_mailer.raise_delivery_errors = true
=end
