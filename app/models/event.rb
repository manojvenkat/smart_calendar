class Event < ActiveRecord::Base
  attr_accessor :repeat
  belongs_to :user

  validates_presence_of :name, :description, :start_time, :end_time, :user_id
  validate :verify_start_end_times

  module RepeatCycle
    DAILY = 1
    WEEKLY = 2
    MONTHLY = 3
  end

  module Constants
    NUM_EVENTS = 5
  end

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

  def self.generate_repeat_events(event_params)
    event_duration = event_params[:end_time] - event_params[:start_time]
    start_end_times = case event_params[:repeat].to_i
    when RepeatCycle::DAILY
      generate_start_end_times_array(event_params[:start_time], event_duration, 1.day)
    when RepeatCycle::WEEKLY
      generate_start_end_times_array(event_params[:start_time], event_duration, 1.week)
    when RepeatCycle::MONTHLY
      generate_start_end_times_array(event_params[:start_time], event_duration, 1.month)
    else
      []
    end

    start_end_times.each do |s_e|
      Event.create!(user_id: event_params[:user_id], name: event_params[:name], description: event_params[:description], start_time: s_e[0], end_time: s_e[1])
    end
  end

  def self.generate_start_end_times_array(event_start_time, event_duration, repeat_duration)
    start_end_times = []
    start_time = event_start_time
    (1..(Constants::NUM_EVENTS)).each do |i|
      start_time += repeat_duration
      start_end_times << [start_time, start_time + event_duration]
    end
    start_end_times
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
