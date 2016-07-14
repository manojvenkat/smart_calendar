class Event < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :description, :start_time, :end_time, :user_id
  validate :verify_start_end_times

  def self.generate_events_hash(user)
    events = user.events
    events_hash = []
    events.each do |event|
      hash = {}
      hash[:title] = event.name
      hash[:description] = event.description
      hash[:start] = event.start_time.to_s
      hash[:end] = event.end_time.to_s
      hash[:all_day] = event.all_day
      events_hash << hash
    end
    events_hash
  end

  private 

  def verify_start_end_times
    if (start_time >= end_time)
      errors.add(:start_time, "start_time can't be greater than end_time")
      errors.add(:end_time, "end_time should be greater than start_time")
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_time, :end_time, :user_id)
  end
end
