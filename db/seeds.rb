# Create roles
%w[super_admin admin "Normal User"].each do |role_name|
  Role.find_or_create_by!(name: role_name)
end

# Create Super Admin
super_admin = User.find_or_create_by!(email: "superadmin@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end
super_admin.assign_role("super_admin")

# Create Admin
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end
admin.assign_role("admin")

# Create Normal User
user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end
user.assign_role("Normal User")

puts "✅ Seeded Super Admin, Admin, and Normal User"
