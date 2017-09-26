class Template < ActiveRecord::Base

  has_many :template_contents, dependent: :destroy

  validates :identity, uniqueness: true
  validates :identity, format: { with: /\A([a-zA-Z\d][\w\-]{1,254}|[a-zA-Z\d])\z/, message: 'only allows letters' }


  def en_template_content
    template_contents.find{ |x| x.locale == 'en' }
  end
end
