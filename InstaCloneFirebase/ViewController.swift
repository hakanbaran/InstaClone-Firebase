//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Hakan Baran on 26.09.2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            
            performSegue(withIdentifier: "toFeedVC", sender: nil)
        }
        
        
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authDataResult, error in
                
                if error != nil {
                    self.makeAlert(titleImput: "Error", messageImput: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            
            makeAlert(titleImput: "Error!", messageImput: "Please Enter Email/Password")
        }

        
        
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authDataResult, error in
                
                if error != nil {
                    self.makeAlert(titleImput: "Error", messageImput: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            
            makeAlert(titleImput: "Error!", messageImput: "Please Enter Email/Password")
        }
        
        
        
        
    }
    
    func makeAlert(titleImput: String, messageImput: String) {
        
        let alert = UIAlertController(title: titleImput, message: messageImput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

