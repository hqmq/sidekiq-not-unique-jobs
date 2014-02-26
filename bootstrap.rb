require 'bundler/setup'
Bundler.require
ROOT = File.dirname(__FILE__)
require ROOT + "/config/sidekiq.rb"
Dir[ROOT+'/workers/*.rb'].each do |worker_file|
  require worker_file
end
