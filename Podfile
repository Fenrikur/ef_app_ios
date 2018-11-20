platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target :RandomDataGeneration do
    pod 'SwiftLint'
end

target 'Eurofurence' do
	plugin 'cocoapods-acknowledgements', :settings_bundle => true
	
	pod 'Down'
	pod 'SwiftLint'
	pod 'Firebase/Core'
	pod 'Firebase/Crash'
	pod 'Firebase/Messaging'
	pod 'Firebase/Performance'
	
	pod 'SimulatorStatusMagic', :configurations => ['Screenshots']

	target :EurofurenceTests do
		inherit! :search_paths

		pod 'Firebase/Core'
		pod 'Firebase/Crash'
	end
	
end

target :EurofurenceAppCore do
    
    pod 'SwiftLint'
    pod 'ReachabilitySwift'
    pod 'Locksmith'
    
    target :EurofurenceAppCoreTests do
        inherit! :search_paths
    end
    
    target :EurofurenceAppCoreAdapterTests do
        inherit! :search_paths
    end
    
    target :EurofurenceAppCoreTestDoubles do
        inherit! :search_paths
    end
    
end
