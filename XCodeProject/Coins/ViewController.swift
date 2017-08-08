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
    
    
    
    var ContactsArray = [[String:AnyObject]]()
    func hideNoConnectionError() {
        noconnectionerror.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            // do nothing in this case
        }else{
            print("Internet Connection not Available!")
            noconnectionerror.isHidden = false
            _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(hideNoConnectionError), userInfo: nil, repeats: false)
            // things are not going to load...
        }
        
        
        
        
        ref = Database.database().reference()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        let userID = Auth.auth().currentUser!.uid
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(GetCoins), userInfo: nil, repeats: true)
        GetCoins()

        
        //end of viewdidload()
    }
    
    @IBOutlet weak var noconnectionerror: UILabel!

    var numofcoins = Float()
    
    @objc func GetCoinsFirstTime() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("Coins").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value
            //let newnum = NSString(format: "%@", value as! CVarArg) as Float
            let newnum = value as! Float
            self.numofcoins = newnum
            self.CoinCount.countFrom(fromValue: 0, to: newnum, withDuration: 1.0, andAnimationType: .EaseOut, andCountingType: .Int)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @objc func GetCoins() {
        if let userID = Auth.auth().currentUser?.uid{
            ref.child("users").child(userID).child("Coins").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value
            //let newnum = NSString(format: "%@", value as! CVarArg) as Float
            let newnum = value as? Float
            self.numofcoins = newnum!
            self.CoinCount.countFrom(fromValue: self.numofcoins, to: newnum!, withDuration: 1.0, andAnimationType: .EaseOut, andCountingType: .Int)
        }) { (error) in
            print(error.localizedDescription)
        }
        } else{
            print("User signed out.")
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
        GetCoinsFirstTime()
        let url1 = Auth.auth().currentUser!.uid
        print(url1)
        var qrCode = QRCode(url1)
        qrCode?.color = CIColor(red:0.34, green:0.69, blue:0.54, alpha:1.0)
        qrCode?.backgroundColor = CIColor(red:0.11, green: 0.12, blue:0.14, alpha:1.0)
        //qrCode?.backgroundColor = CIColor(red:1.00, green: 1.00, blue:1.00, alpha:1.0)
        imageView.image = qrCode?.image
    }
    
}


