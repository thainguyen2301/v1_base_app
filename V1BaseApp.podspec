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

  # 🔥 REQUIRED for Swift pods
  s.swift_version = '5.0'
  s.requires_arc = true
  s.requires_frameworks = true

  # 🔥 This ensures your Swift module is correctly generated
  s.module_name = 'V1BaseApp'

  # Your source files
  s.source_files = 'V1BaseApp/Classes/**/*'
end
