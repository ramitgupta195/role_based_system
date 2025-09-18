class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Override Devise create action to assign role
  def create
    super do |user|
      # Assign default role if none exists
      role = Role.find_by(name: "user")   # default normal user role
      user.roles << role if role && user.roles.empty?

      # Customize the response to include roles
      render json: {
        message: "Signed up successfully.",
        user: user_data(user)
      }, status: :created and return
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  def user_data(user)
    {
      id: user.id,
      email: user.email,
      roles: user.roles.pluck(:name),
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
