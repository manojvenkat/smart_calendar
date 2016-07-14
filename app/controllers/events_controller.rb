class EventsController < ApplicationController
  before_action :logged_in_user

  def new
    @event = current_user.events.new
  end

  def create
  	event_params = params[:event]
  	event_params[:start_time] = process_date_time_string(event_params[:start_time])
  	event_params[:end_time] = process_date_time_string(event_params[:end_time])
  	event_params[:user_id] = current_user.id
  	@event = Event.new(event_params.permit!)
  	@event.save!
    Event.delay.generate_repeat_events(event_params)
  	redirect_to user_path(current_user)
  end


  private 

  def process_date_time_string(date_time_string, only_date = false)
    date_string, time_string = date_time_string.split(' ')
    date = date_string.to_time.in_time_zone.beginning_of_day

    num_hours, num_mins = time_string.split(':')
    date_time = date + num_hours.to_i.hours + num_mins.to_i.minutes
    only_date ? date.to_date : date_time
  end

end