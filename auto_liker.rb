require 'watir' # Crawler
require 'pry' # Ruby REPL
require 'rb-readline' # Ruby IRB
require 'awesome_print' # Console output
require_relative 'credentials' # Pulls in login credentials from credentials.rb

username = $username
password = $password
hashtags = $hashtags
like_counter = 0
# num_of_rounds = 0
MAX_LIKES = 100
start_time = Time.now

# Open Browser, Navigate to Login page
browser = Watir::Browser.new :chrome, switches: ['--incognito']
browser.goto "instagram.com/accounts/login/"

# Navigate to Username and Password fields, inject info
ap "Logging in..."
browser.text_field(:name => "username").set "#{username}"
browser.text_field(:name => "password").set "#{password}"

# Click Login Button
browser.button(:class => ['_5f5mN', 'jIbKX', 'KUBKM', 'yZn4P']).click
sleep(2)

# if browser.button(:class => "aOOlW   HoLwm ").exists?
#     browser.button(:class => "aOOlW   HoLwm ").click
# end


# Continuous loop to break upon reaching the max likes
# loop do
#   Scroll to bottom of window 3 times to load more results (20 per page)
#   3.times do |i|
#     browser.driver.execute_script("window.scrollBy(0,document.body.scrollHeight)")
#     sleep(1)
#   end

# Call all unliked like buttons on page and click each one.
#   sleep(2)
#   ap browser.divs(class: "_9AhH0").size
#   if browser.div(class: "_9AhH0").exists?
#     browser.divs(class: "_9AhH0").each do |val|
#       val.click
#       like_counter += 1
#     end
#     ap "Photos liked: #{like_counter}"
#   else
#     ap "No media to like rn, yo. Sorry homie, we tried."
#   end

hashtags.each do |hashtag|
    browser.goto "instagram.com/explore/tags/#{hashtag}/"

    if browser.div(class: "_9AhH0").exists?
    #   Scroll to bottom of window 3 times to load more results (20 per page)
        ap "#{browser.divs(class: "_9AhH0").size} posts in all"
        browser.divs(class: "_9AhH0").each do |val|
            val.click
            sleep(1)
            if browser.span(class: ["glyphsSpriteHeart__outline__24__grey_9", "u-__7"]).exists?
                browser.span(class: ["glyphsSpriteHeart__outline__24__grey_9", "u-__7"]).click
                like_counter += 1
            end
            sleep(1)
            if browser.button(class: "ckWGn").exists?
                browser.button(class: "ckWGn").click
            end
            sleep(1)
            ap "#{like_counter} posts liked"
            break if like_counter >= MAX_LIKES
        end
        ap "Liked #{like_counter} posts in #{(Time.now - start_time)/60} minutes"
    end
end


#   num_of_rounds += 1
#   puts "--------- #{like_counter / num_of_rounds} likes per round (on average) ----------"
#   break if like_counter >= MAX_LIKES
#   sleep(30) # Return to top of loop after this many seconds to check for new photos
# end

# Leave this in to use the REPL at end of program
# Otherwise, take it out and program will just end
Pry.start(binding)
