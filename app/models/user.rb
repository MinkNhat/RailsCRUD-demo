class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  enum role: { user: 0, admin: 1, super_admin: 2, content_manager: 3 }
end
