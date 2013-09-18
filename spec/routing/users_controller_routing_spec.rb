require "spec_helper"

describe UsersController do
  it { post("/users/login/facebook").should route_to("users#login_with_facebook") }
  it { post("/users/logout").should route_to('users#logout') }
  it { post("/users/delete").should route_to("users#delete") }
end
