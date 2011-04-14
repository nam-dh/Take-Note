require 'digest'

class User < ActiveRecord::Base
	
  attr_accessor :password
  has_many :course
	has_many :notes, :through => :course, :source => :note
	
	validates_presence_of :acc, :password, :name, :mail
	validates_uniqueness_of :acc
	
  validates :mail, :uniqueness => true,
                   :length => { :within => 5..50 },
                   :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
	
  validates :password, :confirmation => true, 
                       :length => {:within => 6..30},
                       :presence => true,
                       :if => :password_required?
	
	
	before_save :encrypt_new_password

  def self.authenticate(acc, password)
    user = find_by_acc(acc)
    return user if user && user.authenticated?(password)
  end

  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end

  protected
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end

    def password_required?
      hashed_password.blank? || password.present?
    end

    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
end
