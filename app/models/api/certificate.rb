class Api::Certificate < ActiveRecord::Base

  def self.find_public_by_serial serial
    certificate = self.find_by serial: serial
    return OpenSSL::X509::Certificate.new(certificate.content).public_key
  end

  def data
    self.attributes.except("id", "content", "vendor_id")
  end
  
  def valid_content?
    begin
      OpenSSL::X509::Certificate.new(self.content)
    rescue => e
      puts "Error: Invalid Certificate Format => #{e}"
      return false
    end
    true
  end
end