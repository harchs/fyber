class Offer < ModelBase
  class << self
    def all(params)
      puts '*' * 100
      puts params
      ApiTalk.get(params)
    end
  end
end