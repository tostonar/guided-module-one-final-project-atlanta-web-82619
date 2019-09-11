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
    menu_options(user)
    
    binding.pry
  end

  def menu_options(user)
    prompt = TTY::Prompt.new
    menu_choice = prompt.select("Hello #{user.name}! What would you like to do?", ["Create a new tweet", "See all your tweets", "See all topics", "See most popular topic", "See all tweets for a topic", "Update a tweet", "Delete a tweet", "Exit"]) 
    case menu_choice
      when "Create a new tweet" 
        content = prompt.ask("What should your tweet say?"); 
        cat = prompt.ask("What topic is your tweet?")
        tw= Tweet.create(user_id: user.id, message: content)
        # TODO: see if topic already exists, if not then create new topic, and associate that topic with your tweet 
        to = Topic.find_or_create_by(name: cat)
        TweetTopic.create(tweet_id:tw.id, topic_id:to.id)
        
      when "See all your tweets" 
        user.tweets.each {|tweet| puts tweet.message; puts "**********"}
      when "See most popular topic" 
        puts "Photography"
      when "See all tweets for a topic" 
        puts "some tweets"
      when "Update a tweet" 
        which = prompt.ask("Which tweet would you like to update?")
      when "Delete a tweet" 
        which = prompt.ask("Which tweet would you like to delete?")
      when "See all topics" 
        Topic.all.each {|topic| puts topic.name.upcase; puts "**********"}
      when "Exit" 
        exit
    end
    return self.menu_options(user)
  end
end