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

  before_action do
    check_signature_urlsafe template_params, signature
  end

  before_action only: [:create] do
    check_params template_params, create_filter
  end

  before_action :find_template, only: [:show, :update, :destroy]

  def index
    @tamplates = Template.all
    @data = @tamplates.map do |tamplate|
      {
        id: tamplate.id,
        identity: tamplate.identity,
        title_en: tamplate.en_template_content.title,
        content_en: tamplate.en_template_content.content
      }
    end
    render json: { data: @data }, status: 200
  end

  def show
    @template_contents = show_template_content(@template)
    render json: { data: @template_contents }, status: 200
  end

  def create
    @template = Template.new
    @template.identity = params[:identity]
    if @template.save

      locale_array.map do |locale|
        unless params[:"title_#{locale}"].blank?
          create_template_content(locale)
        end
      end

      @template_contents = show_template_content(@template)
      render json: { data: @template_contents }, status: 200
    else
      render json: { message: @template.errors.full_messages.first }, status: 400
    end
  end

  def update
    locale_array.map do |locale|
      unless params[:"title_#{locale}"].blank?
        create_or_update_template_content(locale)
      end
    end

    @template_contents = show_template_content(@template)
    render json: { data: @template_contents }, status: 200
  end

  def destroy
    @template.destroy
    render nothing: true, status: 200
  end

  private

  def create_filter
    ['identity', 'title_en', 'content_en']
  end

  def template_params
    params.permit(:certificate_serial, :identity, :title_en, :content_en,
      :'title_zh-TW', :'content_zh-TW', :title_de, :content_de,
      :title_cs, :content_cs, :title_es, :content_es,
      :title_fr, :content_fr, :title_hu, :content_hu,
      :title_it, :content_it, :title_nl, :content_nl,
      :title_pl, :content_pl, :title_ru, :content_ru,
      :title_th, :content_th, :title_tr, :content_tr
    )
  end

  def find_template
    @template = Template.find_by(identity: params[:identity])

    if @template.nil?
      return response_error('404.4')
    end
  end

  def locale_array
    ["cs", "de", "en", "es", "fr", "hu", "it", "nl", "pl", "ru", "th", "tr", "zh-TW"]
  end

  def create_template_content(locale)
    @template_content = TemplateContent.new
    @template_content.template_id = @template.id
    @template_content.locale = locale
    @template_content.title = params[:"title_#{locale}"]
    @template_content.content = params[:"content_#{locale}"]
    @template_content.save
  end

  def create_or_update_template_content(locale)
    @template_content = TemplateContent.find_or_create_by!(template_id: @template.id, locale: locale)

    @template_content.update_attributes(
      title: params[:"title_#{locale}"],
      content: params[:"content_#{locale}"]
    )
  end

  def show_template_content(template)
    template_contents = template.template_contents.map{ |template_content|
      template_content.attributes.merge({
        identity: template_content.template.identity
      })
    }
  end

end
