Pod::Spec.new do |s|
  s.name         = 'SLazeKit'
  s.version      = '0.1.2'
  s.summary      = 'Swift restful manager.'
  s.description  = <<-DESC
    SLazeKit is an easy to use Swift restfull collection of extensions and classes. Don't spend hours writing your code to map your rest api request into models and serialization. stop wasting your time!
  DESC
  s.homepage     = 'https://github.com/shial4/SLazeKit.git'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { 'Szymon Lorenz' => 'shial184686@gmail.com' }
  s.social_media_url   = 'https://twitter.com/shial_4'
  
  s.ios.deployment_target = '10.0'

  s.source       = { :git => 'https://github.com/shial4/SLazeKit.git', :tag => s.version.to_s }
  s.source_files  = 'Sources/**/*.swift'
  s.frameworks  = 'CoreData'

end