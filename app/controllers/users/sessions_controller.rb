class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Skip session storage entirely
  skip_before_action :verify_authenticity_token, raise: false
  before_action :skip_session_storage

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end

  # Return user info along with JWT token on login
  def respond_with(resource, _opts = {})
    # Encode JWT for the user
    token, _payload = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)

    render json: {
      message: "Logged in successfully.",
      user: resource,
      roles: resource.roles.pluck(:name),
      token: token
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
