# coding: utf-8

class PlacesController < ApplicationController
  def index
    places = Place.with_area_id(params[:area_id]).page(set_offset).per(set_limit).sort_by(&:id)
    object = {places: places}

    render_template object
  end

  def show
    place = Place.get_place_info(params[:id])
    data = { place: place } unless place.nil?

    respond_to_client data
  end

  def get_comment
    comments = Place.get_place_comment params[:id], set_offset, set_limit
    data = { comments: comments[:data], comment_count: comments[:count] } unless comments.blank?

    respond_to_client data
  end

  def get_post
    posts = Place.get_place_post(params[:id], set_offset, set_limit)
    data = { posts: posts[:data], posts_count: posts[:count] } unless posts.blank?

    respond_to_client data
  end

  def search
    results = Place.solr_search(params[:q], set_offset, set_limit)
    data = { places: results } unless results.empty?

    respond_to_client data
  end
end
