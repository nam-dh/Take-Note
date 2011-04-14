# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Takenote::Application.initialize!

Takenote::Application.config.session_store :active_record_store

