class TemplateContent < ActiveRecord::Base
  belongs_to :template

  validates :locale, inclusion: { in: ["cs", "de", "en", "es", "fr", "hu", "it", "nl", "pl", "ru", "th", "tr", "zh-TW"] }

  attr_accessor :identity

end
