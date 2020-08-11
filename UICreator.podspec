#
# Be sure to run `pod lib lint UICreator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UICreator'
  s.version          = '1.0.3'
  s.summary          = 'UICreator use declarative programming to create view interface using UIKit by Apple'
  s.homepage         = 'https://github.com/umobi/UICreator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UICreator.git', :tag => s.version.to_s }

  s.description      = <<-DESC
  UICreator is a replacement for storyboard and xib files. It directly communicates with UIKit to build views, so at the end of the process, the application will be using all UIKit components. This helps to implement a lot of utility functions to set attributes or do stuff using declarative sentences.

                         DESC

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.swift_version = '5.2'

  s.source_files = 'Sources/UICreator/**/*'

  s.dependency 'ConstraintBuilder', '>= 2.0.0', "< 3.0.0"

end
