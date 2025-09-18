class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user.as_json(
      only: [ :id, :email, :created_at, :updated_at ],
      methods: [ :role_names, :profile_photo_url ]
    )
  end

  def update
    if current_user.update(profile_params)
      render json: current_user.as_json(
        only: [ :id, :email, :created_at, :updated_at ],
        methods: [ :role_names, :profile_photo_url ]
      ), status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email, :password, :password_confirmation, :profile_photo)
  end
end
