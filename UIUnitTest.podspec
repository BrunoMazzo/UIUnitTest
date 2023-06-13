#
# Be sure to run `pod lib lint UIUnitTest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIUnitTest'
  s.version          = '0.1.1'
  s.summary          = 'A short description of UIUnitTest.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BrunoMazzo/UIUnitTest'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bruno Mazzo' => 'mazzo.bruno@gmail.com' }
  s.source           = { :git => 'https://github.com/Bruno Mazzo/UIUnitTest.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_versions = '5.8'

  s.ios.deployment_target = '15.0'

  s.source_files = 'Lib/Sources/UIUnitTest/**/*'

  s.framework = "XCTest"
  
  # s.resource_bundles = {
  #   'UIUnitTest' => ['UIUnitTest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
