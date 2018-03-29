platform :ios, '11.0'

target 'mowine' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mowine
  pod 'Eureka'
  pod 'Cosmos'
  pod 'PureLayout'
  
  # Auth dependencies
  pod 'AWSMobileClient', '~> 2.6.5'
  pod 'AWSAuthUI', '~> 2.6.5'
  pod 'AWSUserPoolsSignIn', '~> 2.6.5'
  pod 'AWSFacebookSignIn', '~> 2.6.5'
  pod 'AWSLambda', '~> 2.6.5'
  pod 'AWSDynamoDB', '~> 2.6.5'

  target 'mowineTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble'
  end

  target 'mowineUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
