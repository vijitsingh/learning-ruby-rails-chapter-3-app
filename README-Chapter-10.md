

=== adding Account Activation Resource: https://www.railstutorial.org/book/account_activation_password_reset#sec-account_activations_resource

-- Add AccountActivation controller
-rails generate controller AccountActivations
- add resources :account_activations, only: [:edit] to routes.rb

-- Add activation resources to User model
- rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:datetime
- Update the file to add default:false - add_column :users, :activated, :boolean, default: false
- bundle exec rake db:migrate

-- Populate and save activation_digest before user creation
- Add a method :create_activation_digest in user-model which populates activation_digest and activation_token using User.new_token and User.digest
- Add before_create :create_activation_digest
- # Note that just assigning self.activation_digest the value is sufficient and since it is a field in the model, it would automatically get saved when user is saved. 
- Add the attr_accessor :activation_token 

-- Add activated and activated_at for all default users (in seed and in test/fixtures)
- Add activated:true to all records.
- Add activated_at: Time.zone.now to all records. 
- bundle exec rake db:migrate:reset
- bundle exec rake db:seed

=== 10.1.2 Account Activation Mailer Method : https://www.railstutorial.org/book/account_activation_password_reset#sec-account_activation_mailer

-- Generate UserMailer
- rails generate mailer UserMailer account_activation password_reset
- In app/mailers/user_mailer.rb : 
  * update account_activation method to accept a user variable. 
  * update mail_to link to point to mail to: user.email, subject: "Account activation" and set @user = user

-- Update the views for mails
- In app/views/user_mailer/account_activation.text.erb and app/views/user_mailer/account_activation.html.erb, update link to click to activate account to : edit_account_activation_url(@user.activation_token, email: @user.email) and <%= link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email) %> respectively. 

-- Update Configs for mails in config/environments/development.rb and test.rb
- For development, host is "localhost:3000" while for test.rb it is "example.com" . Copy pasted some extra configuration for each. 

-- Update test/mailers/previews/user_mailer_preview.rb
- Firstly restart server so that the preview file is generated.
- user = User.first 
  user.activation_token = User.new_token 
  UserMailer.account_activation(user) 
- After this go to http://localhost:3000/rails/mailers/user_mailer/account_activation and preview would be shown. 

-- Update test for test/mailers/user_mailer_test.rb 
- Add steps as done for preview above with user = users(:batman)
- bundle exec rake test:mailers should pass

-- Update the create method of user_controller
- If save is successful, then UserMailer.account_activation(@user).deliver_now and remove log_in user part. Update message and redirect to root_url
- Now tests should fail, so for time-being comment out the failing assertions (redirection one) from test/integration/user_signup_test.rb 

-- Go to server and try to sign-up, now the mail would NOT be sent in development but should get logged in server-logs at log/development.log. 

=== 10.1.3 Activating the Account : https://www.railstutorial.org/book/account_activation_password_reset#sec-activating_the_account

- Update authenticated?(attribute, token) in app/models/user.rb. Then call digest = self.send("#{attribute}_digest"). NOTE the send method here.
- Update usage of authenticated? in app/helpers/sessions_helper.rb 

-- Add edit method
- in account_activation_controller.rb
- check for if user && !user.activated? && user.authenticated?(:activation, params[:id]), if true then : 
  * update :activated and :activated_at attributes. 
  * log_in and update the message and redirect to user
- if it fails then show warnig and redirect to root url 

- Update create method in session_controller and add an extra if condition in happy-case to create only if user.activated? else ask them to check their mail and redirect to root_url . 

- Verify this whole flow by creating a new user. NOTE that at this point the mails are NOT actually sent as this is development database, but you would verify by actually taking the url to hit from the log and making sure the account gets activated properly. 

=== 10.1.4 Activation Test and Refactoring : https://www.railstutorial.org/book/account_activation_password_reset#sec-activation_test_and_refactoring

-- Went through it, decided to skip. Nothing much except one setup def for clearing ActionMailer::Base.deliveries.clear which is a global array.


=== 10.2.1 Password Reset Resource : https://www.railstutorial.org/book/account_activation_password_reset#sec-password_resets_resource

- rails generate controller PasswordResets new edit --no-test-framework. # NOTE the usage of --no-test-framework as we do NOT want to generate tests here as we woud test in integration level instead. 
- resources :password_resets, only: [:new, :create, :edit, :update] in routes.rb
- <%= link_to "(forgot password)", new_password_reset_path %> in the session/new.html.erb form
- rails generate migration add_reset_to_users reset_digest:string reset_sent_at:datetime
- bundle exec rake db:migrate

=== 10.2.2 Password resets controller and form : https://www.railstutorial.org/book/account_activation_password_reset#sec-password_resets_controller_and_form

- Added app/views/password_resets/new.html.erb . this is very similar to the submit form. just copied from here only
- Added 2 methods create_reset_digest and send_password_reset_mail in app/model/user.rb
- In create method of password_resets_controller, 
  *  @user = User.find_by(email: params[:password_reset][:email].downcase)
  * if user is present then call above two methods and then redirect to root_url with some message
  * if not correct user, then show message and render 'new'
- ADd :reset_token in attr_accessor of user.rb model
- At this point behavior for invalid email submissiosn should work. 

=== 10.2.3 Password Reset Mailer method : https://www.railstutorial.org/book/account_activation_password_reset#sec-password_reset_mailer

- Exact same steps as used for setting up account_activation mailer above. 

=== 10.2.4 Resetting the password : https://www.railstutorial.org/book/account_activation_password_reset#sec-resetting_the_password

-- Add edit form and controller
- Copied the edit form with password and confirmation as 2 fields. However added a hidden field for email so that update method know which email to update. Note that used : hidden_field_tag :email, @user.email instead of f.hidden_field :email, @user.email because the reset link puts the email in params[:email], whereas the latter would put it in params[:user][:email].
- Added 2 helper private methods in reset-controller, get_user and valid_user (@user && @user.activated? && @user.authenticated?(:reset, params[:id])) and call them before :edit and :update actions. 
- The form renders now if you generate and hit the reset url .

-- Add update method in controller
- https://www.railstutorial.org/book/account_activation_password_reset#code-password_reset_update_action shows the changes made. 
- Add password_reset_expired? method in user-model : reset_sent_at < 2.hours.ago 
- password reset should work now. 

=== 10.2.5 https://www.railstutorial.org/book/account_activation_password_reset#sec-password_reset_test 
- SKIPPING

=== 10.3 Email in production https://www.railstutorial.org/book/account_activation_password_reset#sec-email_in_production

- Followed the exact steps as in link above. It took like 10 mins for the email to come.
- More information on sendgrid : https://devcenter.heroku.com/articles/sendgrid

DONE. 
