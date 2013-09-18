require "spec_helper"

describe AreasController do
  it { get("/areas").should route_to("areas#index") }
end
