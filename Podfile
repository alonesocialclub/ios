platform :ios, '12.0'

inhibit_all_warnings!
use_frameworks!

target 'AloneSocialClub' do
  pod 'ReactorKit'
  pod 'Texture',
    :git => 'https://github.com/TextureGroup/Texture.git',
    :branch => 'releases/p7.37'

  # DI
  pod 'Pure'
  pod 'Pure/Stub'  # https://github.com/CocoaPods/CocoaPods/issues/7195
  pod 'Swinject'
  pod 'SwinjectAutoregistration'

  # Networking
  pod 'Moya', '14.0.0-beta.4'
  pod 'Moya/RxSwift', '14.0.0-beta.4'
  pod 'MoyaSugar', '1.3.2'
  pod 'MoyaSugar/RxSwift', '1.3.2'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxCocoa-Texture'
  pod 'RxRelay'
  pod 'RxDataSources'
  pod 'RxDataSources-Texture'
  pod 'RxOptional'
  pod 'RxViewController'
  pod 'RxCodable'
  pod 'RxKeyboard'

  # UI
  pod 'BonMot'
  pod 'SwiftyColor'
  pod 'SwiftyImage'
  pod 'YPImagePicker'

  # Logging
  pod 'CocoaLumberjack/Swift'

  # Misc.
  pod 'Then'
  pod 'KeychainAccess'
  pod 'URLNavigator'
  pod 'CGFloatLiteral'
  pod 'SwiftLint'

  target 'AloneSocialClubTests' do
    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
    pod 'Stubber'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name == 'RxSwift' and config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
      end
    end
  end
end
