class Api::Device::Lite < Api::Device
  include Redis::Objects
  attr_accessor :origin_id, #mac_address + serial_number
                :mac_address,
                :serial_number,
                :model_name,
                :firmware_version


  self.redis_prefix= 'device:lite'
  self.redis_id_field :origin_id

  hash_key :info, expiration: 30.seconds

  def initialize(params = {})
    params.each { |key, value| send "#{key}=", value }
    origin_id = mac_address + serial_number
  end

  def self.create(params = {})
    instance = self.new(params)
    instance.info.bulk_set(params)
  end
end