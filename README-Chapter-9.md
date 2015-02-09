

-- Add edit form
- Create a user_controller.rb # edit method with @user = User.find(params[:id])
- Create a edit.html.erb with almost same content as the new.html.erb except added stuff for gravatar
- # NOTE here the presence of this in form : <input name="_method" type="hidden" value="patch" />
- In settings link, add : <%= link_to "Settings", edit_user_path(current_user) %> . 

-- Handle unsuccessful edits
- Add a update method in user_controller.rb
- Add if @user.update_attributes(sanitize_user_params)
- render 'edit' in else. This is similar to the create method format
- Try submitting with incomplete parameters, and you could see the errors are shown because of the error_messages partial added. 

-- Testing unsuccessful edits
- rails generate integration_test users_edit
- Add a test case to verify that if incorrect parameters are submitted then again the users/edit template is rendered. 
- run rake test:integration which should pass. 

-- Successful edits handling
- In the if case of update method, add flash message and redirect_to @user similar to create method. 
- Add a test case to verify that flash message is non-empty on successful login, redirection happens to @user, and after @user.reload, parameters updage. 
- at this point of time test would fail because of empty password in the test # if user does NOT want to update password each time
- Add allow_blank : true with :password field in the user_model . # this would not allow blank password on account creation, as has_secure_password takes care of that. 
- now tests would pass. 

--
