//
//  CompositionRoot.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

struct AppDependency {

}

extension AppDependency {
  static func resolve() -> AppDependency {
    return AppDependency()
  }
}
