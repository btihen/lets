class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :transects, through: :transect_admin_editor

  validates :email,    presence: :true, uniqueness: { case_sensitive: false }

end
