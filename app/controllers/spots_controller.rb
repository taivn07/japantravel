# coding: utf-8

class SpotsController < ApplicationController
  def index
    spots = Spot.get_by_place(params[:place_id]).page(set_offset).per(set_limit)

    data = { spots: spots } unless spots.empty?

    respond_to_client data
  end

  def show
    spot = Spot.get_spot_info(params[:id], params[:user_id])

    data = { spot: spot } unless spot.nil?

    render_template data
  end

  def search
    fail = Spot.blank_validate params[:lat], params[:lng]

    spots = Spot.solr_search(params[:q], set_limit, set_offset, params[:lat], params[:lng]) if fail.blank?
    data = { spots: spots } unless spots.blank?

    respond_to_client data, fail
  end

  def show_images
    images = Spot.get_images(params[:id], set_limit, set_offset)

    data = {
      posts_count: images[:count],
      posts: images[:data]
    } unless images.blank?

    respond_to_client data
  end
end
