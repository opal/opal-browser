# stub the Browser::HTTP class and supported? method
# for running code server side with hyper-spec
module Browser
  class HTTP
    def self.supported?
      true
    end
  end
end
