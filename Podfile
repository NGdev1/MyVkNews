# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'MyVkNews' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyVkNews

#pod "SVProgressHUD"
#pod "Keychain"

#pod "VK-ios-sdk"

pod 'SwiftyVK', :git => 'https://github.com/WE-St0r/SwiftyVK.git'
#pod 'SwiftyJSON', :git => 'https://github.com/acegreen/SwiftyJSON.git', :branch => 'swift3'

  target 'MyVkNewsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyVkNewsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end


