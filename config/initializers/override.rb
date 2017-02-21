module Paperclip
  class UrlGenerator
    private
    # Override Paperclip method to enable AWS Cloudfront Behavior Query String Whitelist setting.
    def timestamp_as_needed(url, options)
      if options[:timestamp] && timestamp_possible?
        delimiter_char = url.match(/\?.+=/) ? '&' : '?'
        "#{url}#{delimiter_char}timestamp=#{@attachment.updated_at.to_s}"
      else
        url
      end
    end
  end
end