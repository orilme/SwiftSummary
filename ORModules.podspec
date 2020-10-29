Pod::Spec.new do |s|
  s.name             = 'ORModules'
  s.version          = '0.6.7'
  s.summary          = '组件化.'

  s.description      = <<-DESC
  组件化测试
                       DESC

  s.homepage         = 'https://github.com/orilme/ORModules'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'orilme' => 'https://github.com/orilme' }
  s.source           = { :git => 'https://github.com/orilme/ORModules.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  
  s.subspec "BaseViewController" do |ss|
      ss.source_files  = 'ORModules/Classes/BaseViewController/**/*{h,m,swift}'
  end
  
  s.subspec "A" do |ss|
      ss.source_files  = 'ORModules/Classes/A/**/*{h,m,swift}'
      ss.dependency "ORModules/B_Category"
      ss.dependency "HandyFrame"
      ss.dependency "CTMediator"
  end
  
  s.subspec "A_Category" do |ss|
      ss.source_files  = 'ORModules/Classes/A_Category/**/*{h,m,swift}'
      ss.dependency "CTMediator"
  end
  
  s.subspec "B_Category" do |ss|
      ss.source_files  = 'ORModules/Classes/B_Category/**/*{h,m,swift}'
      ss.dependency "CTMediator"
  end
  
end
