require "spec_helper"

describe PlacesController do
  it { get("/places/1/comments").should route_to("places#get_comment", "id" => "1") }
  it { get("/places/1/posts").should route_to("places#get_post", "id" => "1") }
  it { get("/places").should route_to("places#index") }
  it { get("/places/1").should route_to("places#show", "id" => "1") }
end
