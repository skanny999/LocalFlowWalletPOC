source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'LocalFlowWalletPOC' do
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'SearchTextField'
    


post_install do |installer|
    installer.pods_project.targets.each do |target|
        plist_buddy = "/usr/libexec/PlistBuddy"
        plist = "Pods/Target Support Files/#{target}/Info.plist"
        `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities array" "#{plist}"`
        `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities:0 string arm64" "#{plist}"`
    end
end

end
