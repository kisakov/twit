# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twitter2_session',
  :secret      => '04938266d65f9207f605b6b15564dfcaaa5e5a175b698ac2dd710dea9a4fa73201501fd58c26b9091c7065c0a4aaba6d0d38a2f70b1f4b34614fcd1ce8b0a3c4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
