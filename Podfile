source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

# There are no targets called 'CollectionsCommon' in any Xcode projects.
abstract_target 'CollectionsCommon' do
  # Common pods
  pod 'SwiftLint'
  pod 'KeychainAccess'

  # Common Firebase Pods
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth' # Needed version 5.3 to fix `isNewUser` always returning false
  pod 'Firebase/Firestore'

  target 'Collections' do
    # Firebase Pods for Collections
    pod 'Firebase/DynamicLinks', '~> 4.2' # Needed version 4.2 to fix 'not available' bug
    pod 'Firebase/Functions'

    # Facebook login
    pod 'FBSDKLoginKit', '~> 5.4'
  end

  target 'Save Account' do
    # just the common pods from 'CollectionsCommon'
  end
end

# The 'Save Post' target only has one Pod.
target 'Save Post' do
  # Single common pod
  pod 'SwiftLint'
end

# If you get the following error:
# 'sharedApplication' is unavailable: not available on iOS (App Extension) - Use view controller based solutions where appropriate instead.
#   1. Go to 'Pods' project
#   2. Under TARGET, choose the offender
#   3. Change Require Only App-Extension-Safe API
# Source: https://stackoverflow.com/a/50223881
