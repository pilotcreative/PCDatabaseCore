Pod::Spec.new do |s|
  s.name         = 'PCDatabaseCore'
  s.version      = '0.0.1'
  s.summary      = 'Objective-C wrapper for Core Data'
  s.description  = 'Highly customizable objective-C wrapper for Core Data'
  s.homepage     = 'https://github.com/pilotcreative/PCDatabaseCore'
  s.license      = 'MIT'
  s.author             = { 'Paweł Nużka' => 'pawelqus@gmail.com' }
  s.social_media_url   = 'https://twitter.com/pawelnuzka'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'

  s.source_files  = 'PCDatabaseCore', 'PCDatabaseCore/**/*.{h,m}'
  s.public_header_files = "PCDatabaseCore/**/*.h"
  #s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  s.framework    = 'CoreData'
  s.requires_arc = true
   s.dependency 'XCAsyncTestCase'
end
