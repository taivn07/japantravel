class APIResponse
  attr_accessor :status, :data

  def initialize status, data = nil
    self.status = status
    self.data = data
  end
end