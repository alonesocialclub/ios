//
//  AuthTokenStore.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

final class AuthTokenStore {
  private static let key = "authToken"
  private let keychain: KeychainProtocol

  init(keychain: KeychainProtocol) {
    self.keychain = keychain
  }

  func save(_ authToken: String) throws {
    try self.keychain.set(authToken, key: Self.key)
  }

  func authToken() -> String? {
    return try? self.keychain.get(Self.key)
  }
}
