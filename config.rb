###
# Compass
###

# Susy grids in Compass
require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

activate :bower

activate :livereload

activate :directory_indexes

###
# Haml
###

# CodeRay syntax highlighting in Haml
# First: gem install haml-coderay
# require 'haml-coderay'

# CoffeeScript filters in Haml
# First: gem install coffee-filter
# require 'coffee-filter'

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

###
# Page command
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  # Calculate the years for a copyright
  def copyright_years(start_year)
    end_year = Date.today.year
    if start_year == end_year
      start_year.to_s
    else
      start_year.to_s + '-' + end_year.to_s
    end
  end

  # Holder.js image placeholder helper
  def img_holder(opts = {})
    return "Missing Image Dimension(s)" unless opts[:width] && opts[:height]
    return "Invalid Image Dimension(s)" unless opts[:width].to_s =~ /^\d+$/ && opts[:height].to_s =~ /^\d+$/

    img  = "<img data-src=\"holder.js/#{opts[:width]}x#{opts[:height]}/auto"
    img << "/#{opts[:bgcolor]}:#{opts[:fgcolor]}" if opts[:fgcolor] && opts[:bgcolor]
    img << "/text:#{opts[:text].gsub(/'/,"\'")}" if opts[:text]
    img << "\" width=\"#{opts[:width]}\" height=\"#{opts[:height]}\">"

    img
  end

  # Contribute email link
    def contribute_link
      contribute_link = mail_to "ytspar+ristrettogram@gmail.com", "Contribute a video",
        :title => "Email this article to a friend.",
        :subject => "Contribute a video",
        :body => "Instagram URL: %0D%0A Cafe name:"
    end

end

# Change the CSS directory
# set :css_dir, "alternative_css_directory"

# Change the JS directory
# set :js_dir, "alternative_js_directory"

# Change the images directory
# set :images_dir, "alternative_image_directory"

# Change the fonts directory
# set :fonts_dir,  "alternative_fonts_directory"

# Build-specific configuration
configure :build do

  # Requires middleman-favicon-maker
  # activate :favicon_maker,
  #   :favicon_maker_base_image => "favicon_base.svg"

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # gzip
  activate :gzip

  # Minify HTML
  activate :minify_html

  # Compress PNGs after build
  # First: gem install middleman-smusher
  require "middleman-smusher"
  activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"

end

# Requires middleman-deploy and rsync
# activate :deploy do |deploy|
#   deploy.method = :rsync
#   deploy.user   = "example"
#   deploy.host   = "www.example.com"
#   deploy.path   = "/public_html"
#   # Optional Settings
#   deploy.port  = 22 # ssh port, default: 22
#   deploy.clean = true # remove orphaned files on remote host, default: false
#   deploy.build_before = true # default: false
# end

configure :development do
  set :debug_assets, true
end

# Load a YML config file with constants. A aws.yml.example file is provided.
ignore 'aws.yml'
aws_config = YAML::load(File.open('aws.yml'))

activate :s3_sync do |s3_sync|
  s3_sync.bucket                = aws_config['s3_bucket']
  s3_sync.region                = aws_config['aws_region']
  s3_sync.aws_access_key_id     = aws_config['access_key_id']
  s3_sync.aws_secret_access_key = aws_config['secret_access_key']
  s3_sync.delete                = true
  s3_sync.after_build           = false
end

activate :cloudfront do |cf|
  cf.access_key_id              = aws_config['access_key_id']
  cf.secret_access_key          = aws_config['secret_access_key']
  cf.distribution_id            = aws_config['cloud_front_dist_id']
  cf.filter                     = /(.html|.xml)/
  cf.after_build                = false
end


# Skip locale validation (and validation warnings)
I18n.enforce_available_locales = false
