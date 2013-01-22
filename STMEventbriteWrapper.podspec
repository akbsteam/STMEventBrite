Pod::Spec.new do |s|
  s.name         = "STMEventbriteWrapper"
  s.version      = "0.0.1"
  s.summary      = "A simple wrapper for the Eventbrite API"
  s.homepage     = "https://github.com/akbsteam/STMEventBrite"

  s.license      = 'MIT'
  s.author       = { "Andy Bennett" => "andy@steamshift.net" }
  s.source       = { :git => "https://github.com/akbsteam/STMEventBrite.git", :tag => "0.0.1" }
  s.source_files = 'EventBrite/Classes/EventbriteWrapper/**/*.{h,m}'

  s.requires_arc = true
  s.dependency 'AFNetworking', '>= 1.0.1'
  s.dependency 'AFOAuth2Client', '>= 0.1.0'
end
