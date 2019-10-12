platform :ios, '12.0'

inhibit_all_warnings!
use_frameworks!

target 'AloneSocial' do
  pod 'ReactorKit'
  pod 'Texture'

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

  target 'AloneSocialTests' do
    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
    pod 'Stubber'
  end
end
