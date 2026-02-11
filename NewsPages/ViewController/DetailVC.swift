//
//  Detail.swift
//  EasyNews
//
//  Created by Mohamed Ali on 20/01/26.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var newsContent: UITextView!
    
    var selectedArticle: Articles?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
        if let article = selectedArticle {
            newsTitle.text = article.title
            newsContent.text = article.content
        }
    }
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blurEffectView)
    }

}
