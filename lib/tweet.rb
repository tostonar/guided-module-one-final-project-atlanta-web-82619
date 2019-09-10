class Tweet < ActiveRecord::Base
    has_many :tweettopics
    has_many :topics, through: :tweettopics
    belongs_to :user
end