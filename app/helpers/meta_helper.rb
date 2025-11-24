# app/helpers/meta_helper.rb
module MetaHelper
  def default_meta_tags
    {
      site: @company&.name || ENV["COMPANY_NAME"] || "ELVINCompany",
      reverse: true,
      separator: '|',
      description: 'Профессиональные услуги веб-разработки и дизайна',
      keywords: 'веб-разработка, дизайн, Ruby on Rails',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_path('favicon.ico') },
        { href: image_path('icon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' }
      ]
    }
  end
end