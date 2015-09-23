require 'grape'
require 'active_record'

Dir.glob("models/*.rb").each { |r| require_relative r }
Dir.glob("helpers/*.rb").each { |r| require_relative r }
Dir.glob("api/*.rb").each { |r| require_relative r }

module Hampusn
  module MessageCache
    class API_Base < Grape::API
      
      helpers Hampusn::MessageCache::Helpers::UserHelpers

      http_basic do |username, key|
        user = User.find_by username: username

        user && !!user.key && user.key == key
      end

      mount Hampusn::MessageCache::API::Messages

    end
  end
end