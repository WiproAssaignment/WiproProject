//
//  ImageDownloader.swift
//  WiproAssignment
//
//  Created by Nallagangula Pavan Kumar on 02/06/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImageView Extension
extension UIImageView {
    /// activityIndicatorTag
    private static let activityIndicatorTag = 55_555
    /// Image From Server URL
    ///
    /// - Parameter urlString: Url String
    public func imageFromServerURL(urlString: String) {
        imageFromServerURL(urlString: urlString, isCache: false)
    }

    /// ImageFromServerURL
    ///
    /// - Parameters:
    ///   - urlString: String Object
    ///   - isCache: Boolean (Cache)
    public func imageFromServerURL(urlString: String, isCache: Bool) {
        if isCache {
            /// if cache is enabled
            let urlStr = NSString(string: urlString).deletingLastPathComponent
            let imageName = NSString(string: urlStr).lastPathComponent
             /// cachePath
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            /// Appending both components
            let imagePath = NSString(string: cachePath).appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: imagePath) {
                print("file exists in new path ::: \(imagePath)")
            } else {
                print("file not exists in new path ::: \(imagePath)")
            }

                if let data = NSData(contentsOfFile: imagePath) {
                    // NSData convert to UIImage
                    let receivedImage = UIImage(data: data as Data) ?? UIImage()

                    DispatchQueue.main.async { [weak self] in
                        //Updating Profile Image
                        var newImage: UIImage?
                           newImage = receivedImage
                        self?.image = newImage
                    }
                    return
                }
        }

        var viewActivityIndicator: UIActivityIndicatorView!
        if let indecator = self.viewWithTag(UIImageView.activityIndicatorTag) as? UIActivityIndicatorView {
            viewActivityIndicator = indecator
        } else {
            self.backgroundColor = UIColor.black
            /// Initializing white large indicator
            viewActivityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            viewActivityIndicator.tag = UIImageView.activityIndicatorTag
            viewActivityIndicator.frame = CGRect(x: self.frame.size.width / 2 - viewActivityIndicator.frame.size.width / 2, y: self.frame.size.height / 2 - viewActivityIndicator.frame.size.height / 2, width: viewActivityIndicator.frame.size.width, height: viewActivityIndicator.frame.size.height)
            viewActivityIndicator.hidesWhenStopped = true
            self.addSubview(viewActivityIndicator)
        }
        viewActivityIndicator.startAnimating()

        guard let imageURL = URL(string: urlString) else {
            self.backgroundColor = UIColor.clear
            viewActivityIndicator.stopAnimating()
            return
        }

        /// Creating dataTask
        /// This will download the image
        URLSession.shared.dataTask(with: imageURL) { data, _, _  in
            guard let data = data else {
                /// Stoping animation on main thread
                DispatchQueue.main.async {
                    self.backgroundColor = UIColor.clear
                    viewActivityIndicator.stopAnimating()
                }
                return
            }

            var providermage: UIImage = UIImage()
                    providermage = UIImage(data: data as Data) ?? UIImage()


            if isCache {
                /// if cache is enabled
                /// last path component comes from url is similar for all images
                /// so removed last path component, able to get the separate images name
                /// use this name to save the images into cache for further use
                let urlStr = NSString(string: urlString).deletingLastPathComponent
                let imageName = NSString(string: urlStr).lastPathComponent

                /// cachePath
                let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
                /// Appending imagePath & CachePath
                let imagePath = NSString(string: cachePath).appendingPathComponent(imageName)

                if FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil) {
                    print("image file is create in path :: \(imagePath)")
                } else {
                    print("image file can't able to create in path :: \(imagePath)")
                }
            }
            /// Using mainthread to update image
            DispatchQueue.main.async { [weak self] in
                //Updating Profile Image
                var newImage: UIImage?
                    newImage = providermage
                // set a downloaded image to UIImageView
                self?.image = newImage
                self?.backgroundColor = UIColor.clear
                viewActivityIndicator.stopAnimating()
            }
        }.resume()
    }
   
}
