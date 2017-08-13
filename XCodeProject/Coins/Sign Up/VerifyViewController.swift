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
import Firebase
import FirebaseRemoteConfig

class VerifyViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityindicator.isHidden = true
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
    
    var signupcoins = Int()
    
    @IBAction func Login(_ sender: Any) {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "AuthVID")!, verificationCode: code.text!)
        Auth.auth().signIn(with: credential) { (user, error ) in
            self.self.activityindicator.isHidden = false
            self.activityindicator.startAnimating()
            if error != nil {
                print(error?.localizedDescription)
                // show error
                //stop animating activity indicator
                self.activityindicator.isHidden = true
            }else {
                let phoneNumber = user?.phoneNumber
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
//                let userID = Auth.auth().currentUser!.uid
                    self.ref.child("users").observeSingleEvent(of: .value, with: {(snap) in
                        if snap.hasChild((user?.uid)!){
                            // User exists
                            self.performSegue(withIdentifier: "segue2", sender: Any?.self)
                        }else{
                            
                            // New User
                            self.ref.child("Promo").observeSingleEvent(of: .value, with: { (snapshot) in
                                // Get user value
                                let value = snapshot.value as? NSDictionary
                                self.signupcoins = value?["SignUpCoins"] as? Int ?? 10
                                print(self.signupcoins)
                                let inviteCode = ShortCodeGenerator.getCode(length: 6)
                                self.ref.child("users").child((user?.uid)!).setValue(["Coins": self.signupcoins, "PhoneNumber":phoneNumber,"InviteCode": inviteCode])
                                self.performSegue(withIdentifier: "segue2", sender: Any?.self)
                                // ...
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            
                        }
                    })

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

struct ShortCodeGenerator {
    
    private static let base62chars = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
    private static let maxBase : UInt32 = 62
    
    static func getCode(withBase base: UInt32 = maxBase, length: Int) -> String {
        var code = ""
        for _ in 0..<length {
            let random = Int(arc4random_uniform(min(base, maxBase)))
            code.append(base62chars[random])
        }
        return code
    }
}
