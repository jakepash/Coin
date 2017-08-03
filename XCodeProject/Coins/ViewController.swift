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
import QRCode
import CoreTelephony
import SACountingLabel

class ViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var CoinCount: SACountingLabel!
    
    var gameTimer: Timer!
    
    var ContactsArray = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            // do nothing in this case
        }else{
            print("Internet Connection not Available!")
            // things are not going to load...
        }
        
        
        ref = Database.database().reference()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        let userID = Auth.auth().currentUser!.uid
        gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(GetCoins), userInfo: nil, repeats: true)
        GetCoins()

        
        //end of viewdidload()
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
            //let newnum = NSString(format: "%@", value as! CVarArg) as Float
            let newnum = value as! Float
            self.CoinCount.countFrom(fromValue: 0, to: newnum, withDuration: 1.0, andAnimationType: .EaseOut, andCountingType: .Int)
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
        let url1 = Auth.auth().currentUser!.uid
        print(url1)
        var qrCode = QRCode(url1)
        qrCode?.color = CIColor(red:0.18, green: 0.81, blue:0.61, alpha:1.0)
        qrCode?.backgroundColor = CIColor(red:0.11, green: 0.12, blue:0.14, alpha:1.0)
        imageView.image = qrCode?.image
    }
    
}
