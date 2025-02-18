class Admin < ApplicationRecord
    has_secure_password
    has_many :admin_sessions, dependent: :destroy
    
    normalizes :email_address, with: ->(e) { e.strip.downcase }
end
