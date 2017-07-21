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

class SendViewController: UIViewController {
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
        
//        let backgroundSwipe = UIImageView()
//        backgroundSwipe.backgroundColor = UIColor(red:0.18, green:0.81, blue:0.61, alpha:1.0)
//        backgroundSwipe.frame = CGRect(x: 0, y: (view.frame.size.height)-(view.frame.size.height*0.1), width: view.frame.size.width, height: view.frame.size.height*0.1)
//        view.addSubview(backgroundSwipe)
//        let arrowImage = UIImageView(image: UIImage(named: "arrow-right"))
//        arrowImage.frame = CGRect(x: 0, y: (view.frame.size.height)-(backgroundSwipe.frame.size.height), width: view.frame.size.width*0.2, height: backgroundSwipe.frame.size.height)
//        arrowImage.backgroundColor = UIColor(red:0.09, green:0.4, blue:0.3, alpha:1.0)
//        arrowImage.contentMode = UIViewContentMode.scaleAspectFit
//        view.addSubview(arrowImage)
//        let swipeButton = MMSlidingButton()
//        swipeButton.frame = CGRect(x: 0, y: (view.frame.size.height)-(view.frame.size.height*0.1), width: view.frame.size.width, height: view.frame.size.height*0.1)
//        view.addSubview(swipeButton)
//        let swipeLabel = UILabel()
//        swipeLabel.text = "Swipe to send"
//        swipeLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.ultraLight)
//        swipeLabel.frame = CGRect(x: view.frame.size.width*0.3, y: view.frame.size.height - backgroundSwipe.frame.size.height, width: backgroundSwipe.frame.size.width - view.frame.size.width*0.25, height: backgroundSwipe.frame.size.height)
//        view.addSubview(swipeLabel)
//
    }
//    
//    func isUnlocked() {
//        print("unlocked")
//    }
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var amountToSend: UITextField!
    @IBOutlet weak var moreErrorLabel: UILabel!
    @IBOutlet weak var errorLabelNotEnough: UILabel!
    
    @IBOutlet weak var temp: UIButton!
    @IBAction func tempbtn(_ sender: Any) {
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
                    if CurrentUserCoins < 0{
                        self.errorLabelNotEnough.isHidden = false
                    } else {
                        self.ref.child("users").child(userID!).setValue(["Coins":CurrentUserCoins])
                        // add coins to user ->
                        self.ref.child("users").child(self.phoneNum.text!).setValue(["Coins":OtherUserCoins])
                    }
            
            })
            
            //let newAmountOtherUser Int(amountToSend.text!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
        
    }
    

}
