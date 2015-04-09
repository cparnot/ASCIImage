Pod::Spec.new do |s|
  s.name             = "ASCIImage"
  s.version          = "1.0.0"
  s.summary          = "Easily generate images from ASCII representations."
  s.description      = <<-DESC
Create UIImage / NSImage instances from NSString, by combining ASCII art and Kindergarten skills.
                       DESC
  s.homepage         = "https://github.com/cparnot/ASCIImage"
  s.license          = 'MIT'
  s.author           = { "cparnot" => "charles.parnot@gmail.com" }
  s.source           = { :git => "https://github.com/cparnot/ASCIImage.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cparnot'

  s.requires_arc = true

  s.source_files = 'Core/**/*'
  s.public_header_files = 'Core/**/*.h'
end
