# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tips_session',
  :secret      => '53ae67c263e07bde8d41fb52ab4b188a25cf9b3497a5466144661482a252a27f18465bdf42332d1726ad8e340dab0eeda91536d828c70c7b93c493feef6b4cb7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
