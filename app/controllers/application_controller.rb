class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session
  
    # Skip CSRF verification for the create action in the UsersController
    skip_before_action :verify_authenticity_token, only: [:create, :update]
end