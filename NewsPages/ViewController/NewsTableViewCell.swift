//
//  NewsTableViewCell.swift
//  EasyNews
//
//  Created by Mohamed Ali on 20/01/26.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var urlimage: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        urlimage.layer.cornerRadius = 10
        urlimage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
