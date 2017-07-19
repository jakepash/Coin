//
//  SendViewController.swift
//  Coins
//
//  Created by Jacob Pashman on 7/2/17.
//  Copyright © 2017 Jacob Pashman. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backgroundSwipe = UIImageView()
        backgroundSwipe.backgroundColor = UIColor(red:0.18, green:0.81, blue:0.61, alpha:1.0)
        backgroundSwipe.frame = CGRect(x: 0, y: (view.frame.size.height)-(view.frame.size.height*0.1), width: view.frame.size.width, height: view.frame.size.height*0.1)
        view.addSubview(backgroundSwipe)
        let arrowImage = UIImageView(image: UIImage(named: "arrow-right"))
        arrowImage.frame = CGRect(x: 0, y: (view.frame.size.height)-(backgroundSwipe.frame.size.height), width: view.frame.size.width*0.2, height: backgroundSwipe.frame.size.height)
        arrowImage.backgroundColor = UIColor(red:0.09, green:0.4, blue:0.3, alpha:1.0)
        arrowImage.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(arrowImage)
        let swipeButton = MMSlidingButton()
        swipeButton.frame = CGRect(x: 0, y: (view.frame.size.height)-(view.frame.size.height*0.1), width: view.frame.size.width, height: view.frame.size.height*0.1)
        view.addSubview(swipeButton)
        let swipeLabel = UILabel()
        swipeLabel.text = "Swipe to send"
        swipeLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.ultraLight)
        swipeLabel.frame = CGRect(x: view.frame.size.width*0.3, y: view.frame.size.height - backgroundSwipe.frame.size.height, width: backgroundSwipe.frame.size.width - view.frame.size.width*0.25, height: backgroundSwipe.frame.size.height)
        view.addSubview(swipeLabel)
        
    }
    
    func isUnlocked() {
        print("unlocked")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
