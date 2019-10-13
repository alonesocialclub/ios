//
//  Date+TimeAgo.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import Foundation

extension Date {
  var timeAgo: String {
    return self.timeAgo(from: Date())
  }

  func timeAgo(from date: Date) -> String {
    let seconds = Int(date.timeIntervalSince(self))
    switch seconds {
    case ..<10.seconds:
      return "Just now"

    case ..<60.seconds:
      return "\(seconds) seconds ago"

    case 1.minute:
      return "A minute ago"

    case ..<60.minutes:
      let minutes = seconds / 60
      return "\(minutes) minutes ago"

    case 1.hour:
      return "An hour ago"

    case ..<24.hours:
      let hours = seconds / 3600
      return "\(hours) hours ago"

    default:
      break
    }

    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .day], from: self, to: date)

    let years = components.year ?? 0
    let days = components.day ?? 0

    switch (years, days) {
    case (0, 1):
      return "Yesterday"

    case (0, ..<7):
      return "\(days) days ago"

    case (0, 7):
      return "A week ago"

    case (0, _):
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d"
      return formatter.string(from: self)

    default:
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      return formatter.string(from: self)
    }
  }
}

private extension Int {
  var seconds: Int { self }
  var minute: Int { self.minutes }
  var minutes: Int { self * 60 }
  var hour: Int { self.hours }
  var hours: Int { self.minutes * 60 }
}
