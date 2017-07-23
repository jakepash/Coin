//
//  VerifyViewController.swift
//  Coins
//
//  Created by Adam on 7/20/17.
//  Copyright © 2017 Jacob Pashman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VerifyViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var code: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "AuthVID")!, verificationCode: code.text!)
        Auth.auth().signIn(with: credential) { (user, error ) in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                print ("Phone Number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
//                let userID = Auth.auth().currentUser!.uid
                self.ref.child("users").child((user?.uid)!).setValue(["Coins": 0,"phoneNumber":user?.phoneNumber])
                self.performSegue(withIdentifier: "segue2", sender: Any?.self)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        code.becomeFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
