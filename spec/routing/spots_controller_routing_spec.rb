require "spec_helper"

describe SpotsController do
  it { get("/spots/search").should route_to("spots#search", "format" => :json) }
  it { get("/spots").should route_to("spots#index") }
  it { get("/spots/1/posts").should route_to("spots#show_images", "id" => "1") }
  it { get("/spots/1").should route_to("spots#show", "id" => "1") }
end
