# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Fooderoso' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Fooderoso

  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'

  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'

  pod 'JSQMessagesViewController'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftyJSON', :git =>'https://github.com/SwiftyJSON/SwiftyJSON.git'

end

post_install do |installer|
   installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
           config.build_settings['SWIFT_VERSION'] = '3.0'
       end
   end
end