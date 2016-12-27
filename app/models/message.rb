class Message < ActiveRecord::Base
  belongs_to :user
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  paginates_per 15
  include AASM

  scope :for_user, ->(user) { where(user_id: user.id) }
  scope :for_state, ->(state) { where(aasm_state: state) }
  aasm do
    state :new, :initial => true
    state :working, :completed, :not_relevanted

    event :work do
      transitions :from => :new, :to => :working
    end

    event :complete do
      transitions :from => :working, :to => :completed
    end

    event :not_relevanted do
      transitions :from => [:new, :working], :to => :not_relevanted
    end
  end
end
