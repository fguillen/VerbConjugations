# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Wrapi_session',
  :secret      => '603cf3257591bb51f95d665a38170562aecd11fb6d6d7c23b8f3f0f9808807eda7b18a3e013b8194330190ef03996d4ab655c8fc9c647668966da8ecbbab3fbd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
