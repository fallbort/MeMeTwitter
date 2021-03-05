#
#  Be sure to run `pod spec lint MeMeTwitter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MeMeTwitter"
  spec.version      = "1.0.0"
  spec.summary      = "MeMeTwitter Modules"

  spec.description  = <<-DESC
                   MeMeTwitter Modules,contain,
                   1.MeMeTwitter
                   DESC

  spec.homepage     = "https://github.com/fallbort/MeMeTwitter"

  spec.license      = "MIT"
#  spec.license      = { :type => "MIT", :file => "LICENSE.md" }

  spec.author             = { "xfb" => "fabo.xie@nextentertain.com" }

  # spec.platform     = :ios
   spec.platform     = :ios, "10.0"
   spec.ios.deployment_target = "10.0"

  spec.source       = { :git => "https://github.com/fallbort/MeMeTwitter.git",:tag => "MeMeTwitter_#{spec.version}" }

  spec.swift_version = '5.0'
  spec.static_framework = true

  spec.source_files  = "Source/**/*.{h,m,swift}","*.{h,m,swift}"
  # spec.public_header_files = 'Source/**/*.{h}'
  # spec.frameworks = "MediaPlayer"
  # spec.vendored_frameworks    = "Frameworks/3.1.2/AgoraRtcKit.framework"
end
