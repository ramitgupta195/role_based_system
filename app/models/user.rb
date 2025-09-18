class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  has_and_belongs_to_many :roles
  has_one_attached :profile_photo

  def has_role?(role_name)
    roles.exists?(name: role_name.to_s)
  end

  def assign_role(role_name)
    r = Role.find_by(name: role_name.to_s)
    roles << r if r && !has_role?(role_name)
  end

  # return roles
  def role_names
    roles.pluck(:name)
  end

  # Return URL for profile photo if attached
  def profile_photo_url
    Rails.application.routes.url_helpers.rails_blob_url(profile_photo, only_path: true) if profile_photo.attached?
  end
end
