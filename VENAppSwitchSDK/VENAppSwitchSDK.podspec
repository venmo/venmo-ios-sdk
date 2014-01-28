Pod::Spec.new do |s|
  s.name         = "VENAppSwitchSDK"
  s.version      = "1.0.0"
  s.summary      = "App switch SDK for Venmo."
  s.description  = <<-DESC
                   App switch SDK for Venmo.
                   DESC

  s.homepage     = "https://github.com/venmo/VENAppSwitchSDK"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Venmo" => "developers@venmo.com" }
  s.platform     = :ios, '5.0'
  s.source_files = '**/*.{h,m}'
  s.requires_arc = true
end
