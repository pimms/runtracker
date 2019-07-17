# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'runtracker' do
  platform :ios, '13.0'

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for runtracker
  pod 'DTMHeatmap'

  target 'runtrackerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'runtrackerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


# LOL
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
