class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json

  before_action :authenticate_user!
  # Completely disable sessions
  def current_user
    super.tap { |_| request.session_options[:skip] = true }
  end
end
