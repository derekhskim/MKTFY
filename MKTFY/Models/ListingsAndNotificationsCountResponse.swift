//
//  File.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-12.
//

import Foundation

struct ListingsAndNotificationsCountResponse: Codable {
    let unreadNotifications, pendingListings: Int
}
