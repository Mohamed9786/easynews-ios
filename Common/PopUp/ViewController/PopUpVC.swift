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
    @IBOutlet weak var error: UILabel!
    var popupMessage: String?
    var onConfirm: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        error.text = popupMessage
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
        popupVC.onConfirm = completion
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve

        vc.present(popupVC, animated: true)
    }

}
