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
      User.create(name: full_name, username: user_name)
    end
    user = User.find_by(username: user_name)
    prompt.select("Hello #{user.name}! What would you like to do?", ["Create a new tweet", "See all your tweets", ] ) 
    binding.pry
  end
end