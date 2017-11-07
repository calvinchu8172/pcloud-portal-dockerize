namespace :db do
  task :template_seed => :environment do
    5.times do |i|
      Template.create(identity: "Template-#{i}")
      ["cs", "de", "en", "es", "fr", "hu", "it", "nl", "pl", "ru", "th", "tr", "zh-TW"].each do |locale|
        TemplateContent.create(template_id: i+1, locale: locale, title: "title-#{locale}", content: "content-#{locale}")
      end
    end
  end
end
