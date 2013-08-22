# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Abchoops::Application.initialize!

#SSL Fix
ENV['SSL_CERT_FILE'] = 'C:\RailsInstaller\cacert.pem'

#Linguistics
Linguistics::use(:en)