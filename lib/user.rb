class User < ActiveRecord::Base
  has_many :tweets

  def create_tweet(tweet)
    Tweet.create(message: tweet, user_id: self.id)
  end

  def create_topic(topic)
    Topic.create(name: topic)
  end

  def follows
    Follow.all.select{|f| f.follower_id == self.id}.map{|f| f.followed_id}.map{|id| User.find(id)}.uniq
  end

  def followers
    Follow.all.select{|f| f.followed_id == self.id}.map{|f| f.follower_id}.map{|id| User.find(id)}.uniq
  end

  def tweets_by_follows 
    tweets = self.follows.map{|f| f.tweets}.flatten
  end

  def last_five_tweets_by_follows
    last_5 = self.follows.map{|u| u.tweets}.flatten.max_by(5){|tweet| tweet.created_at}
    last_5.map {|tweet| User.find(tweet.user_id).username + " tweeted " + tweet.message + " at " + tweet.created_at.strftime("%I:%M %p") + " on " + tweet.created_at.strftime("%d/%m/%Y")}
  end
end