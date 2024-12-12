Pod::Spec.new do |s|
  s.name             = 'VPOnboardingKit'
  s.version          = '0.1.1'
  s.summary          = 'VPOnboardingKit provides an onboarding flow that is simple and easy to implement.'
  s.homepage         = 'https://github.com/DzeDze/VPOnboardingKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'DzeDze' => 'vince.p.email@gmail.com' }
  s.source           = { :git => 'https://github.com/DzeDze/VPOnboardingKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/VPOnboardingKit/**/*'
end