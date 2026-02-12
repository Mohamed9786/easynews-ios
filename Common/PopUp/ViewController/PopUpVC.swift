//
//  PopUpVC.swift
//  EasyNews
//
//  Created by Mohamed Ali on 27/01/26.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var popupMessage: String?
    var popupTitle: String?
    var popupImage: UIImage?
    var onConfirm: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = popupMessage
        titleLabel.text = popupTitle
        imageView.image = popupImage
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    
    @IBAction func okButtonTap(_ sender: Any) {
        dismiss(animated: false){
            self.onConfirm?()
        }
    }
    
    static func showErrorPopup(from vc: UIViewController, message: String, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let popupVC = storyboard.instantiateViewController(
            withIdentifier: "PopUpVC"
        ) as! PopUpVC

        popupVC.popupMessage = message
        popupVC.popupTitle = "Error"
        popupVC.popupImage = UIImage(systemName: "xmark.circle")
        popupVC.onConfirm = completion
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve

        vc.present(popupVC, animated: true)
    }
    
    static func showSuccessPopup(from vc: UIViewController, message: String, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let popupVC = storyboard.instantiateViewController(
            withIdentifier: "PopUpVC"
        ) as! PopUpVC
        
        popupVC.popupTitle = "Success"
        popupVC.popupImage = UIImage(systemName: "checkmark.circle")
        popupVC.popupMessage = message
        popupVC.onConfirm = completion
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve

        vc.present(popupVC, animated: true)
    }

}
