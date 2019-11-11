require 'yaml'

SETTINGS = YAML.load_file('./settings/database.yml')

setup_postgres = lambda do |env|
  if SETTINGS[env.to_sym]

    db_default = SETTINGS[env.to_sym][:db_default]
    db_sensitive = SETTINGS[env.to_sym][:db_sensitive]
    sh "psql -U postgres -c \"CREATE USER #{db_default[:user]} PASSWORD '#{db_default[:password]}'\""
    sh "createdb -U postgres -O #{db_default[:user]} #{db_default[:user]}"
    sh "psql -U postgres -c \"CREATE EXTENSION postgis\" #{db_default[:database]}"
  else
    puts("Please add environment \"#{env}\" to settings/database.yml")
  end
end



unset_postgres = lambda do |env|
  if SETTINGS[env.to_sym]

    db_default = SETTINGS[env.to_sym][:db_default]
    sh "dropdb -U postgres #{db_default[:database]}"
    sh "dropuser -U postgres #{db_default[:user]}"

  else
    puts("Please add environment \"#{env}\" to settings/database.yml")
  end
end

namespace :db do

  desc 'Setup database PostgreSQL'
  task :set, [:env] do |t, args|
    setup_postgres.call(args[:env])
  end

  desc 'Unset database PostgreSQL'
  task :unset, [:env] do |t, args|
    unset_postgres.call(args[:env])
  end
end



migrate = lambda do |env, version|
  ENV['RACK_ENV'] = env
  require_relative 'db'
  require 'logger'
  Sequel.extension :migration
  DB.loggers << Logger.new($stdout)
  Sequel::Migrator.apply(DB, 'migrate', version)
end



desc "Migrate test database to latest version"
task :test_up do
  migrate.call('test', nil)
end

desc 'Database migration UP'
task :migrate, [:env, :version] do |t, args|
  version = args[:version] ? args[:version].to_i : nil
  migrate.call(args[:env], version)
end



desc "Migrate test database all the way down"
task :test_down do
  migrate.call('test', 0)
end

desc "Migrate test database all the way down and then back up"
task :test_bounce do
  migrate.call('test', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate development database to latest version"
task :dev_up do
  migrate.call('development', nil)
end

desc "Migrate development database to all the way down"
task :dev_down do
  migrate.call('development', 0)
end

desc "Migrate development database all the way down and then back up"
task :dev_bounce do
  migrate.call('development', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate production database to latest version"
task :prod_up do
  migrate.call('production', nil)
end

# Shell

irb = proc do |env|
  ENV['RACK_ENV'] = env
  trap('INT', "IGNORE")
  dir, base = File.split(FileUtils::RUBY)
  cmd = if base.sub!(/\Aruby/, 'irb')
    File.join(dir, base)
  else
    "#{FileUtils::RUBY} -S irb"
  end
  sh "#{cmd} -r ./models"
end

desc "Open irb shell in test mode"
task :test_irb do 
  irb.call('test')
end

desc "Open irb shell in development mode"
task :dev_irb do 
  irb.call('development')
end

desc "Open irb shell in production mode"
task :prod_irb do 
  irb.call('production')
end

# Shell
pry = proc do |env|
  ENV['RACK_ENV'] = env
  trap('INT', 'IGNORE')
  sh 'pry -r ./models.rb'
end

desc 'Run pry (ENV: test, production, development)'
task :pry, [:env] do |t, args|
  env = %w[test production development].include?(args[:env]) ? args[:env] : nil
  if env
    pry.call(env)
  else
    puts('Wrong env param')
  end
end


# Specs

spec = proc do |pattern|
  sh "#{FileUtils::RUBY} -e 'ARGV.each{|f| require f}' #{pattern}"
end

desc "Run all specs"
task :default => [:model_spec, :web_spec]

desc "Run model specs"
task :model_spec do
  spec.call('./spec/model/*_spec.rb')
end

desc "Run web specs"
task :web_spec do
  spec.call('./spec/web/*_spec.rb')
end
