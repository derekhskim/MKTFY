//
//  UploadImageEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-05.
//

import UIKit

struct UploadImageEndpoint: Endpoint {
    typealias ResponseType = [ImageResponse]
    
    let boundary = UUID().uuidString    
    let images: [UIImage]
    
    var path: String {
        return "/upload"
    }
    
    var httpMethod: HttpMethod {
        return .post
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        print("Boundary: \(boundary)")
        return headers
    }
    
    var body: Data? {
        return createFormData(with: images, boundary: boundary)
    }

    private func createFormData(with images: [UIImage], boundary: String) -> Data {
        var data = Data()

        print("Total images: \(images.count)")
        
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                print("Processing image \(index) \(image)")
                // Add boundary to separate image data
                data.append("--\(boundary)\r\n")
                data.append("Content-Disposition: form-data; name=\"image\(index)\"; filename=\"image\(index).jpg\"\r\n")
                data.append("Content-Type: image/jpeg\r\n\r\n")
                data.append(imageData)
                data.append("\r\n")
            }
        }
        data.append("--\(boundary)--\r\n")
        return data
    }

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
