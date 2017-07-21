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


}

