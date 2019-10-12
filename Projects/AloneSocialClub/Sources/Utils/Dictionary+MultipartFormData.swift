//
//  Dictionary+MultipartFormData.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import Moya

extension Dictionary {
  /// - note: For images, the dictionary key is used for the name and the filename. UIImages are always encoded as JPEG format.
  func asMultipartFormData() -> [MultipartFormData] {
    return self.compactMap { key, value -> MultipartFormData? in
      guard let provider = self.formDataProvider(for: value) else { return nil }
      let name = String(describing: key)
      let fileName = self.fileName(forKey: name, value: value)
      let mimeType: String? = (value is UIImage) ? "image/jpeg" : nil
      return MultipartFormData(provider: provider, name: name, fileName: fileName, mimeType: mimeType)
    }
  }

  private func formDataProvider(for value: Any?) -> MultipartFormData.FormDataProvider? {
    guard let value = value else { return nil }
    switch value {
    case let data as Data:
      return .data(data)

    case let string as String:
      return self.formDataProvider(for: string.data(using: .utf8))

    case let number as NSNumber:
      return self.formDataProvider(for: number.stringValue)

    case let image as UIImage:
      return self.formDataProvider(for: image.jpegData(compressionQuality: 1))

    default:
      return nil
    }
  }

  private func fileName(forKey key: String, value: Any?) -> String? {
    if value is UIImage {
      return key
    } else {
      return nil
    }
  }
}
