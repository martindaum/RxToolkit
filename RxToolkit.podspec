Pod::Spec.new do |spec|
    spec.name       = 'RxToolkit'
    spec.version    = '1.0.5'
    spec.summary    = 'My personal toolkit'
    spec.homepage   = 'https://github.com/martindaum/RxToolkit'
    spec.license    = { :type => 'MIT', :file => 'LICENSE' }
    spec.author     = { 'martindaum' => 'office@martindaum.com' }
    spec.source     = { :git => 'https://github.com/martindaum/RxToolkit.git', :tag => spec.version.to_s }

    spec.ios.deployment_target = '10.0'
    spec.osx.deployment_target = '10.10'
    spec.tvos.deployment_target = '10.0'
    spec.watchos.deployment_target = '3.0'

	spec.swift_version = '4.2'
	
    spec.dependency 'RxSwift', '~> 4.0'
    spec.source_files = '**/*.swift'

    spec.subspec 'API' do |subspec|
  	    subspec.dependency 'Alamofire', '~> 4.0'
        subspec.source_files = 'API/**/*.swift'
    end

    spec.subspec 'Datastore' do |subspec|
        subspec.dependency 'RealmSwift', '~> 3.0'
        subspec.source_files = 'Datastore/**/*.swift'
    end
  
    spec.subspec 'Defaults' do |subspec|
        subspec.dependency 'RxCocoa', '~> 4.0'
        subspec.source_files = 'Defaults/**/*.swift'
    end
end
