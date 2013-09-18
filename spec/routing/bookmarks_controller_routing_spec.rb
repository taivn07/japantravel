# coding: utf-8

require 'spec_helper'

describe BookmarksController do
  it { post('/bookmarks').should route_to('bookmarks#create') }
  it { get('/bookmarks/spots').should route_to('bookmarks#get_bookmarked_spot')}
end
