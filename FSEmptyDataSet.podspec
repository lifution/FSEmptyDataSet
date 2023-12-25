Pod::Spec.new do |s|
  s.name     = 'FSEmptyDataSet'
  s.version  = '2.0.0'
  s.summary  = 'An easy-to-use empty placeholder library for iOS written in Swift.'
  s.homepage = 'https://github.com/lifution/FSEmptyDataSet'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = 'Sheng'
  s.source   = {
    :git => 'https://github.com/lifution/FSEmptyDataSet.git',
    :tag => s.version.to_s
  }
  
  s.requires_arc = true
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'
  
  s.frameworks = 'UIKit', 'Foundation'
  s.source_files = 'Sources/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FSUIKit' => ['Sources/Assets/*.png']
  # }
end
