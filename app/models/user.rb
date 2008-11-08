class User < ActiveRecord::Base
  require 'digest/sha1'
  attr_accessor :password
  attr_accessor :plaintext_password
  cattr_accessor :current_user

  validates_presence_of :username, :email, :full_name
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :username, :email
  validates_confirmation_of :password
  validates_format_of :username, :with => /^[^\s]+$/
  before_save :encrypt_password_if_changed
  
  def User.authenticate( username, password )
    u = User.find_by_username( username )
    unless u.nil?
      crypted_pw = Digest::SHA1.hexdigest( u.password_salt + password )
      if ( crypted_pw == u.password_hash )
        u
      else
        nil
      end
    end
  end
  
  def encrypt_password_if_changed
    unless password.nil? or password.empty?
      self.password_salt = random_salt
      self.password_hash = Digest::SHA1.hexdigest( password_salt + password )
      self.password = nil
      self.password_confirmation = nil
    end
  end

  def random_salt
    source_characters = ( ('a'..'Z').to_a + (0..9).to_a ).join
    salt = "" 
    1.upto(100) { salt += source_characters[rand(source_characters.length),1] }
    Digest::SHA1.hexdigest( salt )
  end
end
