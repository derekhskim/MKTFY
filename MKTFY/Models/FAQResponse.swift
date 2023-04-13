//
//  FAQResponse.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-07.
//

import Foundation

// MARK: - FAQResponse
struct FAQResponse: Codable {
    let id, question, answer: String
}

typealias FAQResponses = [FAQResponse]
