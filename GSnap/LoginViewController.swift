//
//  ViewController.swift
//  GSnap
//
//  Created by Naoki Muroya on 2019/02/08.
//  Copyright © 2019 thatnaoki. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idInput.delegate = self
        self.passwordInput.delegate = self
        self.errorLabel.isHidden = true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        guard let id = self.idInput.text,
            let password = self.passwordInput.text else{
                return
        }
        
        self.errorLabel.isHidden = true
        print("OK")
        
        Api.login(id: id, password: password) { errorMessage in
            
            if let message = errorMessage {
                
                self.errorLabel.isHidden = false
                self.errorLabel.text = message
                return
                
            }
            
            self.errorLabel.isHidden = true
            self.showAlert(message: "ログイン成功")
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showTimelineStoryboard()
            }
            
        }
        
    }

}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
