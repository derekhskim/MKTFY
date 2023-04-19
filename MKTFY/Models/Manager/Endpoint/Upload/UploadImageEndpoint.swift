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
            let resizedImage = resizeImage(image, targetSize: CGSize(width: 1024, height: 1024))
            if let imageData = resizedImage.jpegData(compressionQuality: 0.3) {
                print("Processing image \(index) \(image)")
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
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
