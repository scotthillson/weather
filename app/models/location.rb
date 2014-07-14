class Location < ActiveRecord::Base
  has_many :subscriptions
end