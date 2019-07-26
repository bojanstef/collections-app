platform :ios, '12.0'

use_frameworks!

def common_pods
  # Common pods
  pod 'SwiftLint'

  # Common Firebase Pods
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
end

target 'Collections' do
  # Common pods
  common_pods

  # Firebase Pods for Collections
  pod 'Firebase/DynamicLinks'
end

target 'Save Account' do
  # Common pods
  common_pods
end
