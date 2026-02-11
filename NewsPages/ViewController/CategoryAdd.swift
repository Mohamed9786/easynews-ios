//
//  CategoryAdd.swift
//  EasyNews
//
//  Created by Mohamed Ali on 10/02/26.
//

import UIKit

class CategoryAddVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var newCategory: UITextField!
    var onCategoryAdded: ((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        newCategory.delegate = self
        newCategory.returnKeyType = .done
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    @IBAction func closeAdd(_ sender: Any) {
        if let str = newCategory.text, !str.isEmpty{
            onCategoryAdded?(str)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newCategory.resignFirstResponder()
        return true
    }
    
}
