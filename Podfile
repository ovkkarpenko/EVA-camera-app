platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

target 'EVA-camera-app' do
  pod 'SnapKit'
  pod 'R.swift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end