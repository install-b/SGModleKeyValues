
Pod::Spec.new do |s|


  s.name         = "SGModleKeyValues"
  s.version      = "1.1.0"
  s.summary      = "A runtime dictionary transfer to model and model transfer to dictionary"

  s.description  = "SGModleKeyValues is a quick round of model and dictionary transfer tools"

  s.homepage     = "https://github.com/install-b/SGModleKeyValues"

  s.license      = "MIT"

  s.author             = { "ShangenZhang" => "gkzhangshangen@163.com"  }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/install-b/SGModleKeyValues.git", :tag => s.version }

  s.source_files  = "SGModelKeyValues/**/*.{h,m}"

  s.framework  = "Foundation"

  s.requires_arc = true
end
