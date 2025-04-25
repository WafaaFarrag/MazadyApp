source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

# Main App Target
target 'MazadyApp' do
  use_frameworks!

  # Reactive programming
 # pod 'RxSwift', '~> 6.5'
  pod 'RxCocoa', '~> 6.5'

  # Networking
  pod 'Moya', '~> 15.0'
  #pod 'Moya/RxSwift', '~> 15.0'
  pod 'Moya/RxSwift'
  # Message banners
  pod 'SwiftMessages', '~> 9.0'

  # Network reachability
  pod 'ReachabilitySwift', '~> 5.1'

  # Lint (optional)
  # pod 'SwiftLint'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end

# App Unit Tests Target
target 'MazadyAppTests' do
  inherit! :search_paths
  # Pods for testing (add test-only pods here if needed)
end

# App UI Tests Target
target 'MazadyAppUITests' do
  inherit! :search_paths
  # Pods for UI testing (add UI test pods here if needed)
end
