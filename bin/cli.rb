require 'tty-prompt'
require 'pry'


class Cli
  
  def initialize
    font = TTY::Font.new(:doom)
    puts " "
    puts font.write("Welcome to Tweeter")
  end

  def main_menu
    prompt = TTY::Prompt.new
    choice = prompt.select("Would you like to sign in with your username or do you need to create an account?", ["Sign in", "Create an account"])
    if choice == "Sign in"
      user_name = prompt.ask("What is your username?")
    else
      full_name = prompt.ask("What is your full name?")
      user_name = prompt.ask("What would you like your username to be?")
      # DONE: see if username already exists, and if so, let user know that username is taken and ask for a different one
      if User.find_by(username: user_name)
        user_name = prompt.ask("Sorry but that username is already taken. Please choose a different username.")
        User.create(name: full_name, username: user_name)
      else
        User.create(name: full_name, username: user_name)
      end
      
    end
    user = User.find_by(username: user_name)
    menu_choice = prompt.select("Hello #{user.name}! What would you like to do?", ["Create a new tweet", "See all your tweets", "See most popular topic", "See all tweets for a topic", "Update a tweet", "Delete a tweet", "See all topics", "Exit"]) 
    case menu_choice
      when "Create a new tweet" then content = prompt.ask("What should your tweet say?"); 
      when "See all your tweets" then user.tweets.each {|tweet| puts tweet.message; puts "**********"}
      when "See most popular topic" then puts "Photography"
      when "See all tweets for a topic" then puts "some tweets"
      when "Update a tweet" then which = prompt.ask("Which tweet would you like to update?")
      when "Delete a tweet" then which = prompt.ask("Which tweet would you like to delete?")
      when "See all topics" then Topic.all.each {|topic| puts topic; puts "**********"}
      when "Exit" then exit
    end
    binding.pry
  end
end