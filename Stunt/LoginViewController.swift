//
//  LoginViewController.swift
//  Stunt
//
//  Created by Casey Shimata on 4/18/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController{
    @IBOutlet weak var username_outlet: UITextField!
    @IBOutlet weak var reg_username_outlet: UITextField!
    @IBOutlet weak var reg_passwordconf_outlet: UITextField!
    @IBOutlet weak var reg_password_outlet: UITextField!
    @IBOutlet weak var password_outlet: UITextField!
    var jsonfullreturn: JSON = []
    var agreed = false
    
    
    ///binding agreement
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///alert func
    func alertfunc(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    ///reg
    @IBAction func register_action(_ sender: UIButton) {
        if (reg_username_outlet.text?.isEmpty)! || (reg_password_outlet.text?.isEmpty)! || (reg_passwordconf_outlet.text?.isEmpty)! {
            alertfunc(message: "all fields must be completed", title: "Empty Fields")
            return
        }
        if reg_password_outlet.text != reg_passwordconf_outlet.text {
            alertfunc(message: "password must match password confirmation", title: "error")
            return
        }
        if self.agreed == false {
            func bindingagreement() {
                let alertController = UIAlertController(title: "BINDING USER AGREEMENT", message: "In consideration for your participation of WHEELIE APP, the individual does hereby release and forever discharge the team CASEY SHIMATA, and the team’s board and employees, jointly and severally from any and all actions, causes of actions, claims and demands for, upon or by reason of any damage, loss or injury, which hereafter may be sustained by the participation of WHEELIE APP. This release extends and applies to, and also covers and includes, all unknown, unforeseen, unanticipated and unsuspected injuries, damages, loss and liability and the consequences thereof, as well as those now disclosed and known to exist. The provisions of any state, federal, local or territorial law or state providing substance that releases shall not extend to claims, demands, injuries, or damages which are known or unsuspected to exist at this time, to the person executing such release, are hereby expressly waived. I hereby agree on behalf of my heirs, executors, administrators, and assigns, to indemnify the team CASEY SHIMATA and the team’s board and employees, joint and severally from any and all actions, causes of actions, claims and demands for, upon or by reason of any damage, loss or injury, which hereafter may be sustained by the participation of WHEELIE APP. It is my responsibility to provide, and wear, the appropriate safety gear while operating my motor vehicle while participating on WHEELIE APP. Participation of WHEELIE APP should never be attempted on public roadways. It is further understood and agreed that said participation of WHEELIE APP is not to be construed as an admission of any liability and acceptance of assumption of responsibility by the team CASEY SHIMATA, the team’s board and employees, jointly and severally, for all damages and expenses for which the team CASEY SHIMATA, the team and its board and employees, become liable as a result of any alleged act of the parade participant.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Agree", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            bindingagreement()
            self.agreed = true

            return
        }
        else {
            ////----hash vars
            let password = self.reg_password_outlet.text
            let salt         = Data(bytes: [0x73, 0x61, 0x6c, 0x74, 0x44, 0x61, 0x74, 0x61])
            let keyByteCount = 16
            let rounds       = 100000
            ////hash func -----
            func pbkdf2SHA256(password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
               print("hash func")
                return pbkdf2(hash:CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password:password, salt:salt, keyByteCount:keyByteCount, rounds:rounds)
            }
            //// ------ inner hash func
            func pbkdf2(hash :CCPBKDFAlgorithm, password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
                print ("inner hash func")
                let passwordData = password.data(using:String.Encoding.utf8)!
                var derivedKeyData = Data(repeating:0, count:keyByteCount)
                let derivationStatus = derivedKeyData.withUnsafeMutableBytes {derivedKeyBytes in
                    salt.withUnsafeBytes { saltBytes in
                        CCKeyDerivationPBKDF(
                            CCPBKDFAlgorithm(kCCPBKDF2),
                            password, passwordData.count,
                            saltBytes, salt.count,
                            hash,
                            UInt32(rounds),
                            derivedKeyBytes, derivedKeyData.count)
                    }
                }
                if (derivationStatus != 0) {
                    print("Error: \(derivationStatus)")
                    return nil;
                }
                else {
                    print ("\(derivedKeyData)   ***** derivef key blah")
                    return derivedKeyData
                }
            }
            ///---------- running the hash pass func 
            let hashed_pass = pbkdf2SHA256(password: password!, salt: salt, keyByteCount: keyByteCount, rounds: rounds)! as NSData
            print (hashed_pass)
            
            /// ----- completion
            func complete(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
                print ("***** hit completion handler login reg")
                self.jsonfullreturn = JSON(data: data!)
                print ("\(self.jsonfullreturn) ****** completion handler reg")
                
                /// >>> good we created the user
                if self.jsonfullreturn["username"].rawString() == "null"{
                    alertfunc(message: "username already exists try again yo!", title: "USERNAME EXISTS")
                    return
                }
                /// else bad the user exists on the reg route if  !data is false meaning the data exists
                else {
                    print ("\(String(describing: self.jsonfullreturn["username"].rawString())) db user name *******")
                    print (reg_username_outlet.text!)
                    UserDefaults.standard.set(self.reg_username_outlet.text, forKey: "username")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion:nil)
                }
            }
            StuntModel.register(username: self.reg_username_outlet.text!, password: hashed_pass as Data, picture_url: "http://34.208.36.102/\(self.reg_username_outlet.text!)", motorcycle_decible: 0.0, completionHandler: complete)
        }
    }
    
    //login
    @IBAction func login_action(_ sender: UIButton) {
        if (username_outlet.text?.isEmpty)! || (password_outlet.text?.isEmpty)! {
            alertfunc(message: "all fields must be completed", title: "Empty Fields")
            return
        }
        else {
            /// ----- re hash compare vars
            let password = self.password_outlet.text
            let salt         = Data(bytes: [0x73, 0x61, 0x6c, 0x74, 0x44, 0x61, 0x74, 0x61])
            let keyByteCount = 16
            let rounds       = 100000
            ///// ------re hash compare func
            func pbkdf2SHA256(password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
                return pbkdf2(hash:CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password:password, salt:salt, keyByteCount:keyByteCount, rounds:rounds)
            }
            //// ------ re hash compare support func
            func pbkdf2(hash :CCPBKDFAlgorithm, password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
                let passwordData = password.data(using:String.Encoding.utf8)!
                var derivedKeyData = Data(repeating:0, count:keyByteCount)
                let derivationStatus = derivedKeyData.withUnsafeMutableBytes {derivedKeyBytes in
                    salt.withUnsafeBytes { saltBytes in
                        CCKeyDerivationPBKDF(
                            CCPBKDFAlgorithm(kCCPBKDF2),
                            password, passwordData.count,
                            saltBytes, salt.count,
                            hash,
                            UInt32(rounds),
                            derivedKeyBytes, derivedKeyData.count)
                    }
                }
                if (derivationStatus != 0) {
                    print("Error: \(derivationStatus)")
                    return nil;
                }
                else {
                    return derivedKeyData
                }
            }
            ///---------- running the re hash compare func
            let hashed_pass = pbkdf2SHA256(password: password!, salt: salt, keyByteCount: keyByteCount, rounds: rounds)! as NSData
            print (hashed_pass)
            //// --------- completion func
            func complete(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
                print ("***** hit completion handler login reg")
                self.jsonfullreturn = JSON(data: data!)
                print ("\(self.jsonfullreturn) ****** completion handler login")
                
                ///>> we got a user back from the db after checking the pass compare on the db
                if self.jsonfullreturn["username"].rawString() != nil {
                    UserDefaults.standard.set(self.username_outlet.text, forKey: "username")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion:nil)
                }
            }
            
            StuntModel.login(username: self.username_outlet.text!, password: hashed_pass as Data, completionHandler: complete)
        }
    }
}
