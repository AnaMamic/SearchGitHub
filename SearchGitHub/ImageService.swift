//
//  ImageService.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 06/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    static func getImageFrom(url: URL) -> UIImage? {
        guard let data = NSData(contentsOf: url) as? Data else {
            return nil
        }
        return UIImage(data: data)

    }
    
    class func generateThumbnail(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return thumbnailImage
    }

}
