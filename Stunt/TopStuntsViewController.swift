//
//  TopStuntsViewController.swift
//  Stunt
//
//  Created by Casey Shimata on 4/18/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import UIKit
import SwiftyJSON

class TopStuntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var jsonfullreturn: JSON = []
    var WheelieDataArr: [CellData] = []
    var LeanDataArr: [CellData] = []
    var uicolor = [UIColor.blue, UIColor.yellow]
    var temp = 1
    @IBOutlet weak var topwheeliestable: UITableView!
    @IBOutlet weak var topleanstable: UITableView!
    var cell: topwheeliesTableViewCell?
    var cell1: topleansTableViewCell?
    
    
    ///completion handler
    func complete(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
        print ("***** hit completion handler top stunts")
        self.jsonfullreturn = JSON(data: data!)
        var i = self.jsonfullreturn.count
        while i > 0 {
            if ((self.jsonfullreturn[i])["stunt_type"]).rawString() == "wheelie" {
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
                self.WheelieDataArr.append(newCellData)
            }
            else if ((self.jsonfullreturn[i])["stunt_type"]).rawString() == "left lean" || ((self.jsonfullreturn[i])["stunt_type"]).rawString() == "right lean" {
                
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
                
                let newCellData2 = CellData(username: username!, avg_speed: avg_speed as! Double, avg_angle: avg_angle as! Double, total_angle: total_angle as! Double, total_time: total_time as! Double, total_distance: total_distance as! Double, stunt_type: stunt_type!, total_score: total_score as? Double, video_url: video_url!, createdAt: createdAt)
                self.LeanDataArr.append(newCellData2)
            }
        i -= 1
        }
        DispatchQueue.main.async {
            self.topwheeliestable.reloadData()
            self.topleanstable.reloadData()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        StuntModel.get_all_stunts(completionHandler: complete)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.topwheeliestable {
            self.cell = tableView.dequeueReusableCell(withIdentifier: "top_five_wheelie_proto", for: indexPath) as? topwheeliesTableViewCell
            cell?.layer.borderWidth = 2.5
            if self.temp == self.uicolor.count - 1 {
                self.temp = 0
                cell?.backgroundColor = uicolor[self.temp]
            }
            else{
                self.temp += 1
                cell?.backgroundColor = uicolor[self.temp]
            }
            cell?.model = self.WheelieDataArr.sorted{$1.total_score! < $0.total_score! }[indexPath.row]
            return cell!
        }
        if tableView == self.topwheeliestable {
            self.cell1 = tableView.dequeueReusableCell(withIdentifier: "top_five_lean_proto", for: indexPath) as? topleansTableViewCell
            cell1?.layer.borderWidth = 2.5
            if self.temp == self.uicolor.count - 1 {
                self.temp = 0
                cell1?.backgroundColor = uicolor[self.temp]
            }
            else{
                self.temp += 1
                cell1?.backgroundColor = uicolor[self.temp]
            }
            cell1?.model = self.LeanDataArr.sorted{$1.total_score! < $0.total_score! }[indexPath.row]
            return cell1!

        }
        return self.cell1!
    }
}
