class User < ActiveRecord::Base
	# you'll notice that we have salt and encrypted_password in our actual DB, but we won't call our
	# forms using those field names.  This is how you'll access form data on the model side, even if the names
	# don't match up in the DB.  
	attr_accessor :password, :password_confirmation  #these are called virtual attribute!
	email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i  #sexy string pattern matching ftw!

	validates :first_name, :presence => true, :length => {:maximum => 30}

	validates :last_name, :presence => true, :length => {:maximum => 30}

	validates :email, :presence => true, 
			  :format => {:with => email_regex},
			  :uniqueness => {:case_sensitive => false }
	# this validates the virtual attribute, password and password_confirmation!  Yay!
	validates :password, :presence => true, 
			  :confirmation => true, 
			  :length => {:within => (4..100)}

	#before I add this user to the DB, I better make sure to encrypt his/her password!
	before_save :encrypt_password 

	def has_password?(submitted_password)
		# this basically does our login: if the user's attempted password (once encrypted) matches the
		# encrypted_password field of the record he/she is attempting to log in as, return true
		self.encrypted_password == encrypt(submitted_password)
	end

	# class method, NOT an instance method.  This is used to check logins as well
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?  # wrong email, you suck
		return user if user.has_password?(submitted_password) #correct email, now check the PW
	end

	#since we're going to define our encryption method here, make sure as hell it's private!
	private
		# this is where the magic happens!
		def encrypt_password
			# generate a salt if this is a new user
			# here we will use the :password virtual attribute
			self.salt = Digest::SHA2.hexdigest("#{Time.now.utc}--#{self.password}") if self.new_record?

			# encrypt the password and store that as the encrypted_password attribute in my model
			self.encrypted_password = encrypt(self.password) #this is the value going into the DB
		end

		def encrypt(password)
			#take the salt and the NON ENCRYPTED PASSWORD and make the ENCRYPTED_PASSWORD aww YIS!!
			Digest::SHA2.hexdigest("#{self.salt}--#{password}")
		end

end
