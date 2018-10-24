//
//  ViewController.swift
//  ShareTheBook
//
//  Created by Damir Gaynetdinov on 08/10/2018.
//  Copyright © 2018 Galina Gainetdinova. All rights reserved.
//
import Parse
import UIKit

class ViewController: UIViewController {

    var logInFlag = false
    var activityIndicator = UIActivityIndicatorView()


    @IBOutlet weak var logInOrSignUpButton: UIButton!
    @IBOutlet weak var changeModeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialisation of Parse
        Parse.initialize()
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "d5f370c19c433e4af4a3fb327429cc561c48188b"
            ParseMutableClientConfiguration.clientKey = "e326e442fe67eb8288352b71635ecef6676b1eb2"
            ParseMutableClientConfiguration.server = "http://18.191.188.44:80/parse"
        })
        
        Parse.initialize(with: parseConfiguration)
        PFUser.enableAutomaticUser()
    }

    @IBAction func changeLogInMode(_ sender: Any) {
        if logInFlag {
            //sign up mode
            logInOrSignUpButton.setTitle("Log In", for: [])
            changeModeButton.setTitle("Sign Up", for: [])
            messageLabel.text = "Do you have an account?"
            logInFlag = false
        }
        else {
            //login mode
            logInOrSignUpButton.setTitle("Sign Up", for: [])
            changeModeButton.setTitle("Log In", for: [])
            messageLabel.text = "Are you a new User?"
            logInFlag = true
        }
    }
    func CreateAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginOrSignUp(_ sender: Any) {
 
        if passwordTextField.text == "" || emailTextField.text == "" {
            CreateAlert(title: "Warning", message: "The password or/and email are incorrect")
        }
        else {
            //Launch Activity Indicator
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if !logInFlag {
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error != nil {
                        self.CreateAlert(title: "Error", message: "Parse error")
                    }
                    else {
                        print("Success")
                    }
                })
            }
            else {
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground( block: { (success, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        self.CreateAlert(title: "Error", message: "Parse error")
                    }
                    else {
                        print("Success")
                    }
                })
            }
        }
    }
}

