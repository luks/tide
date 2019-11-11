require_relative 'db'
require 'shrine'
require 'shrine/storage/file_system'
require 'sidekiq'

if ENV['RACK_ENV'] == 'development'
  Sequel::Model.cache_associations = false
end

Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :prepared_statements
Sequel::Model.plugin :subclasses unless ENV['RACK_ENV'] == 'development'

# Shrine
#Shrine.plugin :logging
Shrine.plugin :sequel
Shrine.plugin :cached_attachment_data
Shrine.plugin :rack_file
Shrine.plugin :backgrounding
Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
}

# Shrine::Attacher.promote { |data| PromoteJob.perform_async(data) }
# Shrine::Attacher.delete { |data| DeleteJob.perform_async(data) }
# /Shrine

unless defined?(Unreloader)
  require 'rack/unreloader'
  Unreloader = Rack::Unreloader.new(reload: false)
end

Unreloader.require('models') { |f| Sequel::Model.send(:camelize, File.basename(f).sub(/\.rb\z/, '')) }

if ENV['RACK_ENV'] == 'development'
  require 'logger'
  DB.loggers << Logger.new($stdout)
else
  Sequel::Model.freeze_descendents
  DB.freeze
end
