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
end