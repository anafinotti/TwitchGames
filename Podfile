# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def default_pods
    pod 'Alamofire'
    pod 'ObjectMapper'
    pod 'AlamofireObjectMapper'
    pod 'CoreDataManager'
end


target 'TwitchGames' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

    default_pods
    
target 'TwitchGamesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TwitchGamesUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'TwitchTodayWidget' do
     default_pods
  end

end
