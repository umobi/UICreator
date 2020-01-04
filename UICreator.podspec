#
# Be sure to run `pod lib lint UICreator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UICreator'
  s.version          = '1.0.0-alpha.5'
  s.summary          = 'Creating view using declarative statements'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
UICreator is a replacement for storyboard and xib files. Like Fluter, ReactNative and SwiftUI, but keeping the same structure used in MVC projects.
                       DESC

  s.homepage         = 'https://github.com/umobi/UICreator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UICreator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.swift_version = '5.1'

  s.source_files = 'UICreator/Classes/**/*'

  s.dependency 'UIContainer', '~> 1.2.0-beta.3'
  s.dependency 'SnapKit', '~> 5.0.1'
  # s.resource_bundles = {
  #   'UICreator' => ['UICreator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
