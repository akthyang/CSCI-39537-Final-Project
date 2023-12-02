//
//  UIImageView+Extension.swift
//  Books2Love
//  Source Code: From the book
//
//  Created by Alicia Yang on 11/14/23.
//  MARK: Loads image from url

import UIKit

extension UIImageView {
    func loadImage(url: URL) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, _, error in
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        downloadTask.resume()
    }
}
