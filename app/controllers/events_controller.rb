# coding: utf-8

class EventsController < ApplicationController
  def show
    event = Event.event_detail params[:id]

    data = { event: event[0] } unless event.empty?

    respond_to_client data
  end
end
