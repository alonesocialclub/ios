//
//  KeychainProtocol.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import KeychainAccess

protocol KeychainProtocol {
  func get(_ key: String) throws -> String?
  func set(_ value: String, key: String) throws
}

extension Keychain: KeychainProtocol {
}
