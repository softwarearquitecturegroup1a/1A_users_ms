class User < ApplicationRecord
    validates :email, :id_code, uniqueness: true, presence: true
    validates :name, :lastname, :id_type, presence: true
end
