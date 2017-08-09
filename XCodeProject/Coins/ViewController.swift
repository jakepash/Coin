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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    
    
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["John Smith", "+4", "Johnny Appleseed", "-3", "(650)-353-0023", "+12", "John Smith", "+4", "Johnny Appleseed", "-3", "(650)-353-0023", "+12", "John Smith", "+4", "Johnny Appleseed", "-3", "(650)-353-0023", "+12", "John Smith", "+4", "Johnny Appleseed", "-3", "(650)-353-0023", "+12"]
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LedgerCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.items[indexPath.item]
        //  cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        if cell.myLabel.text![0] == "+" {
            cell.myLabel.textColor = UIColor(red:0.02, green:0.69, blue:0.00, alpha:1.0)
            cell.myLabel.textAlignment = .right
        } else if cell.myLabel.text![0] == "-" {
            cell.myLabel.textColor = UIColor(red:0.69, green:0.05, blue:0.00, alpha:1.0)
            cell.myLabel.textAlignment = .right
        } else {
            cell.myLabel.textColor = UIColor.white
            cell.myLabel.textAlignment = .left
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
}

