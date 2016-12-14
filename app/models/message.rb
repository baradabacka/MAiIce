class Message < ActiveRecord::Base
  belongs_to :user
  include AASM

  scope :from_user_id, ->(id) { where(user_id: id) }
  scope :from_state_sort, ->(state) { where(aasm_state: state) }

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
