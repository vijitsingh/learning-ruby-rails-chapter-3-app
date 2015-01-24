

-- Adding a rails helper method
- Upate app/helpers/application_helper.rb to add a method to use only the base_title if page_title is not provided.
- Call this method from the layout. 
- Remove the Home from the title of the home page. Update test and remove the provide() call from the home.html.erb

-- Start Rails console
- rails console
>  # to_s method, converts any object to string
> num = 10
> num.to_s
> "10"

> nil.to_s
> ""
> nil.to_s.empty? # NOTE the chaining of methods here. 
> true

> nil.nil?
> true

> # nil is the only false object apart from false itself.
> # !! - bang bang , coerces any object to its boolean value IMPORTANT-CONCEPT 
> !!nil
> false
> !!false
> false
> !!0
> true

> def string_message(str = '')
> # here while calling the method, str argument could be skipped as a default value is provided. 
> Ruby returns by default the evaluated value of the last statement. 

> "foo bar".split
> ["foo", "bar"]
> "fooxbar".split("x")
>["foo", "bar"]
> arr = [1,2,3] # arr.first, arr.second, arr.last
> # arr.sort, arr.reverse, arr.empty?, arr.include?, arr.shuffle
> # arr.sort! to actually mutate array, none of the above ones do that. 
> arr.join
> "123"

> #Ranges
> 0..9
> 0..9
> (0..9).to_a # need to use parenthesis to call a method on it
> [0,1,2,3,4,5,6,7,8,9]

> # Hashes 
> {:name => "vijit", :age => 25}.each do |key, value|
>   puts "key is #{key.inspect} and value is #{value}"
> end
> # NOTE the usage of inspect method above which converts to a literal value of the object its called on. 

> h1 = { :name => "Michael Hartl", :email => "michael@example.com" }
=> {:name=>"Michael Hartl", :email=>"michael@example.com"}    
> h2 = { name: "Michael Hartl", email: "michael@example.com" }  # NOTE this is a shorthand 
=> {:name=>"Michael Hartl", :email=>"michael@example.com"} 
> h1 == h2
=> true

> stylesheet_link_tag ('application', { media: 'all', 'data-turbolinks-track' => true } )
> stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true 
> # Both above are the same method calls. 1) parenthesis are optional
> # 2) when hash is the last argument even {} are optional
> # 3) 2nd key-value uses old format as data-turbolinks-track : is invalid because of the curly-braces. 




