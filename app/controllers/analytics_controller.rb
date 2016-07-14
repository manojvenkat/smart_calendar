class AnalyticsController < ApplicationController

  def index
    dates = ((Date.today-5.days)..(Date.today+5.days)).to_a
    @dates = []
    dates.each do |date|
      @dates << date.strftime("%B %d, %Y")
    end

    users = User.all
    @data = []
    users.each do |user|
      @data << {name: user.name, data: user.events_summary(dates)}
    end
  end
end