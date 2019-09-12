require 'tty-prompt'
require 'pry'


class Cli
  
  def initialize
    font = TTY::Font.new(:doom)
    puts " "
    puts font.write("Welcome to Tweeter")
  end

  def run
    prompt = TTY::Prompt.new
    choice = prompt.select("Would you like to sign in with your username or do you need to create an account?", ["Sign in", "Create an account", "Exit"])
    case choice
    when "Sign in"
      user_name = prompt.ask("What is your username?")
    when "Create an account"
      full_name = prompt.ask("What is your full name?")
      user_name = prompt.ask("What would you like your username to be?")
      # DONE: see if username already exists, and if so, let user know that username is taken and ask for a different one
      if User.find_by(username: user_name)
        user_name = prompt.ask("Sorry but that username is already taken. Please choose a different username.")
        User.create(name: full_name, username: user_name)
      else
        User.create(name: full_name, username: user_name)
      end
    when "Exit"
        exit
    end
    user = User.find_by(username: user_name)
    menu_options(user)

  end

  def menu_options(user)
    font = TTY::Font.new(:doom)
    puts " "
    puts font.write("tweeter")
    puts user.last_five_tweets_by_follows
    prompt = TTY::Prompt.new
    menu_choice = prompt.select("Hello #{user.name}! What would you like to do?", ["Tweets", "Follows", "Topics", "Logout", "Exit"]) 
    case menu_choice
      when "Tweets"
        tweet_options(user)
      when "Follows"
        follow_options(user)
      when "Topics"
        topic_options(user)
      when "Logout"
        self.run
      when "Exit" 
        # binding.pry
        exit
    end
    return self.menu_options(user)
  end

  def tweet_options(user)
    font = TTY::Font.new(:doom)
    puts " "
    puts font.write("tweets")
    prompt = TTY::Prompt.new
    menu_choice = prompt.select("Howdy #{user.name}! What would you like to do?", ["Create a new tweet", "See all your tweets", "See all tweets for a topic", "Update a tweet", "Delete a tweet", "Exit"])
    case menu_choice
    when "Create a new tweet" 
      content = prompt.ask("What should your tweet say?"); 
      cat = prompt.ask("What topic is your tweet?")
      tw= Tweet.create(user_id: user.id, message: content)
      # DONE: see if topic already exists, if not then create new topic, and associate that topic with your tweet 
      to = Topic.find_or_create_by(name: cat)
      TweetTopic.create(tweet_id:tw.id, topic_id:to.id)
    all_topics = Topic.all  
    when "See all your tweets" 
      if user.tweets.empty?
        puts "You do not have any tweets to view."
          return self.tweet_options(user)
      else
      user = User.find(user.id)
      user.tweets.each {|tweet| puts "You tweeted: " + tweet.message + " at " + tweet.created_at.strftime("%I:%M %p") + " on " + tweet.created_at.strftime("%d/%m/%Y"); puts "******************************************"}
      end
    when "See all tweets for a topic" 
      which_topic = prompt.select("Which topic?", Topic.all.map(&:name))
      topic = Topic.find_by(name: which_topic)
      topic.tweets.map(&:message).each {|x| puts x; puts "******************************************"}  
    when "Update a tweet" 
      # DONE:
      if user.tweets.empty?
        puts "Sorry, you do not have any tweets to update."
          return self.tweet_options(user)
      else
      which_tweet = prompt.select("Which tweet would you like to update?", user.tweets.map(&:message))
      tweet = Tweet.find_by(message: which_tweet)
      update = prompt.ask("What would like to update it to say?")
      tweet.update(message: update)
      end
    when "Delete a tweet" 
      # DONE: kinda works, but only after closing cli and reopening
      if user.tweets.empty?
        puts "Sorry, you do not have any tweets to delete."
          return self.tweet_options(user)
      else
      which_tweet = prompt.select("Which tweet would you like to delete?", user.tweets.map(&:message))
      tweet = Tweet.find_by(message: which_tweet)
      tweet.delete
      end
    when "Exit"
        return self.menu_options(user)
    end
  end

  def follow_options(user)
    font = TTY::Font.new(:doom)
    puts " "
    puts font.write("follow")
    prompt = TTY::Prompt.new
    menu_choice = prompt.select("Hola #{user.name}! What would you like to do?", ["Following", "Followers", "Follow Tweeters", "Exit"])
    case menu_choice
    when "Following"
      if user.follows.empty?
        puts "You are not following any tweeters! Select 'Follow Tweeters' to browse tweeters available to fallow!"
        return self.follow_options(user)
      else
      fallow = prompt.select("#{user.username} follows:", user.follows.map{|t| t.username})  
      follow_choice = User.all.find_by(username: fallow)
      choice = prompt.select("Options:",["Tweets by #{fallow}", "Followers of #{fallow}", "Exit"])
        if choice == "Tweets by #{fallow}"
        follow_choice.tweets.map{|tweet| puts tweet.message; puts "on " + tweet.created_at.strftime("%d/%m/%Y") + " at " + tweet.created_at.strftime("%I:%M %p") ; puts "***********************************************"}
        elsif choice == "Followers of #{fallow}"
        follower = prompt.select("#{fallow}'s followers:", follow_choice.followers.map{|f| f.username})
        user_follower = User.all.find_by(username: follower)
        choice2 = prompt.select("Options:", ["Tweets by #{follower}", "Exit"])
          if choice2 = "Tweets by #{follower}"
          user_follower.tweets.map{|tweet| puts tweet.message; puts "on " + tweet.created_at.strftime("%d/%m/%Y") + " at " + tweet.created_at.strftime("%I:%M %p") ; puts "***********************************************"}
          else 
          return self.follow_options(user)
          end
        else
        return self.follow_options(user)
        end
      end
    when "Followers"
      if user.followers.empty?
        puts "You have no followers! You probably have no friends!"
        return self.follow_options(user)
      else
      fallow = prompt.select("Your followers:", user.followers.map{|t| t.username})  
      fallow_choice = User.all.find_by(username: fallow)
      choice3 = prompt.select("Options:",["Tweets by #{fallow}", "Followers of #{fallow}", "Exit"])
        if choice3 == "Tweets by #{fallow}"
        fallow_choice.tweets.map{|tweet| puts tweet.message; puts "on " + tweet.created_at.strftime("%d/%m/%Y") + " at " + tweet.created_at.strftime("%I:%M %p") ; puts "***********************************************"}
        elsif choice3 == "Followers of #{fallow}"
        fallower = prompt.select("#{fallow}'s followers:", fallow_choice.followers.map{|f| f.username})
        user_follower = User.all.find_by(username: fallower)
        choice2 = prompt.select("Options:", ["Tweets by #{fallower}", "Exit"])
          if choice2 = "Tweets by #{fallower}"
          user_follower.tweets.map{|tweet| puts tweet.message; puts "on " + tweet.created_at.strftime("%d/%m/%Y") + " at " + tweet.created_at.strftime("%I:%M %p") ; puts "***********************************************"}
          else 
          return self.follow_options(user)
          end
        else
        return self.follow_options(user)
        end
      end
    when "Follow Tweeters"
      tweeters_minus_you = User.all.select{|u| u.username != user.username}
      tweeters_you_already_follow = user.follows
      tweeters_available_to_follow = tweeters_minus_you - tweeters_you_already_follow
      tweeter = prompt.select("Tweeters:", [tweeters_available_to_follow.map{|t| t.username}, "Exit"])
      if tweeter == "Exit"
        return self.menu_options(user)
      end
      choice = prompt.select("Would you like to fallow #{tweeter}", ["Yes", "No"])
      tweeter_user = User.all.find{|user| user.username == tweeter}
      if choice == "Yes"
        Follow.create(follower_id: user.id, followed_id: tweeter_user.id)
      else 
        return self.follow_options(user)
      end
    when "Exit"
      return self.menu_options(user)
    end
  end

def topic_options(user)
  font = TTY::Font.new(:doom)
    puts " "
    puts font.write("topics")
    prompt = TTY::Prompt.new
    menu_choice = prompt.select("Hell #{user.name}! What would you like to do?", ["See all topics", "See most popular topic", "See all tweets for a topic", "Exit"])
    case menu_choice
    when "See all topics" 
      Topic.all.each {|topic| puts topic.name.upcase; puts "**********"}
    when "See most popular topic" 
      puts Topic.most_popular_topic.upcase
    when "See all tweets for a topic" 
      which_topic = prompt.select("Which topic?", Topic.all.map(&:name))
      topic = Topic.find_by(name: which_topic)
      topic.tweets.map(&:message).each {|x| puts x; puts "******************************************"}  
    when "Exit"
      return self.menu_options(user)
    end
  end
end
