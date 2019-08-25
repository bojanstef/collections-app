source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

def common_pods
  # Common pods
  pod 'SwiftLint'
  pod 'KeychainAccess'

  # Common Firebase Pods
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth' # Needed version 5.3 to fix `isNewUser` always returning false
  pod 'Firebase/Firestore'
end

target 'Collections' do
  # Common pods
  common_pods

  # Firebase Pods for Collections
  pod 'Firebase/DynamicLinks', '~> 4.2' # Needed version 4.2 to fix 'not available' bug
  pod 'Firebase/Functions'

  # Facebook login
  pod 'FBSDKLoginKit'

end

target 'Save Account' do
  # Common pods
  common_pods
end

target 'Save Post' do
  # Single common pod
  pod 'SwiftLint'
end
