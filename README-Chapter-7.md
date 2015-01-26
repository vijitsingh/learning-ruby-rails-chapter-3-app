

-- Create a new branch

-- Rails environment 
- rails console production # to open in production environment
  > Rails.env
  => production
  > Rails.env.development?
  => false
  > Rails.env.test?
  => false
- rails server --environemnt production
- bundle exec rake db:migrate RAILS_ENV=production

-- Adding debug information on the page in development environment
- Add in the layout file : <%= debug(params) if Rails.env.development? %>
- Add some css class for debug_dump class. 

-- Adding Users resource
- add : resources :users to routes.rb
- add the show.html.erb file displaying name and email : @user.name
- add a show method in user_controller.rb with @user = User.find(params[:id])
- rails server

-- Using debugger
- Add debugger line in ruby code where ever you want to inspect
- shows a console on command-line
- Ctrl-D to release 

-- Adding Gravatar Image and Sidebar
- add a gravatar_for function in app/helpers/user_helpers.rb to compose gravatar url
- update users/show.html.erb to add gravatar and name in a side-bar. Also add css styles for it. 

-- Add a signup form
- bundle exec rake db:migrate:reset # Remove any existing users added through CLI, to start from beginning.
- add @user = User.new in the user_controller.rb#new method
- use form_for(@user) command to create form in app/views/users/new.html.rb
- add some css styles.
- rails server and your localhost:3000/submit page shows the form now. 

-- Unsuccessful signups
- Add a create method in the user_controller.rb to get @user = User.new(params[:user])
- Add a code to handle failure and success (nothing added here)
- Submit the form with wrong attributes.
- An error should be thrown on page. 
- Actually error would be thrown even if submitted with right attributes because mass-assignment like this is no more allowed in rails. 
- Add a private method sanitize_user_params to mention the permissible parameters
- Now submit again the parameters wrongly and no error is thrown but a redirect to a new submit page happens on wrong parameters. 

-- Add signup error messages 
- Add a partial _error_messages.html.erb in app/views/shared and import it from new.html.erb
- In the _error_messages.html.erb : 
  * use @user.errors.any? to render a div of errors.
  * pluralize(@user.errors.count, "error")
  * iterate using @user.errors_full_messages to render the errors
- Add appropirate styling.
- Now when you submit the form with wrong input, errors are shown on the page. 

-- Add invalid signup integration test
- rails generate integration_test users_signup
- In the test make a post request to "users/create" (users_path) with invalid parameters
- the value of User.count before and after shoudl be same
- also the template post request shoudl be "users/new" because of the redirection. 

-- Adding valid singup 
- in the if block when @user.save is successful in users_controller.rb
- redirect_to @user or redirect_to user_url(@user) # I am NOT 100% sure here how user_url work here. INVESTIGATE

-- Add Flash message
- Add flash[:success] on @user.save success
- In application.html.erb iterate over flash to show all messages. : <div class="alert alert-<%= message_type %>"><%= message %></div>

-- Add an integration test for successful signup
- use post_via_redirect commadn to add integration test in a similar way as created for unsuccessful signup.

-- Professional deployment 
- Submit changes and merge branch to master.
- To enable SSL uncomment the ssl force line in : config/environments/production.rb 
- Follow steps here to https://www.railstutorial.org/book/sign_up#sec-unicorn_in_production to use unicorn server on production. 

DONE. 