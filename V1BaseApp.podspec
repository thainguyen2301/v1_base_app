Pod::Spec.new do |s|
  s.name             = 'V1BaseApp'
  s.version          = '0.1.1'
  s.summary          = 'This is a base library for using V1 style'
  s.description      = 'Base library for V1 style apps.'
  s.homepage         = 'https://github.com/141131796/V1BaseApp'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '141131796' => 'thainx23@gmail.com' }

  s.source           = { :git => 'https://github.com/141131796/V1BaseApp.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  # Swift configuration
  s.swift_version = '5.0'
  s.requires_arc = true

  # Optional: force dynamic framework if needed
  # (You can delete this line; Swift pods are usually dynamic by default)
  s.static_framework = false

  # Make sure module name is correct for `import`
  s.module_name = 'V1BaseApp'

  # Source files
  s.source_files = 'V1BaseApp/Classes/**/*'
end
