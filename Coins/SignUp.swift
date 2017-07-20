//
//  SignUp.swift
//  Coins
//
//  Created by Jacob Pashman on 7/2/17.
//  Copyright © 2017 Labby Labs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUp: UIViewController {
    
    @IBOutlet weak var phoneLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    @IBAction func ToVerifyBtn(_ sender: Any) {
        tapped()
    }
    
    
    func tapped() {
        print("pressed")
        let alert = UIAlertController(title: "Phone Number", message: "Is this your phone number?\(phoneLabel.text!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneLabel.text!) { (verificationID, error) in
                if error != nil{
                    print(error?.localizedDescription)
                } else {
                    let defaults = UserDefaults.standard
                    defaults.set(verificationID, forKey: "AuthVID")
                    self.performSegue(withIdentifier: "segue1", sender: Any?.self)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("This is their UID: \(String(describing: Auth.auth().currentUser?.uid))")
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "segueToMain", sender: self)
        }
    }
    
    
    

}
