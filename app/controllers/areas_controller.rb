# coding: utf-8

class AreasController < ApplicationController
  def index
    areas = Area.all.sort_by(&:id)
    data = { areas: areas } unless areas.empty?

    respond_to_client data 
  end
end
