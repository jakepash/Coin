//
//  ViewController.swift
//  Coins
//
//  Created by Jacob Pashman on 7/2/17.
//  Copyright © 2017 Jacob Pashman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import QRCode


class ViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var CoinCount: UILabel!
    
    var gameTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        let userID = Auth.auth().currentUser!.uid
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GetCoins), userInfo: nil, repeats: true)
        //self.ref.child("users").child((userID)).setValue(["Coins": 0])
        GetCoins()
       print(Auth.auth().currentUser?.phoneNumber)
    }
    
    @IBOutlet weak var signout: UIButton!
    @IBAction func signout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @objc func GetCoins() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("Coins").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value
            self.CoinCount.text = NSString(format: "%@", value as! CVarArg) as String
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        let url1 = "http://api.qrserver.com/v1/create-qr-code/?data=\(String(describing: Auth.auth().currentUser!.uid))&size=200x200"
        print(url1)
        var qrCode = QRCode(url1)
        qrCode?.color = CIColor(red:0.18, green: 0.81, blue:0.61, alpha:1.0)
        qrCode?.backgroundColor = CIColor(red:0.11, green: 0.12, blue:0.14, alpha:1.0)
        imageView.image = qrCode?.image
    }
    
}
