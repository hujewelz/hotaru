#
# Be sure to run `pod lib lint Hotaru.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Hotaru'
  s.version          = '1.1.1'
  s.summary          = 'networking framework whit swift 3.0.'

#  s.description      = <<-DESC
#networking framework whit swift 3.0
#                       DESC

  s.homepage         = 'https://github.com/hujewelz/hotaru'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hujewelz' => 'hujewelz@163.com' }
  s.source           = { :git => 'https://github.com/hujewelz/hotaru.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |cs|
    cs.source_files = 'Hotaru/Classes/Core**/*'
  end

  s.subspec 'RxSwift' do |rx|
    rx.source_files = 'Hotaru/Classes/Rx/**/*'
    rx.dependency 'RxSwift'
    rx.dependency 'Hotaru/Core'
  end

  s.dependency 'Alamofire', '~> 4.5.0'
end
