# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'development'

  # geoip = GeoIP.new(Settings.geoip.db_path)

  # index = 0
  # while index < 30000 do 
  #   serial_number = Faker::Lorem.characters(13).upcase
  #   mac_address = Faker::Internet.mac_address.downcase.gsub(":", "")
  #   firmware_version = "V5.11(AATB.2)_myZyXELCloud-Agent_0104"
  #   product_id = [26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37].sample
  #   online_status = [0, 1].sample
  #   wol_status = [0, 1].sample
  #   fake_ip = Faker::Internet.ip_v4_address
  #   ip_address = IPAddr.new(fake_ip).to_i.to_s(16).rjust(8, "0")
  #   location = geoip.country(fake_ip)    
  #   country = location.country_code2 if location.country_code2 != '--'

  #   Device.create(
  #     serial_number: serial_number, 
  #     mac_address: mac_address, 
  #     firmware_version: firmware_version, 
  #     product_id: product_id,
  #     online_status: online_status,
  #     wol_status: wol_status,
  #     ip_address: ip_address,
  #     country: country
  #     ) 
  #   puts index
  #   index += 1
  # end


  Product.create( id: 26 ,name: 'NSA310S' ,model_class_name: 'NSA310S' ,created_at: '2014-10-07 10:49:47' ,updated_at: '2014-10-07 10:49:47' ,asset_file_name: 'device_icon_gray_1bay.png' ,asset_content_type: 'image/png' ,asset_file_size: 2497 , asset_updated_at: '2014-10-04 12:28:07' , pairing_file_name: 'animate_1bay_blue.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 10243 , pairing_updated_at: '2014-10-04 12:28:08' )
  Product.create( id: 27 ,name: 'NSA320S' ,model_class_name: 'NSA320S' ,created_at: '2014-10-07 10:49:47' ,updated_at: '2015-11-25 02:26:16' ,asset_file_name: 'NAS326-01.png' ,asset_content_type: 'image/png' ,asset_file_size: 114210 , asset_updated_at: '2015-11-25 02:26:13' , pairing_file_name: 'NAS326.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 10756 , pairing_updated_at: '2015-11-25 02:26:16' )
  Product.create( id: 28 ,name: 'NSA325' ,model_class_name: 'NSA325' ,created_at: '2014-10-07 10:49:47' ,updated_at: '2015-11-25 02:27:28' ,asset_file_name: 'NSA-325_01.png' ,asset_content_type: 'image/png' ,asset_file_size: 201642 , asset_updated_at: '2015-11-25 02:27:25' , pairing_file_name: 'NSA325.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 14480 , pairing_updated_at: '2015-11-25 02:27:28' )
  Product.create( id: 29 ,name: 'NSA325 v2' ,model_class_name: 'NSA325 v2' ,created_at: '2014-10-07 10:49:47' ,updated_at: '2015-11-25 02:26:41' ,asset_file_name: 'NAS326-01.png' ,asset_content_type: 'image/png' ,asset_file_size: 114210 , asset_updated_at: '2015-11-25 02:26:37' , pairing_file_name: 'NAS326.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 10756 , pairing_updated_at: '2015-11-25 02:26:41' )
  Product.create( id: 30 ,name: 'NAS540' ,model_class_name: 'NAS540' ,created_at: '2014-10-07 10:49:47' ,updated_at: '2015-11-25 02:27:48' ,asset_file_name: 'NAS540-01.png' ,asset_content_type: 'image/png' ,asset_file_size: 145554 , asset_updated_at: '2015-11-25 02:27:45' , pairing_file_name: 'NAS540.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 12811 , pairing_updated_at: '2015-11-25 02:27:48' )
  Product.create( id: 31 ,name: 'NBG6816' ,model_class_name: 'NBG6816' ,created_at: '2014-10-07 10:49:47' ,updated_at: '2015-11-25 02:29:03' ,asset_file_name: 'NBG6816.png' ,asset_content_type: 'image/png' ,asset_file_size: 19761 , asset_updated_at: '2015-11-25 02:29:03' , pairing_file_name: 'NBG6816.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 9598 , pairing_updated_at: '2015-11-25 02:29:03' )
  Product.create( id: 32 ,name: 'NAS520' ,model_class_name: 'NAS520' ,created_at: '2015-04-27 02:42:32' ,updated_at: '2015-11-25 02:28:10' ,asset_file_name: 'NAS520-01.png' ,asset_content_type: 'image/png' ,asset_file_size: 143927 , asset_updated_at: '2015-11-25 02:28:06' , pairing_file_name: 'NAS520.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 12167 , pairing_updated_at: '2015-11-25 02:28:10' )
  Product.create( id: 33 ,name: 'NBG6716' ,model_class_name: 'NBG6716' ,created_at: '2015-04-28 09:38:44' ,updated_at: '2015-11-25 02:29:21' ,asset_file_name: 'NBG6716.png' ,asset_content_type: 'image/png' ,asset_file_size: 23394 , asset_updated_at: '2015-11-25 02:29:21' , pairing_file_name: 'NBG6716.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 12906 , pairing_updated_at: '2015-11-25 02:29:21' )
  Product.create( id: 35 ,name: 'NAS326' ,model_class_name: 'NAS326' ,created_at: '2015-06-12 03:12:13' ,updated_at: '2015-11-25 02:27:05' ,asset_file_name: 'NAS326-01.png' ,asset_content_type: 'image/png' ,asset_file_size: 114210 , asset_updated_at: '2015-11-25 02:27:01' , pairing_file_name: 'NAS326.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 10756 , pairing_updated_at: '2015-11-25 02:27:05' )
  Product.create( id: 36 ,name: 'NAS542' ,model_class_name: 'NAS542' ,created_at: '2015-07-15 06:00:44' ,updated_at: '2015-11-25 02:28:38' ,asset_file_name: 'NAS540-01.png' ,asset_content_type: 'image/png' ,asset_file_size: 145554 , asset_updated_at: '2015-11-25 02:28:34' , pairing_file_name: 'NAS540.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 12811 , pairing_updated_at: '2015-11-25 02:28:38' )
  Product.create( id: 37 ,name: 'NBG6815' ,model_class_name: 'NBG6815' ,created_at: '2015-11-04 06:47:58' ,updated_at: '2015-11-25 02:29:39' ,asset_file_name: 'NBG6815.png' ,asset_content_type: 'image/png' ,asset_file_size: 13430 , asset_updated_at: '2015-11-25 02:29:39' , pairing_file_name: 'NBG6815.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 8094 , pairing_updated_at: '2015-11-25 02:29:39' )
  Product.create( id: 38 ,name: 'NBG6817' ,model_class_name: 'NBG6817' ,created_at: '2015-11-25 02:30:56' ,updated_at: '2016-03-01 05:46:45' ,asset_file_name: 'NBG6817.png' ,asset_content_type: 'image/png' ,asset_file_size: 2792 , asset_updated_at: '2016-03-01 05:46:45' , pairing_file_name: 'NBG6817.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 13710 , pairing_updated_at: '2016-03-01 05:46:45' )
  Product.create( id: 39 ,name: 'NBG6617' ,model_class_name: 'NBG6617' ,created_at: '2016-03-01 05:43:30' ,updated_at: '2016-03-01 05:43:30' ,asset_file_name: 'NBG6617.png' ,asset_content_type: 'image/png' ,asset_file_size: 1811 , asset_updated_at: '2016-03-01 05:43:29' , pairing_file_name: 'NBG6617.gif' , pairing_content_type: 'image/gif' , pairing_file_size: 8861 , pairing_updated_at: '2016-03-01 05:43:30' )
  Domain.create(domain_name: Settings.environments.ddns)

  # Api::Certificate.create(serial: "example_serial", content:"-----BEGIN CERTIFICATE-----
  # MIIGTzCCBDegAwIBAgICEAAwDQYJKoZIhvcNAQELBQAwgbExCzAJBgNVBAYTAlRX
  # MQ8wDQYDVQQIDAZUYWl3YW4xEDAOBgNVBAcMB0hzaW5DaHUxIjAgBgNVBAoMGVp5
  # WEVMIGNvbW11bmljYXRpb24gY29ycC4xGzAZBgNVBAsMEkNsb3VkIEFwcGxpYW5j
  # ZSBCQzEYMBYGA1UEAwwPbXlaeVhFTENsb3VkIENBMSQwIgYJKoZIhvcNAQkBFhVj
  # bG91ZGFkbUB6eXhlbC5jb20udHcwHhcNMTQxMDE0MDYwMjA5WhcNMTgxMDE0MDYw
  # MjA5WjCBsDELMAkGA1UEBhMCVFcxDzANBgNVBAgMBlRhaXdhbjEQMA4GA1UEBwwH
  # SHNpbkNodTEiMCAGA1UECgwZWnlYRUwgY29tbXVuaWNhdGlvbiBjb3JwLjENMAsG
  # A1UECwwEQ0FCQzElMCMGA1UEAwwcbXlaeVhFTENsb3VkIGludGVybWVkaWF0ZSBD
  # QTEkMCIGCSqGSIb3DQEJARYVY2xvdWRhZG1Aenl4ZWwuY29tLnR3MIICIjANBgkq
  # hkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA3QNj4mwsBv49Zh7pDi1PDr0/HH9koD0J
  # 2rgLtUcr6vfoHiVrITSjPUMg0dK7ipRCajBbVJ+9Yq9kfs7ocBJjinhWqSrnzNUz
  # nswqPTSw2aj0Xxau8f60GFmx74qDGPQeVkWWumXCZYdahUJOKADv2rvbcqsggd2p
  # JE6hACuC7xco9W4Arvf+nNazrZjWwRy2y5hSjPe6IN8Y2gmufwRW8J9nzU1T72ox
  # jMYbPMN38t2TAMTUIAZ08soRPdSj4Aj2hp/1cn4W7FECyJ3s+DGflHS96YqAPHsi
  # fnqi/KsqIZ3c5xxCMsfuG7RFz8LNmf/GDxhotwktC965qgNxbr8xTNMreraAfKab
  # njLaVkpNIVqlICjbZFTvPnwG1pJmnlluO0BkYp6t+f7d3/InQPyAkkiYoWmrj2yX
  # wVTajWyRGSaD5T6rA/XIctZojrjDhjFoj9cnLBFScJLKTmqPOIOZKSL4uiKvrfqa
  # YTO3ss8ggKvLceBSRx1dpmA3VwlvO4j5LEuL1S4dlXgyDGm8X/GSUcQ5kaPmqc6f
  # CvbHuII+cnu+Kjbq18MSo4kjibnl2sfCCG7G2KsXsP5CDFHNWPr7JaOXLp7oumqv
  # xSRklTwgl8etJBaKV7hV7tc8yEzmjxgbgqnC+H+wfpdQvgd1ZK3esHwEn3OD7zEp
  # s14uS7Uc17MCAwEAAaNwMG4wHQYDVR0OBBYEFNBx+rl/NYLomZsDoTPHWCkHSH4m
  # MB8GA1UdIwQYMBaAFO5whKEaDw2m/1Or3EfYXg8K12T6MAwGA1UdEwQFMAMBAf8w
  # CwYDVR0PBAQDAgEGMBEGCWCGSAGG+EIBAQQEAwIBBjANBgkqhkiG9w0BAQsFAAOC
  # AgEAG6+F5l8Mru6/R7y18W9H1zFBE6oQU+YiuI5PoUjdkjcKVFHOsgKifsyfJ4J/
  # bVNvYhkijvDux139c3+JWm/SkxegTvRDl/SVwfe+XjE2wzMjgj/3ZNu/ZL92fAGh
  # tXUuzkoCV5GzXeVsebgV+HoPkvIzrK+4ezyufyLr9PwuYYw20Ck0xr97IdvWVCbI
  # gbHSjebUpKJ1/aV19wwpXrgw+VMSTe8Lrpt7WUxOinHBJ/zXrTYBqJyMhiklvDk5
  # kfB99I3o01FZUuaegG2dnZC76Vtt4oGtkZx9SC/zLT/1coBCXsjPm/R54USfnU0r
  # UgRKCX8g/s2tho1OHvDmoJyHI53oXEkFavA8lFk2nQfkalvLdKOMl0alApUE0ln2
  # Lbe0aMOYnSzjXwROXhHa609xM5hDfobi7AxR6anvCZYldog4Hv8P7Mbo+Kx97+op
  # ZuKh+4dcYPAe2yFn2lPxKGzlZvmw8yspVz3dPiGsKcY/kiAbdMq25mI90JP+/WrE
  # tIgz6pXx38PwJah89///v9t70AKZCwjjOzm1fUFPMJKFAJD61Ua3iZY1Ek52L1dQ
  # 1nwKx710Ciup7F1PQFUky5JP7MD9HmE+cIbs5Df8rNrgSqjF3uDjASrA9qM91kkF
  # znf3QDjNYZvULC96M8LxgZzvs/m1+ddXYNJ/lqDz4/3CovA=
  # -----END CERTIFICATE-----
  # ")

end


if Rails.env == 'test'

  sql = 'DROP DATABASE IF EXISTS mongooseim;'
  ActiveRecord::Base.connection.execute(sql)
  sql = 'CREATE DATABASE mongooseim;'
  ActiveRecord::Base.connection.execute(sql)
  sql = 'USE mongooseim;'
  ActiveRecord::Base.connection.execute(sql)
  sql = " CREATE TABLE `users` (
      `username` varchar(250) NOT NULL,
      `password` text NOT NULL,
      `pass_details` text,
      `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`username`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8; "
  ActiveRecord::Base.connection.execute(sql)

  sql = " CREATE TABLE `last` (
      `username` varchar(250) NOT NULL,
      `seconds` int(11) NOT NULL,
      `state` text NOT NULL,
      `last_signin_at` int(11),
      PRIMARY KEY (`username`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8; "
  ActiveRecord::Base.connection.execute(sql)
end
