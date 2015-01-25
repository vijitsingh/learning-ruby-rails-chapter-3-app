

-- Create User model
- create new branch
- rails generate model User name:string email:string
- bundle exec rake db:migrate # to actually create the table using /db/migrate/[time_stamp]_create_users.rb file generated
  in above command.
- # bundle exec rake db:rollback  - command for rollback if required. 

- rails console --sandbox # any modifications made to the database would be rolled back
	> User.new 
	=> #<User id: nil, name: nil, email: nil, created_at: nil, updated_at: nil
	> user = User.new(name: "Michael Hartl", email: "mhartl@example.com") 
	=> #<User id: nil, name: "Michael Hartl", email: "mhartl@example.com", created_at: nil, updated_at: nil>
	> user.valid?
	=> true
	> user.save # actually saves in the database. till now only in memory was manipulated. 
	=> true
	> user  # saving the user actually fills the other nil attributes like id
	=> #<User id: 1, name: "Michael Hartl", email: "mhartl@example.com", created_at: "2014-07-24 00:57:46", updated_at: "2014-07-24 00:57:46">
	> user.name
	=> "Michael Hartl"
	> User.create(name: "A Nother", email: "another@example.org") # creates and commits to database, returns the object in question. 
	#<User id: 2, name: "A Nother", email: "another@example.org", created_at: "2014-07-24 01:05:24", updated_at: "2014-07-24 01:05:24">

	> # Finding 
	> User.find(1) # by id
	> User.find_by(:name => "vijit") # by any of the attributes
	> User.first
	> User.all # returns all rows

	> #Update attributes
	> user.name = "yoyo"
	> user.save
	> # Method 2
	> user.update_attributes(:name => "yo") # saves as well. 


-- User Validations 
- Update test/models/user_test.rb to add a basic setup method to test a happy case
- bundle exec rake test:models
- add test case to check that user.valid? is false if either name or email are blank
- # test fails here.
- Update /app/models/user.rb with : validate :name, presence: true # and same for email
- # now test should pass.
- # user.error.full_messages would show the error thrown on validation. 

-- Add length validations
- add test case to check that user.valid? is false if name or email exceeds their maximum length
- Update /app/models/user.rb with : validate :name, length: {maximum: 50 }# and same for email
- # now test should pass.
- # user.error.full_messages would show the error thrown on validation. 

-- Add format validations
- Add test cases to accept valid and reject invalid addresses. # tells about the %w[] format which converts strings to arrays without using ""
- tests should fail now
- use rubular to create the valid regex
- add format: { with: VALID_EMAIL_REGEX } in the user.rb file
- tests shold pass now. 

-- Add uniqueness validations to model
- Add a test case by duplicating @user and doing @user.save and then testing valid on duplicate_user
- Test should fail
- Add uniqueness: { case_sensitive: false } in the user.rb
- Test should pass. 

-- Add uniqueness validations to database and index to email field
- rails generate migration add_index_to_users_email
- add_index :users, :email, unique: true to the migration file generated. 
- bundle exec rake db:migrate
- bundle exec rake test:models
- # test should fail at this time
- # delete tests/fixtures/user.yml content
- # test should pass now
- add to user.rb : before_save { self.email = email.downcase } since some database are case-sensitive in making indexes

-- Add hashed password
- rails generate migration add_password_digest_to_users password_digest:string
- bundle exec rails db:migrate
- add to Gemfile : bcrypt
- bundle install
- add has_secure_password to user.rb
- # now tests should fail
- add password and password_confirmation in the @user in the test fiel
- # now tests should pass. 

-- Add minimum password length
- validates :password, length: { minimum: 6 } to user.rb

-- Creating and authenticating a user
- rails console
	> User.create(name: "Michael Hartl", email: "mhartl@example.com", password: "foobar", password_confirmation: "foobar")
	> user = User.find_by(email: "mhartl@example.com")
	> user.password_digest
	> user.authenticate("okok")
	=> false
	> user.authenticate("foobar")
	=> # Returns the user here
	> !!user.authenticate("foobar")
	=> true

-- Pushing to heroku
- git push heroku
- heroku run rake db:migrate # NEED to run db migration in heroku
- heroku run console --sandbox # verify by running this and then creating a user. 

DONE. 

