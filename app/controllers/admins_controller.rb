
    class AdminsController < ApplicationController
      before_action :authenticate_user!
      before_action :authorize_super_admin!

      def index
        admins = User.joins(:roles).where(roles: { name: "admin" })
        render json: admins, status: :ok
      end

      def create
        admin = User.new(admin_params)
        if admin.save
          admin.assign_role("admin")
          render json: admin, status: :created
        else
          render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        admin = User.find(params[:id])
        if admin.update(admin_params)
          render json: admin, status: :ok
        else
          render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        admin = User.find(params[:id])
        admin.destroy
        render json: {message: "Admin with id #{admin.email} has been deleted"}, status: :ok
      end

      private

      def admin_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def authorize_super_admin!
        unless current_user.has_role?(:super_admin)
          render json: { error: "Not Authorized" }, status: :forbidden
        end
      end
    end
