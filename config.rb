# General configuration
config[:domain]                  = 'howicode.com'
config[:www_prefix]              = false
config[:cloudfront_distribution] = 'ES5EDHXD7WPUA'
config[:twitter_owner]           = 'wossname'
config[:twitter_creator]         = 'mathie'
config[:fb_app_id]               = '276208079383599'
config[:gtm_id]                  = 'GTM-WQZC49'

# Generic metadata
config[:short_title]   = 'How I Code'
config[:long_title]    = "#{config[:short_title]}: A conversation on the art and craft of software development"
config[:description]   = "I want to go on a holistic exploration of how developers write code in a sustainable, enjoyable way."
config[:logo]          = 'wossname-industries.png'
config[:company]       = 'Wossname Industries'
config[:company_url]   = 'https://woss.name/'
config[:telephone]     = '+44 (0)7949 077744'
config[:site_category] = "Software Development"
config[:site_tags]     = ['Podcast', 'Software Development', 'Productivity',
                          'Sustainability']

config[:related] = {
  # facebook: 'https://www.facebook.com/wossname-industries',
  twitter:  "https://twitter.com/#{config[:twitter_owner]}",
  google:   'https://plus.google.com/+WossnameIndustries',
  linkedin: 'https://www.linkedin.com/company/wossname-industries'
}

# Mailing list signup form configuration
config[:mailchimp_url]      = "//howicode.us1.list-manage.com/subscribe/post?u=e2954746a3d6f76209fcd2a6a&amp;id=1038bb42e1"
config[:mailchimp_group_id] = "5137"
config[:mailchimp_antispam] = "b_e2954746a3d6f76209fcd2a6a_1038bb42e1"

# UTM-related bits
config[:default_utm_medium]   = 'website'
config[:default_utm_campaign] = 'howicode'

# Calculated Configuration
config[:hostname]           = config[:www_prefix] ? "www.#{config[:domain]}" : config[:domain]
config[:url]                = "https://#{config[:hostname]}"
config[:email_address]      = "hello@#{config[:domain]}"
config[:default_utm_source] = config[:domain]
config[:gravatar]           = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(config[:email_address])}"
config[:copyright]          = "Copyright &copy; 2015-#{Time.now.year} #{config[:author]}. All rights reserved."

# Pages with no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# General configuration
activate :directory_indexes
activate :asset_hash
activate :gzip

activate :external_pipeline,
  name: :gulp,
  command: "./node_modules/gulp/bin/gulp.js #{build? ? 'build' : ''}",
  source: 'intermediate/'

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  activate :minify_html
end

activate :s3_sync do |s3|
  s3.bucket = config[:hostname]
  s3.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  s3.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
end

activate :cloudfront do |cf|
  cf.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  cf.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  cf.distribution_id = config[:cloudfront_distribution]
  cf.filter = /\.(html|xml|txt)$/
end

caching_policy 'text/html',       max_age: 0, must_revalidate: true
caching_policy 'application/xml', max_age: 0, must_revalidate: true
caching_policy 'text/plain',      max_age: 0, must_revalidate: true

default_caching_policy max_age: (60 * 60 * 24 * 365)

helpers do
  def mail_to_link(options = {})
    mail_to config[:email_address], config[:email_address], options
  end

  def utm_link_to(title_or_url, url_or_options = nil, options = {}, &block)
    if block_given?
      title   = nil
      url     = title_or_url
      options = url_or_options || {}
    else
      title   = title_or_url
      url     = url_or_options
      options = options
    end

    utm_source   = options.delete(:source) || config[:default_utm_source]
    utm_medium   = options.delete(:medium) || config[:default_utm_medium]
    utm_campaign = options.delete(:campaign) || config[:default_utm_campaign]
    utm_content  = options.delete(:content) || title

    query = {
      utm_source: utm_source,
      utm_medium: utm_medium,
      utm_campaign: utm_campaign,
      utm_content: utm_content
    }.merge(options.delete(:query) || {}).reject { |k, v| v.nil? }

    options = { query: query }.merge(options)

    if block_given?
      link_to url, options, &block
    else
      link_to title, url, options
    end
  end

  def title_meta
    current_page.data.title || config[:long_title]
  end

  def description_meta
    current_page.data.description || config[:description]
  end

  def category_meta
    current_page.data.category || config[:site_category]
  end

  def tags_meta
    (current_page.data.tags || []) + (config[:site_tags] || [])
  end

  def published_at_meta
    current_page.data.published_at || Time.now
  end

  def updated_at_meta
    current_page.data.updated_at || published_at_meta
  end

  def url_meta
    "#{config[:url]}#{current_page.url}"
  end

  def xml_timestamp(dateish = Time.now)
    timestamp = dateish.respond_to?(:strftime) ? dateish : Date.parse(dateish)
    timestamp.strftime('%FT%H:%M:%S%:z') 
  end
end
