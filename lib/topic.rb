class Topic < ActiveRecord::Base
  has_many :tweet_topics
  has_many :tweets, through: :tweet_topics

  def tweet_count
    self.tweets.count
  end

  def self.most_popular_topic
    t = Topic.all.map{|topic| topic.tweet_topics}.max_by{|tt| tt.length}.first.topic_id
    topic = Topic.find(t)
    topic.name
  end
end