plugin_root = File.join(File.dirname(__FILE__), '..')

# first look for a symlink to a copy of the framework
if framework_root = ["#{plugin_root}/rails", "#{plugin_root}/../../rails"].find { |p| File.directory? p }
  puts "found framework root: #{framework_root}"
  # this allows for a plugin to be tested outside an app
  $:.unshift "#{framework_root}/activesupport/lib", "#{framework_root}/activerecord/lib", "#{framework_root}/actionpack/lib"
else
  # is the plugin installed in an application?
  app_root = plugin_root + '/../../..'

  if File.directory? app_root + '/config'
    puts "using application's config/boot.rb"
    ENV['RAILS_ENV'] = 'test'
    require File.expand_path(app_root + '/config/boot')
  else
    # simply use installed gems if available
    version = ENV['RAILS_VERSION']
    version = nil if version and version == ""
    
    puts "using Rails#{version ? ' ' + version : nil} gems"
    require 'rubygems'
    
    if version
      gem 'rails', version
    else
      gem 'actionpack'
      gem 'activerecord'
    end
  end
end

$:.unshift "#{plugin_root}/lib"
