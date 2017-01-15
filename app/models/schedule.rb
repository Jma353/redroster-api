# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  term       :string
#  name       :string
#  is_active  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Schedule < ActiveRecord::Base
  # References
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :schedule_elements, class_name: "ScheduleElement", dependent: :destroy

  # Validations
  validates :user_id, presence: true
  validates :term, presence: true
  validates :name, presence: true
  validate :user_exists, :on => :create
  validate :local_name_unqiueness, :if => :updating? # Will deal with this later
  validate :local_name_unqiueness, :on => :create

  def updating?
    @updating
  end


  def user_exists
    errors[:base] << ("This user does not exist") unless !User.find_by_id(self.user_id).blank?
    return true
  end


  def local_name_unqiueness # name: self.name, user_id: self.user_id
    fail_condition = Schedule.where("name = ? AND user_id = ?",
      self.name, self.user_id)
    errors[:base] << "You already have a schedule with this name" unless fail_condition.empty?
    return true
  end


  def change_name(name)
    self.update_attributes(name: name)
    return false unless valid?
    save!
  end





end
