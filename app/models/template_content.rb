class TemplateContent < ActiveRecord::Base
  belongs_to :template

  validates :locale, inclusion: { in: ["cs", "de", "en", "es", "fr", "hu", "it", "nl", "pl", "ru", "th", "tr", "zh-TW"] }

  attr_accessor :identity

  def param_list 
    matches = self.content.scan(/\#\{([a-zA-Z]\w*)\}/)
    matches.flatten
  end

  def fit_params params
    t_content = self.content
    param_list.each do |p_name|
      t_content.gsub!('#{'+p_name+'}', params[p_name])
    end
    t_content
  end

end
