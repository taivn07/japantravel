object @response
attributes :status

child :data => :data do
  node :message do
    @response.data.errors.inject({}){|h,(k,v)| h[k] = v; h}
  end
end