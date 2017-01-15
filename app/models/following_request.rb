# == Schema Information
#
# Table name: following_requests
#
#  id          :integer          not null, primary key
#  user1_id    :integer
#  user2_id    :integer
#  sent_by_id  :integer
#  is_pending  :boolean
#  is_accepted :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FollowingRequest < ActiveRecord::Base
  # References
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_one :sent_by, class_name: "User"


  # Validations
  validates :user2_id, presence: true, numericality: { greater_than: :user1_id }
  validates :user1_id, presence: true, uniqueness: { scope: [:user2_id, :sent_by_id] }
  validate :is_valid, :on => :create


  # Default values
  before_create :default_values


  # Validation method
  def is_valid
    errors[:base] << "User 1 does not exist" unless User.exists?(self.user1_id)
    errors[:base] << "User 2 does not exist" unless User.exists?(self.user2_id)
    errors[:base] << "You cannot request to follow yourself" unless (self.user1_id != self.user2_id)
    errors[:base] << "The sent_by field doesn't match either user" unless (self.sent_by_id == self.user1_id || self.sent_by_id == self.user2_id)
    errors[:base] << "You are already following this person" unless FollowingRequest.find_by(user1_id: self.user1_id,
      user2_id: self.user2_id, sent_by_id: self.sent_by_id, is_pending: false, is_accepted: true).blank?
  end


  # Setting method for default values of the following_request
  def default_values
    # Order these assignments this way to avoid returning false
    self.is_accepted = false
     self.is_pending = true
  end


  # True if it's a valid user to react to the friend request
  def valid_reacting_user(u)
    (u.id == self.user1_id || u.id == self.user2_id) && u.id != sent_by_id
  end




end
