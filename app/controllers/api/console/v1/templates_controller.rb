class Api::Console::V1::TemplatesController < Api::Base
  include CheckParams
  include CheckSignature

  before_action do
    check_header_timestamp timestamp
  end

  before_action do
    check_header_signature signature
  end

  before_action do
    check_timestamp_valid timestamp
  end

  before_action do
    check_certificate_serial params
  end

  # before_action do
  #   check_signature_urlsafe template_params, signature
  # end

  before_action do
    check_signature_urlsafe template_params, signature
  end

  # before_action only: [:create] do
  #   check_params template_params, create_filter
  # end

  before_action only: [:create, :update] do
    check_params template_params, filter
  end

  before_action :find_template, only: [:show, :update, :destroy]

  def index
    data = Template.all.map do |tamplate|
      tamplate.attributes.merge({
        template_contents: tamplate.template_contents.map(&:attributes)
      })
    end
    render json: { data: data }.to_json, status: 200
  end

  def show
    data = @template.attributes.merge({
      template_contents: @template.template_contents.map(&:attributes)
    })
    render json: { data: data }.to_json, status: 200
  end

  def create
    create_params = template_params.delete_if {|key, value| key == "certificate_serial" }
    @template = Template.new(create_params)
    if @template.save
      data = @template.attributes.merge({
        template_contents: @template.template_contents.map(&:attributes)
      })
      render json: { data: data }.to_json, status: 200
    else
      render json: { message: @template.errors.full_messages.first }, status: 400
    end
  end

  def update
    update_params = template_params.delete_if {|key, value| key == "certificate_serial" }
    if @template.update(update_params)
      data = @template.attributes.merge({
        template_contents: @template.template_contents.map(&:attributes)
      })
      render json: { data: data }.to_json, status: 200
    else
      render json: { message: @template.errors.full_messages.first }, status: 400
    end
  end

  def destroy
    @template.destroy
    render nothing: true, status: 200
  end

  private

  def filter
    # ['identity', 'title_en', 'content_en']
    # ['identity', 'template_contents_attributes']
    required_params = []
    required_params = ['identity', 'template_contents_attributes'] if action_name.eql? "create"
    required_params = ['identity'] if action_name.eql? "update"
    required_params
  end

  # def template_params
  #   params.permit(:certificate_serial, :identity, :title_en, :content_en,
  #     :'title_zh-TW', :'content_zh-TW', :title_de, :content_de,
  #     :title_cs, :content_cs, :title_es, :content_es,
  #     :title_fr, :content_fr, :title_hu, :content_hu,
  #     :title_it, :content_it, :title_nl, :content_nl,
  #     :title_pl, :content_pl, :title_ru, :content_ru,
  #     :title_th, :content_th, :title_tr, :content_tr
  #   )
  # end

  def template_params
    params.permit(
      :certificate_serial,
      :identity,
      { template_contents_attributes: [:id, :template_id, :locale, :title, :content] }
    )
  end

  def find_template
    @template = Template.find_by(identity: params[:identity])
    return response_error('404.4') unless @template
  end

  # def locale_array
  #   ["cs", "de", "en", "es", "fr", "hu", "it", "nl", "pl", "ru", "th", "tr", "zh-TW"]
  # end

  # def create_template_content(locale)
  #   @template_content = TemplateContent.new
  #   @template_content.template_id = @template.id
  #   @template_content.locale = locale
  #   @template_content.title = params[:"title_#{locale}"]
  #   @template_content.content = params[:"content_#{locale}"]
  #   @template_content.save
  # end

  # def create_or_update_template_content(locale)
  #   @template_content = TemplateContent.find_or_create_by!(template_id: @template.id, locale: locale)

  #   @template_content.update_attributes(
  #     title: params[:"title_#{locale}"],
  #     content: params[:"content_#{locale}"]
  #   )
  # end

  def show_template_content(template)
    template_contents = template.template_contents.map{ |template_content|
      template_content.attributes.merge({
        identity: template_content.template.identity
      })
    }
  end

end
