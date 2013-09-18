require "spec_helper"

describe PostsController do
  it { post('/posts/create').should route_to('posts#create_normal_post') }
  it { get("timeline").should route_to("posts#timeline") }
  it { post("/spots/checkins/create").should route_to('posts#create_checkin')}
end
