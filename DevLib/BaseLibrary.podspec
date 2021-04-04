#
# Be sure to run `pod lib lint BaseLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BaseLibrary'
  s.version          = '0.0.1'
  s.summary          = 'iOS基础组件库'

  s.description      = <<-DESC
    iOS基础组件，网络层、弹框等组件
                        DESC
  s.homepage         = 'https://github.com/orilme/SwiftSummary.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'orilme' => 'orilme.com' }
  s.source           = { :git => 'https://github.com/orilme/SwiftSummary.git', :tag => s.version }
  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '9.0'

    s.subspec "Networking" do |ss|
      ss.source_files  = "BaseLibrary/Networking/**/*.{swift,xib}"
      ss.dependency 'Moya', '~> 13.0'
      ss.dependency 'MBProgressHUD', '~> 1.1.0'
      ss.dependency 'lottie-ios', '~> 3.1.2'
      ss.resource = "BaseLibrary/Networking/Resources/Networking.bundle"
    end
   
end

