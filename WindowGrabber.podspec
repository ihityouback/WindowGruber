Pod::Spec.new do |s|

    s.name               = "WindowGrabber"
    s.version            = "1.0.0"
    s.summary            = "Grabber of macOS apps windows and browsers URL"
    s.description        = <<-DESC
                                WindowGrabber track active applications and show ther opened windows info.
                                Also track active browsers and uses AppleScript to grab the URL from the active tab.
                            DESC
    s.homepage           = "https://github.com/ihityouback/WindowGruber.git"
    s.license            = "MIT"
    s.author             = { "Rustam Galiullin" => "ihityouback@gmail.com" }
    s.social_media_url   = "https://www.facebook.com/ihityouback"
    s.platform           = :osx
    s.source             = { :git => "https://github.com/ihityouback/WindowGruber.git", :tag => "0.2.0" }
    s.source_files       = "WindowGrabber/Source/**/*.swift"
    s.resources          = "WindowGrabber/Source/**/*.scpt"
    s.osx.framework      = 'AppKit'
    s.requires_arc       = true
    s.pod_target_xcconfig = { "SWIFT_VERSION" => "4.0" }
    s.osx.deployment_target = '10.9'

end
