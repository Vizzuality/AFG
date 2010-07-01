# == Schema Information
#
# Table name: admin_passwords
#
#  id       :integer         not null, primary key
#  password :string(255)     
#

class AdminPassword < ActiveRecord::Base
  
  validates_presence_of :password
  validates_length_of :password, :minimum => 3
  
  validate :only_one_admin_password
  
  private
  
    def only_one_admin_password
      errors.add(:base, "Only one password is allowed") if AdminPassword.count >= 1 && self.new_record?
    end
  
end
