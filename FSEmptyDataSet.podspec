
Pod::Spec.new do |s|
  s.name      = 'FSEmptyDataSet'
  s.version   = '1.0.0'
  s.summary   = 'A simple component of a empty page.'
  s.homepage  = 'https://github.com/lifution/FSEmptyDataSet'
  s.license   = { :type => 'MIT', :file => 'LICENSE' }
  s.authors   = 'Sheng'
  s.source    = {
    :git => 'git@github.com:lifution/FSEmptyDataSet.git',
    :tag => s.version.to_s
  }
  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.frameworks = 'UIKit', 'Foundation'
  s.source_files = 'FSEmptyDataSet/Classes/**/*'
end
