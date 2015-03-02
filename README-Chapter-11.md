
=== 11.1 A micropost model : https://www.railstutorial.org/book/user_microposts#sec-a_micropost_model
 
-- 11.1.1 Creating the basic model https://www.railstutorial.org/book/user_microposts#sec-the_basic_model
- rails generate model Micropost content:text users:references
- Modify db/migrate/20150302090636_create_microposts.rb to add add_index :microposts, [:user_id, :created_at]
- bundle exec rake db:migrate

-- 11.1.2 Adding Micropost validations
- Add validates :user_id, presence: true and validates :content, presence: true, length: {maximum: 140} to micropost model
- I did NOT added the tests, though they have shown. 

-- 11.1.3 User/Micropost Associations : https://www.railstutorial.org/book/user_microposts#sec-user_micropost_associations
- Add has_many :microposts to user model. 
- I did NOT added the tests, though they have shown right way to do that.
- Also shows how to use methods created as per associations for creating Microposts in the right way. Use : user.microposts.create user.microposts.create! user.microposts.build instead of Micropost.create Micropost.create! Micropost.new . 

-- 11.1.4 Micropost Refinements : Adding ordering https://www.railstutorial.org/book/user_microposts#sec-ordering_and_dependency
- Add default_scope -> { order(created_at: :desc) } in micropsot.rb model 
- Add fixtures and verify that the test assert_equal Micropost.first, microposts(:most_recent) passes. 

-- Add destroy dependent association 
- Update has_many :microposts, dependent: :destroy in user.rb model. 
- I did NOT added the tests, though they have shown right way to do that.

=== 11.2 Showing Microposts https://www.railstutorial.org/book/user_microposts#sec-showing_microposts

-- 