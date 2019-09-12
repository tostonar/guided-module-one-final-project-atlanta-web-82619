class User < ActiveRecord::Base
  has_many :tweets

  def create_tweet(tweet)
    Tweet.create(message: tweet, user_id: self.id)
  end

  def create_topic(topic)
    Topic.create(name: topic)
  end
<<<<<<< HEAD
=======

>>>>>>> master
end