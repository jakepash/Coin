//
//  SignUp.swift
//  Coins
//
//  Created by Jacob Pashman on 7/2/17.
//  Copyright © 2017 Jacob Pashman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUp: UIViewController {
    var UserID = ""
    var country = ""
    @IBOutlet weak var phoneLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    @IBAction func nextbtn(_ sender: Any) {
        sendSMS(phonenumber: phoneLabel.text!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendSMS(phonenumber: String){
        let url = "https://api.checkmobi.com/v1/validation/request"
        let parameters: Parameters = [
            "number": phonenumber,
            "type": "sms",
            "platform":"web"
        ]
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "2AB38404-3E29-4803-9AD7-020A38DAC501"
        ]
        
        // All three of these calls are equivalent
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    if status != 200{
                        print("servers are down :)")
                    }
                }
                //to get JSON return value
                if let json = response.data {
                    let data = JSON(data: json)
                    self.UserID = String(describing: data["id"])
                    self.country = String(describing: data["validation_info"]["country_iso_code"])
                    print(self.UserID)
                    print(self.country)
                }
        }
        
    }
    

}
