#
# Be sure to run `pod lib lint CSCConfigLoader.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CSCConfigLoader"
  s.version          = "0.1.3"
  s.summary          = "An easy config loader for iOS"
  s.description      = <<-DESC
                       A simpler interface to loading config data from a plist file in your project.
                       It also supports pods providing their own default configuration options which
                       can then be overriden from the main project.
                       DESC
  s.homepage         = "https://github.com/marblepalace/CSCConfigLoader"
  s.license          = 'MIT'
  s.author           = { "Cast Social Company" => "hello@castapp.io" }
  s.source           = { :git => "https://github.com/marblepalace/CSCConfigLoader.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cast_app'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CSCConfigLoader' => ['Pod/Assets/*.png']
  }

end
