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
import SearchTextField
import Contacts

class SendViewController: UIViewController, SlideButtonDelegate {
    
    var ContactsArray = [String]()
    
    var qeuetimer: Timer!
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
        self.SlideToSend.delegate = self
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (isGranted, error) in
            // Check the isGranted flag and proceed if true
        }
        phoneNum.theme.font = UIFont.systemFont(ofSize: 14)
        
        phoneNum.theme.bgColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        phoneNum.theme.borderColor = UIColor(red:0.15, green:0.70, blue:0.53, alpha:1)
        phoneNum.theme.separatorColor = UIColor(red:0.15, green:0.70, blue:0.53, alpha:0.5)
        phoneNum.theme.fontColor = UIColor(red:0.15, green:0.70, blue:0.53, alpha:1)
        phoneNum.theme.cellHeight = 50
        getContactsArray()
        qeuetimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
    }

    func runTimedCode() {
        phoneNum.filterStrings(ContactsArray)
    }
    
    @IBOutlet weak var phoneNum: SearchTextField!
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
                GetCoins()
            }
            else {
                moreErrorLabel.isHidden = false
                SlideToSend.reset()
                _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.hideOtherErrors), userInfo: nil, repeats: false)
            }
        }
        
    }
    
    func hideOtherErrors() {
        moreErrorLabel.isHidden = true
    }
    
    
    var OtherUserCoins = Int()
    var senderUID = String()
    
    
    
    func GetCoins() {
        // synchronisly

        let myGroup = DispatchGroup()
        myGroup.enter()
        //// Do your task
        if let indexOfA = ContactsArray.index(of: phoneNum.text!){
            let phoneNumberForUID = phoneNumberArray[indexOfA] as? String
            let FinalNum = phoneNumberForUID
            recognizeNumber(phone: FinalNum!)
        }
        self.ref.child("users").queryOrdered(byChild:"PhoneNumber").queryEqual(toValue: fullPhoneNumber).observeSingleEvent(of: .value) { (snap, st) in
            for snapp in snap.children {
                print("UID: \((snapp as! DataSnapshot).key)")
                self.senderUID = (snapp as! DataSnapshot).key
            }
        }
        //// When you task complete
        myGroup.leave()
        myGroup.notify(queue: DispatchQueue.main) {
            
            ////// do your remaining work
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.coins), userInfo: nil, repeats: false)
        }
       
    }
    
    func hideErrors() {
        errorLabelNotEnough.isHidden = true
    }
    var transactionArray = [NSDictionary]()
    func coins() {
        //
        //        print("their uid is - \(senderUID)")
        if senderUID != Auth.auth().currentUser?.uid {
        ref.child("users").child(senderUID).child("Coins").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            if snapshot.exists(){
                self.OtherUserCoins = value as! Int
                
                print(self.OtherUserCoins)
                
                let amounttosend = Int(self.amountToSend.text!)
                self.OtherUserCoins += amounttosend!
                // subtract coins from current user ->
                let userID = Auth.auth().currentUser?.uid
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (othersnapshot) in
                        let userID = Auth.auth().currentUser?.uid
                        let phoneNumber = othersnapshot.childSnapshot(forPath: "PhoneNumber").value
                        let othervalue = othersnapshot.childSnapshot(forPath: "Coins").value
                        var CurrentUserCoins = othervalue as! Int
                        print(CurrentUserCoins)
                        CurrentUserCoins -= amounttosend!
                        // continue doing this -
                        if CurrentUserCoins < 1{
                            print ("cant")
                            self.SlideToSend.reset()
                            self.errorLabelNotEnough.isHidden = false
                            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.hideErrors), userInfo: nil, repeats: false)
                        } else {
                            self.ref.child("users").child(userID!).updateChildValues(["Coins":CurrentUserCoins])
                            // add coins to user ->
                            self.ref.child("users").child(self.senderUID).updateChildValues(["Coins":self.OtherUserCoins])
                            self.ref.child("users/\(self.senderUID)/PhoneNumber").observeSingleEvent(of: .value, with: { (datasnap) in
                                self.ref.child("users").child(userID!).child("Transactions").updateChildValues([datasnap.value as! AnyHashable : amounttosend])
                                self.ref.child("users").child(self.senderUID).child("Transactions").updateChildValues([phoneNumber as! AnyHashable : amounttosend])
                            })
                            self.performSegue(withIdentifier: "seguetomain", sender: nil)
                        }
                        //self.ref.child("users").child(userID!).setValue(["Coins":CurrentUserCoins])
                        // add coins to user ->
                        //self.ref.child("users").child(self.phoneNum.text!).setValue(["Coins":OtherUserCoins])
                        
                    })
                
                //let newAmountOtherUser Int(amountToSend.text!)
            } else {
                print("User doesn't exist")
                self.SlideToSend.reset()
            }
            
        }) { (error) in
            print(error.localizedDescription)
            self.SlideToSend.reset()
            }
        }
        else {
            print("cant send money to yourself")
        }
    }
    @objc func didTapView(){
        self.view.endEditing(true)
        
    }
    
    func getContactsArray() {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                //NSLog("Fetch contact error: \(error)")
            }
            
            //NSLog(">>>> Contact list:")
            for contact in cnContacts {
                if contact.phoneNumbers.count > 0{
                    //print("First Name: \(contact.givenName) Last Name: \(contact.familyName)  Phone Number: \(contact.phoneNumbers[0].value.stringValue)")
                    let PhoneNumber = contact.phoneNumbers[0].value.stringValue
                    let fullName = contact.givenName + " " + contact.familyName
                    //                    self.ContactsArray.append([fullName:PhoneNumber as AnyObject])
                    self.ContactsArray.append(fullName)
                    self.phoneNumberArray.append(PhoneNumber)
                }else {
                    //print("its okay. But there is an error")
                }
            }
            //            for a in self.ContactsArray{
            //                print(a)
            //            }
        })
        
        
    }
    
    var phoneNumberArray = [String]()
    
    
}

