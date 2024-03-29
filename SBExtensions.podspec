Pod::Spec.new do |s|

    s.name        = 'SBExtensions'
    s.version     = '0.0.3'
    s.summary     = 'A lightweight and pure Swift implemented library for collection of native Swift extensions.'
  
    s.description = <<-DESC
                         SBExtensions is a lightweight and pure Swift implemented library for collection of native Swift extensions.
                         DESC
  
    s.homepage    = 'https://github.com/spirit-jsb/SBExtensions'
    
    s.license     = { :type => 'MIT', :file => 'LICENSE' }
    
    s.author      = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
    
    s.swift_versions = ['5.0']
    
    s.ios.deployment_target = '11.0'
      
    s.source       = { :git => 'https://github.com/spirit-jsb/SBExtensions.git', :tag => s.version }
    s.source_files = ["Sources/**/*.swift"]
    
    s.requires_arc = true
  end
  
