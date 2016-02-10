# User Controller

include Hampusn::MessageCache::Models

module Hampusn
  module MessageCache
    module Controllers
      class UserController < Hampusn::MessageCache::Base

        helpers Hampusn::MessageCache::Helpers::UserHelpers

        get '/user', require_login_or_redirect_to: '/user/login' do
          haml :user, locals: {username: @user.username, key: @user.key}
        end

        get '/user/login' do
          haml :login
        end

        post '/user/login' do
          user = User.where(username: params[:username]).take

          unless user.nil?
            if password_hash_matches? params[:password], user.salt, user.password
              session[:user_id] = user.id

              flash[:success] = "Successfully logged in!"
              redirect '/user'
            end
          end

          flash[:error] = "Login failed."
          redirect '/user/login'
        end

        get '/user/logout' do
          session[:user_id] = nil
          redirect '/'
        end

        post '/user/generate-key', require_login_or_redirect_to: '/user/login' do
          unless @user.nil?
            @user.key = SecureRandom.hex 10
            user_saved = @user.save

            if user_saved
              flash[:success] = "Key generated."
              redirect '/user'
            end
          end

          flash[:error] = "Key could not be generated."
          redirect '/user'
        end

        post '/user/reset-password' do
          # ...
        end

        get '/user/register' do
          # Register view with form
          @email            = params[:email]
          @registration_key = params[:key]

          haml :register
        end

        post '/user/register' do
          request = Request.where(email: params[:email], registration_key: params[:registration_key], approved: true).take

          unless request.nil?
            salt     = generate_new_salt
            password = generate_password_hash params[:password], salt

            user = User.new

            user.username  = params[:username]
            user.email     = params[:email]
            user.password  = password
            user.salt      = salt
            user.activated = true
            # user.key is left out since that should be generated by the user.

            user_saved = user.save

            if user_saved
              flash[:success] = "User registered successfully."

              request.destroy
              redirect '/'
            end
          end

          flash[:error] = "User registration failed."

          redirect '/user/register'
        end

      end
    end
  end
end
