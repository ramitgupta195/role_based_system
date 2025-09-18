class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_or_super_admin!

  def index
    users =
      if current_user.has_role?(:super_admin)
        User.all
      elsif current_user.has_role?(:admin)
        User.joins(:roles).where(roles: { name: "user" })
      end

    render json: users.as_json(only: [ :id, :email, :created_at ],
                               include: { roles: { only: [ :name ] } }),
           status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      assign_role_to_user(user)
      render json: user.as_json(only: [ :id, :email, :created_at ],
                                include: { roles: { only: [ :name ] } }),
             status: :created
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user.as_json(only: [ :id, :email, :created_at ],
                                include: { roles: { only: [ :name ] } }),
             status: :ok
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { message: "User with id #{user.email} deleted successfully" }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def assign_role_to_user(user)
    if current_user.has_role?(:super_admin)
      # Super Admin can assign Admin or User roles explicitly
      role_name = params[:role] || "user"
    elsif current_user.has_role?(:admin)
      # Admins can only create Users
      role_name = "user"
    end
    user.assign_role(role_name)
  end

  def authorize_admin_or_super_admin!
    unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
      render json: { error: "Not Authorized" }, status: :forbidden
    end
  end

  def role_names
    roles.pluck(:name)
  end

  def profile_photo_url
    if profile_photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(profile_photo, only_path: true)
    else
      "/images/default_avatar.png" # fallback (you can replace with initials-based image later)
    end
  end
end
