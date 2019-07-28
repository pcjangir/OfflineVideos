//
//  MovieTableViewCell.swift
//  OfflineVideos
//
//  Created by Poonam on 27/07/19.
//  Copyright © 2019 Poonam. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    let imageCache = NSCache<NSString,UIImage>()
    var urlString = ""
    
    var movieInfo: Movie? {
        didSet {
            label.text = movieInfo?.title!.capitalized
            if let urlString = movieInfo?.thumb, urlString.count > 0 {
                self.urlString = urlString
                if let image = imageCache.object(forKey: urlString as NSString) {
                    thumbnailIcon.image = image
                }
                else {
                    if let url = URL(string: urlString) {
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                            if let data = data {
                                DispatchQueue.main.async {
                                    self.imageCache.setObject(UIImage(data: data)!, forKey: urlString as NSString)
                                    if self.urlString == urlString {
                                        self.thumbnailIcon.image = UIImage(data: data)
                                    }
                                }
                            }
                        }).resume()
                    }
                }
            }
        }
    }
    
    let thumbnailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(thumbnailIcon)
        contentView.addSubview(label)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[vo(80)]-20-[v1]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vo": thumbnailIcon, "v1" : label]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[vo]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vo":thumbnailIcon]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[vo]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vo":label]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
