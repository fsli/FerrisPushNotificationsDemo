//
//  ViewController.swift
//  FerrisPushNotificationsDemo
//
//  Created by Ferris Li on 3/25/16.
//  Copyright © 2016 Ferris Li. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class ViewController: UIViewController {
    @IBOutlet weak var textUserId: UITextField!
    
    @IBOutlet weak var textDeviceToken: UITextField!
    
    @IBOutlet weak var tvOutput: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.onDeviceTokenLoaded), name: "deviceTokenLoadedNotification", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func resetBadgeNumber(sender: AnyObject) {
        //self.sharedApp setApplicationIconBadgeNumber:0];
        let sharedApp:UIApplication = UIApplication.sharedApplication()
        sharedApp.applicationIconBadgeNumber = 0
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onDeviceTokenLoaded(notification: NSNotification) {
        self.textDeviceToken.text = notification.object as? String
    }
    
    @IBAction func onSaveTouchUpInside(sender: AnyObject) {
        if (self.textUserId.text == "") {
           self.tvOutput.text = self.tvOutput.text + "\nError: User ID is required"
            return
        }
        if (self.textDeviceToken.text == "") {
            self.tvOutput.text = self.tvOutput.text + "\nError: Device token  is required"
            
        }
        let url:String = HttpRestApiHelper.getDevicesUrl();
        let userId:String = self.textUserId.text!
        let deviceToken:String = self.textDeviceToken.text!
        let nsPostdata : NSDictionary = ["user_id": userId, "device_token": deviceToken]
        HttpRestApiHelper.post(url, postdata: nsPostdata) {(result: NSObject!) in
            if let data = result as? NSDictionary {
                let responseContent:String = "\(data)"
                dispatch_async(dispatch_get_main_queue(), {
                    self.tvOutput.text = responseContent
                    
                })
            }
        }
    }

}

