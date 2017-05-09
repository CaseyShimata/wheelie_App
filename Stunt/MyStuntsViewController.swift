//
//  MyStuntsViewController.swift
//  Stunt
//
//  Created by Casey Shimata on 4/18/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyStuntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var jsonfullreturn: JSON = []
    var CellDataArr: [CellData] = []
    var uicolor = [UIColor.yellow, UIColor.green]
    var temp = 1
    var speed_score: Double = 0.0
    var angle_score: Double = 0.0
    @IBOutlet weak var mystuntsalltable: UITableView!
    
    @IBOutlet weak var topwheelie_datetime: UILabel!
    @IBOutlet weak var topwheelie_avgspeed: UILabel!
    @IBOutlet weak var topwheelie_avgangle: UILabel!
    @IBOutlet weak var topwheelie_totalangle: UILabel!
    @IBOutlet weak var topwheelie_totaldistance: UILabel!
    @IBOutlet weak var topwheelie_totaltime: UILabel!
    
    @IBOutlet weak var toplean_datetime: UILabel!
    @IBOutlet weak var toplean_avgspeed: UILabel!
    @IBOutlet weak var toplean_avgangle: UILabel!
    @IBOutlet weak var toplean_totalangle: UILabel!
    @IBOutlet weak var toplean_totaldistance: UILabel!
    @IBOutlet weak var toplean_totaltime: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        StuntModel.get_all_stunts(completionHandler: complete)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///completion handler
    func complete(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
        print ("***** hit completion handler MY stunts")
        self.jsonfullreturn = JSON(data: data!)
        print (self.jsonfullreturn["total_score"])
        var i = self.jsonfullreturn.count
        print(i)
        while i > 0 {
            print (i)
            print (((self.jsonfullreturn[i])["_user"])["username"])
            print (UserDefaults.standard.string(forKey: "username")!)
            if ((self.jsonfullreturn[i])["_user"])["username"].rawString() == UserDefaults.standard.string(forKey: "username")! {
                print("true")
                let username = ((self.jsonfullreturn[i])["_user"])["username"].rawString()
                let avg_speed = ((self.jsonfullreturn[i])["avg_speed"]).rawValue
                let avg_angle = ((self.jsonfullreturn[i])["avg_angle"]).rawValue
                let total_angle = ((self.jsonfullreturn[i])["total_angle"]).rawValue
                let total_time = ((self.jsonfullreturn[i])["total_time"]).rawValue
                let total_distance = ((self.jsonfullreturn[i])["total_distance"]).rawValue
                let stunt_type = ((self.jsonfullreturn[i])["stunt_type"]).rawString()
                let total_score = ((self.jsonfullreturn[i])["total_score"]).rawValue
                let video_url = ((self.jsonfullreturn[i])["video_url"]).rawString()
                
                let dateString = (self.jsonfullreturn[i])["createdAt"].rawString()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZ"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                let dateObj = dateFormatter.date(from: dateString!)
                dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
                let createdAt = dateFormatter.string(from: dateObj!)
                
                let newCellData = CellData(username: username!, avg_speed: avg_speed as! Double, avg_angle: avg_angle as! Double, total_angle: total_angle as! Double, total_time: total_time as! Double, total_distance: total_distance as! Double, stunt_type: stunt_type!, total_score: total_score as? Double, video_url: video_url!, createdAt: createdAt)
                print ("\(newCellData) ---- for loop line 55 mystunts completion handler")
                self.CellDataArr.append(newCellData)
                DispatchQueue.main.async {
                    let temp_i = i + 1
                    let temp_i_lean = i + 1
                    self.mystuntsalltable.reloadData()
                    if (self.jsonfullreturn[i])["stunt_type"].rawString() == "wheelie"{
                        print ("its a wheelie !!!! ****************")
                        /// best wheelie is avg angle over average speed -- gives us an idea of maintained lower faster and maintained slower higher -- best overall scoring
                        if let _ = self.jsonfullreturn[i]["total_score"].double {
                        }
                        else{
                            self.jsonfullreturn[i]["total_score"].double = 0.0
                        }
                        if let _ = self.jsonfullreturn[temp_i]["total_score"].double {
                        }
                        else{
                            self.jsonfullreturn[temp_i]["total_score"].double = 0.0
                        }
                        
                        print((self.jsonfullreturn[i])["total_score"].double ?? "not working")
                        print((self.jsonfullreturn[temp_i])["total_score"].double ?? "not working")
                        if (self.jsonfullreturn[i])["total_score"].double!  <= (self.jsonfullreturn[temp_i])["total_score"].double!{
                            print ("next wheelie is greater than current wheelie !!!!!!!############")
                            self.topwheelie_avgspeed.text = "\(String(describing: round((self.jsonfullreturn[temp_i])["avg_speed"].double!))) MPH"
                            self.topwheelie_avgangle.text = "\(String(describing: round((self.jsonfullreturn[temp_i])["avg_angle"].double!)))°"
                            self.topwheelie_totalangle.text = "\(String(describing: round((self.jsonfullreturn[temp_i])["total_angle"].double!)))°"
                            self.topwheelie_totaltime.text = "\(String(describing: round((self.jsonfullreturn[temp_i])["total_time"].double!))) Seconds"
                            self.topwheelie_totaldistance.text = "\(String(describing: round((self.jsonfullreturn[temp_i])["total_distance"].double!))) Feet"
                            let dateString = (self.jsonfullreturn[temp_i])["createdAt"].rawString()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZ"
                            dateFormatter.locale = Locale.init(identifier: "en_GB")
                            let dateObj = dateFormatter.date(from: dateString!)
                            dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
                            self.topwheelie_datetime.text = dateFormatter.string(from: dateObj!)
                        }
                    }
                    if (self.jsonfullreturn[i])["stunt_type"].rawString() == "right lean" || (self.jsonfullreturn[i])["stunt_type"].rawString() == "left lean"{
                        print ("its a right lean !!!! ****************")
                        if (self.jsonfullreturn[i])["total_score"].int! <= (self.jsonfullreturn[temp_i_lean])["total_score"].int! {
                            print ("next lean is more than current lean !!!!!!!############")
                            self.toplean_avgspeed.text = "\((self.jsonfullreturn[temp_i_lean])["avg_speed"]) MPH"
                            self.toplean_avgangle.text = "\((self.jsonfullreturn[temp_i_lean])["avg_angle"])°"
                            self.toplean_totalangle.text = "\((self.jsonfullreturn[temp_i_lean])["total_angle"])°"
                            self.toplean_totaltime.text = "\((self.jsonfullreturn[temp_i_lean])["total_time"]) Seconds"
                            self.toplean_totaldistance.text = "\((self.jsonfullreturn[temp_i_lean])["total_distance"]) Feet"
                            let dateString = (self.jsonfullreturn[temp_i_lean])["createdAt"].rawString()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZ"
                            dateFormatter.locale = Locale.init(identifier: "en_GB")
                            let dateObj = dateFormatter.date(from: dateString!)
                            dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
                            self.toplean_datetime.text = dateFormatter.string(from: dateObj!)
                        }
                    }
                }
            }
            i = i - 1
            print("\(i) is i")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CellDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my_stunts_proto", for: indexPath) as! MyStuntsTableViewCell
        cell.layer.borderWidth = 2.5
        if self.temp == self.uicolor.count - 1 {
            self.temp = 0
            cell.backgroundColor = uicolor[self.temp]
        }
        else{
            self.temp += 1
            cell.backgroundColor = uicolor[self.temp]
        }
        cell.model = self.CellDataArr.sorted{$1.createdAt! < $0.createdAt! }[indexPath.row]
        return cell
    }
    
    
}
