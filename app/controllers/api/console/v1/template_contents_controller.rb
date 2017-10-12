class Api::Console::V1::TemplateContentsController < Api::Base
  def index
    @data = TemplateContent.includes(:template).map{ |template_content|
      template_content.attributes.merge({
        identity: template_content.template.identity
      })
    }.sort_by{ |x| x[:identity] }
    render json: { data: @data }, status: 200
  end
end
