//
//  SendViewController.swift
//  Coins
//
//  Created by Jacob Pashman on 7/2/17.
//  Copyright © 2017 Jacob Pashman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SendViewController: UIViewController, SlideButtonDelegate {
    
    
    
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
        self.SlideToSend.delegate = self
    }
    
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var amountToSend: UITextField!
    @IBOutlet weak var moreErrorLabel: UILabel!
    @IBOutlet weak var errorLabelNotEnough: UILabel!
    @IBOutlet weak var SlideToSend: MMSlidingButton!
    
    func buttonStatus(status: String, sender: MMSlidingButton) {
        let userID = Auth.auth().currentUser?.uid
        if let amounttosend = Int(amountToSend.text!){
            if amounttosend < 100 {
                moreErrorLabel.isHidden = true
                let UserToSend = phoneNum.text!
                
                //
                GetCoins()
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "seguetomain", sender: nil)
                })
                
                
            }
            else {
                moreErrorLabel.isHidden = false
            }
        }
        
    }
    func GetCoins() {
        ref.child("users").child(phoneNum.text!).child("Coins").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            
            var OtherUserCoins = value as! Int
            print(OtherUserCoins)
            
            
            let amounttosend = Int(self.amountToSend.text!)
            OtherUserCoins += amounttosend!
            // subtract coins from current user ->
            let userID = Auth.auth().currentUser?.uid
            self.ref.child("users").child(userID!
                ).child("Coins").observeSingleEvent(of: .value, with: { (othersnapshot) in
                    let userID = Auth.auth().currentUser?.uid
                    let othervalue = othersnapshot.value
                    var CurrentUserCoins = othervalue as! Int
                    print(CurrentUserCoins)
                    CurrentUserCoins -= amounttosend!
                    // continue doing this -
//                    if CurrentUserCoins < 0{
//                        print ("cant")
//                    } else {
//                        self.ref.child("users").child(userID!).setValue(["Coins":CurrentUserCoins])
//                        // add coins to user ->
//                        self.ref.child("users").child(self.phoneNum.text!).setValue(["Coins":OtherUserCoins])
//                    }
                    self.ref.child("users").child(userID!).setValue(["Coins":CurrentUserCoins])
                        // add coins to user ->
                     self.ref.child("users").child(self.phoneNum.text!).setValue(["Coins":OtherUserCoins])
                    
            })
            
            //let newAmountOtherUser Int(amountToSend.text!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
        
    }
    

