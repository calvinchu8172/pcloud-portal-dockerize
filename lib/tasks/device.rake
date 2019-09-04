namespace :device do
  task :register => :environment do
    
    rake_log = Services::RakeLogger.rails_log
    
    if Rails.env == 'development' || 'test'
      url = 'http://' + Settings.environments.api_domain + '/d/3/register'
    elsif Rails.env == 'production'
      url = 'https://' + Settings.environments.api_domain + '/d/3/register'
    end

    rake_log.info url

    params = {
      mac_address: '0023F8311041',
      serial_number: 'TEMPSERIALNUM0000',
      model_name: 'NAS540',
      firmware_version: '540_datecode_20150615_myZyXELCloud-Agent_1.0.0',
      signature: Settings.device.TEMPSERIALNUM0000.signature,
      algo: '1',
      certificate_serial: '1002',
      module: '[{"name":"DDNS", "ver":"1" }, {"name":"pairing", "ver":"button"}, {"name":"upnp", "ver":"2" }, {"name":"indicator", "ver":"1" }, {"name":"package", "ver":"1" }]'
    }
      
    data = RestClient.post( url, params )
    data = JSON.parse(data)
    rake_log.info data
  end

  task :unpair => :environment do
  end  
end