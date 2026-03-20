# app/helpers/meta_helper.rb
module MetaHelper
  def default_meta_tags
    {
      site: "Навесы из поликарбоната",
      title: "Навесы из поликарбоната в Крыму",
      reverse: true,
      separator: '|',
      description: 'Изготавливаем навесы из поликарбоната в Крыму. Навесы для авто, дома и террасы.',
      keywords: 'навесы из поликарбоната Крым, навес для машины Крым, навесы Севастополь',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_path('favicon.ico') },
        { href: image_path('icon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' }
      ]
    }
  end
end