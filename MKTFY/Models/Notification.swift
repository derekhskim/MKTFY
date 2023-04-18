//
//  Notification.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-21.
//

import Foundation

struct Notification {
    let title: String
    let date: String

    init(title: String, date: String) {
        self.title = title
        self.date = date
    }

    init(from notificationData: NotificationData) {
        self.title = notificationData.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        if let date = dateFormatter.date(from: notificationData.created) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            self.date = dateFormatter.string(from: date)
        } else {
            self.date = ""
        }
    }
}

// MARK: - NotificationResponse
struct NotificationResponse: Codable {
    let new, seen: [NotificationData]
}

// MARK: - NotificationData
struct NotificationData: Codable {
    let id, message, created: String
    let read: Bool
}
