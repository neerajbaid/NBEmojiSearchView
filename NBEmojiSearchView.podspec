Pod::Spec.new do |s|
  s.name         = "NBEmojiSearchView"
  s.version      = "1.0"
  s.summary      = "Integrate a searchable emoji dropdown into your iOS app in just a few lines."
  s.homepage     = "http://github.com/neerajbaid/NBEmojiSearchView"
  s.license      = { :type => 'MIT', :text => 'Copyright 2015. Neeraj Baid. This library is distributed under the terms of the MIT/X11.' }
  s.author             = { "Neeraj Baid" => "neerajbaid@gmail.com" }
  s.social_media_url   = "http://twitter.com/2neeraj"
  s.source       = { :git => "https://github.com/neerajbaid/NBEmojiSearchView.git", :tag => "1.0" }
  s.source_files  = "Source/*.{h,m}"
  s.resource  = "Source/AllEmoji.json"
  s.requires_arc = true
  s.platform     = :ios, '7.0'
end
