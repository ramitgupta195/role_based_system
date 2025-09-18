# Role-Based System API

A Rails API application implementing **role-based access control** with JWT authentication.  
Supports **Super Admin**, **Admin**, and **Normal User** roles with CRUD operations according to permissions.

## Features

- **Authentication** using Devise + JWT
- **Role-based authorization**
  - Super Admin can manage Admins & Users
  - Admin can manage Normal Users
  - Normal User can manage their own profile
- **Profile management** with optional profile photo upload
- Seeded default roles and Super Admin user

## Roles

| Role         | Permissions                                         |
| ------------ | -------------------------------------------------- |
| Super Admin  | Full CRUD on Admins and Users                      |
| Admin        | CRUD on Normal Users                               |
| Normal User  | View & update own profile                          |

## API Endpoints

### Authentication

- `POST /users/sign_in` → Login
- `POST /users` → Register (Normal User by default)
- `DELETE /users/sign_out` → Logout

### Admin Management (Super Admin only)

- `GET /admins` → List all admins
- `POST /admins` → Create admin
- `PUT /admins/:id` → Update admin
- `DELETE /admins/:id` → Delete admin

### User Management (Super Admin/Admin)

- `GET /users` → List users
- `POST /users` → Create user
- `PUT /users/:id` → Update user
- `DELETE /users/:id` → Delete user

### Profile (Normal User)

- `GET /profile` → Get own profile
- `PUT /profile` → Update own profile

## Setup

1. Clone the repo  
   ```bash
   git clone https://github.com/ramitgupta195/role_based_system.git
   cd role_based_system
2. Install dependencies 
    ```bash
    bundle install
    rails db:create db:migrate db:seed
    ```
3. Run the Server
    ```bash
    rails s
    ```
4. Use Post or curl to test endpoints

### Notes
-Authentication uses JWT, so you need to include the Authorization: Bearer <token> header for protected endpoints.
- Default Super Admin credentials (from seeds):
    - Email: ```superadmin@example.com```
    - Password: ```password123```
