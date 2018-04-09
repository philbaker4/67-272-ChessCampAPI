class User < ApplicationRecord

  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  has_secure_password

  validates_presence_of :username, :password_digest, :role, :email

  validates_uniqueness_of :username, case_sensitive: false
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :password, :on => :create 
  validates_presence_of :password_confirmation, :on => :create   
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long"
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/, message: "is not a valid format"
  validates_inclusion_of :role, in: %w( admin instructor parent ), message: "is not recognized in the system"


  before_save :reformat_phone


  private

    def reformat_phone
      phone = self.phone.to_s  # change to string in case input as all numbers 
      phone.gsub!(/[^0-9]/,"") # strip all non-digits
      self.phone = phone       # reset self.phone to new string
    end

end
 