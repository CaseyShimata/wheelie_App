//
//  RecentStuntsTableViewController.swift
//  Stunt
//
//  Created by Casey Shimata on 4/18/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import UIKit
import SwiftyJSON


class RecentStuntsTableViewController: UITableViewController {
    var uicolor = [UIColor.yellow, UIColor.green]
    var temp = 1

    var jsonfullreturn: JSON = []
    var CellDataArr: [CellData] = []
    
    @IBAction func logout_action(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set("none", forKey: "username")
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        viewDidAppear(true)
    }

        override func viewDidLoad() {
        StuntModel.get_all_stunts(completionHandler: complete)
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if !isUserLoggedIn {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    
    
///will convert db json string into separated items matching the needed var type casting so they can be used in the app how the were put in/Users/shimatacb/Desktop/Stunt_copy/Images.xcassets
    func complete(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
        print ("***** hit completion handler recent stunts")
        
        print(data ?? "data is nil!!!!!!!!!!!")
        // breaking here
        self.jsonfullreturn = JSON(data: data!)
        print (self.jsonfullreturn[0]["createdAt"])

        
        for i in 0 ..< self.jsonfullreturn.count{
            let username = (((self.jsonfullreturn[i])["_user"])["username"]).rawString()
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
            print ("\(newCellData) ---- for loop line 55 completion handler")
            self.CellDataArr.append(newCellData)
        }
        print ("\(self.CellDataArr) ---- final CellDataArr instance created using type/class CellData in stunts_users.swift")

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

///table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return self.json.count
        return self.CellDataArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "all_stunts_proto", for: indexPath) as! AllStuntsTableViewCell
        //model is from the cell controller
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
