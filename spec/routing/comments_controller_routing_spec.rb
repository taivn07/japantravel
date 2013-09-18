require "spec_helper"

describe CommentsController do
  it { post("/comments/create").should route_to("comments#create_comment") }
  it { post("/comments/reply").should route_to("comments#create_reply") }
end
