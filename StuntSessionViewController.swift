//
//  StuntSessionViewController.swift
//  core_motion_starter_kit
//
//  Created by Andy Feng on 2/9/17.
//  Copyright © 2017 Andy Feng. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import CoreAudio
import SwiftyJSON

class StuntSessionViewController: UIViewController, CLLocationManagerDelegate {
    weak var HomeDelegate: HomeDelegate?
    
    @IBOutlet weak var angle: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var mph: UILabel!
    @IBOutlet weak var stunt_type_outlet: UILabel!

    @IBOutlet weak var avgspeedoutlet: UILabel!
    @IBOutlet weak var avgangleoutlet: UILabel!
    @IBOutlet weak var totalangleoutlet: UILabel!
    @IBOutlet weak var totaltimeoutlet: UILabel!
    @IBOutlet weak var totaldistanceoutlet: UILabel!
    @IBOutlet weak var stunttypeoutlet: UILabel!
    @IBOutlet weak var datetimeoutlet: UILabel!
    var jsonfullreturn: JSON = []
    
    var motionManager: CMMotionManager?
    var locationManager: CLLocationManager?
    var locations: [Any] = []
    var current_wheelie_angle: Double? = nil
    var current_stoppie_angle: Double? = nil
    var current_left_lean_angle: Double? = nil
    var current_right_lean_angle: Double? = nil
    var stunting_speed: Bool = false
    var current_speed: Double = 0.0
    var avg_speed_arr: [Double] = []
    var avg_speed: Double = 0.0
    var avg_angle_arr: [Double] = []
    var avg_angle: Double = 0.0
    var total_angle: Double? = 0.0
    var total_time: Double = 0.0
    var total_distance: Double? = 0.0
    var stunt_type: String = "none"
    var stunt_timer: Timer? = nil {willSet {stunt_timer?.invalidate()}}
    var avg_speed_sum: Double = 0.0
    var avg_angle_sum: Double = 0.0
    var current_angle: Double = 0.0
    var current_pitch: Double = 0.0
    var temp_pos_pitch_offset: Double = 0.0
    var temp_neg_pitch_offset: Double = 0.0
    var angle_score: Double = 0.0
    var speed_score: Double = 0.0
    var total_score: Double = 0.0
    
    
    @IBAction func homebutton(_ sender: UIButton) {
        StopSession(sender)
        HomeDelegate?.home()
    }
    
    ///startsession
    @IBAction func StartSession(_ sender: UIButton) {
        StartTracking()
        print("tracking line 70")
    }
    
    ///starttracking
    func StartTracking(){
        /// ------------anglelevel
        if self.current_pitch > 0.0 {
            self.temp_pos_pitch_offset = self.current_pitch
            self.temp_neg_pitch_offset = 0.0
        }
        else if self.current_pitch < 0.0 {
            self.temp_neg_pitch_offset = self.current_pitch
            self.temp_pos_pitch_offset = 0.0
        }
        stunt_timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (Timer) in
            if self.stunting_speed == true && (self.current_wheelie_angle != nil || self.current_stoppie_angle != nil || self.current_left_lean_angle != nil || self.current_right_lean_angle != nil) {
                if (self.current_wheelie_angle != nil){
                    self.avg_angle_arr.append(self.current_wheelie_angle!)
                    self.stunt_type = "wheelie"
                    if self.total_angle! < self.current_wheelie_angle! {
                        self.total_angle! = self.current_wheelie_angle!
                    }
                }
                else if (self.current_stoppie_angle != nil){
                    self.avg_angle_arr.append(self.current_stoppie_angle!)
                    self.stunt_type = "stoppie"
                    if self.total_angle! < self.current_stoppie_angle! {
                        self.total_angle! = self.current_stoppie_angle!
                    }
                }
                else if (self.current_left_lean_angle != nil){
                    self.avg_angle_arr.append(self.current_left_lean_angle!)
                    self.stunt_type = "left lean"
                    if self.total_angle! < self.current_left_lean_angle! {
                        self.total_angle! = self.current_left_lean_angle!
                    }
                }
                else if (self.current_right_lean_angle != nil){
                    self.avg_angle_arr.append(self.current_right_lean_angle!)
                    self.stunt_type = "right lean"
                    if self.total_angle! < self.current_right_lean_angle! {
                        self.total_angle! = self.current_right_lean_angle!
                    }
                }
                self.total_time += 0.2
                self.time.text = "\(String(self.total_time)) seconds"
                self.avg_speed_arr.append(self.current_speed)
                for i in 0 ..< self.avg_speed_arr.count {self.avg_speed_sum += self.avg_speed_arr[i]}
                self.avg_speed = self.avg_speed_sum / Double(self.avg_speed_arr.count)
                self.total_distance! = round((self.avg_speed * (self.total_time * 0.000277778)) * 5280) ///feet
                self.distance.text! = " \(String(self.total_distance!)) feet"
                self.avg_angle_sum = self.avg_angle
                for j in 0 ..< self.avg_angle_arr.count {self.avg_angle_sum += self.avg_angle_arr[j]}
                self.avg_angle = self.avg_angle_sum/Double(self.avg_angle_arr.count)
                self.stunt_type_outlet.text = "\(self.stunt_type)"
                
                
                
                self.avgspeedoutlet.text = "\(round(self.avg_speed)) MPH"
                self.avgangleoutlet.text = "\(round(self.avg_angle))°"
                self.totalangleoutlet.text = "\(round(self.total_angle!))°"
                self.totaltimeoutlet.text = "^^^"
                self.totaldistanceoutlet.text = "^^^"
                self.stunttypeoutlet.text = "^^^"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy h:mm a"
                self.datetimeoutlet.text = formatter.string(from: Date())
                
                
            }
            else if self.total_angle! > 0.0 {
                print("hit the save area line 141")
                ///noramlize and score angle --- if its a neg angle make sure to convert it upon placement
               
                func topwheelieORlean(avg_angle: Double, avg_speed: Double) -> Double {
                    if avg_angle >= 20 && avg_angle <= 27{
                        self.angle_score = 1.5
                    }
                    else if avg_angle > 27 && avg_angle <= 34{
                        self.angle_score = 2.5
                    }
                    else if avg_angle > 34 && avg_angle <= 41{
                        self.angle_score = 3.5
                    }
                    else if avg_angle > 41 && avg_angle <= 48{
                        self.angle_score = 4.5
                    }
                    else if avg_angle > 48 && avg_angle <= 55{
                        self.angle_score = 5.5
                    }
                    else if avg_angle > 55 && avg_angle <= 62{
                        self.angle_score = 6.5
                    }
                    else if avg_angle > 62 && avg_angle <= 69{
                        self.angle_score = 7.5
                    }
                    else if avg_angle > 69 && avg_angle <= 76{
                        self.angle_score = 8.5
                    }
                    else if avg_angle > 76 && avg_angle <= 83{
                        self.angle_score = 9.5
                    }
                    else if avg_angle > 83 && avg_angle <= 90{
                        self.angle_score = 10.5
                    }
                    else if avg_speed > 8 && avg_speed <= 14{
                        self.speed_score = 1.0
                    }
                    else if avg_speed > 14 && avg_speed <= 20{
                        self.speed_score = 2.0
                    }
                    else if avg_speed > 20 && avg_speed <= 26{
                        self.speed_score = 3.0
                    }
                    else if avg_speed > 26 && avg_speed <= 32{
                        self.speed_score = 4.0
                    }
                    else if avg_speed > 32 && avg_speed <= 38{
                        self.speed_score = 5.0
                    }
                    else if avg_speed > 38 && avg_speed <= 44{
                        self.speed_score = 6.0
                    }
                    else if avg_speed > 44 && avg_speed <= 50{
                        self.speed_score = 7.0
                    }
                    else if avg_speed > 50 && avg_speed <= 56{
                        self.speed_score = 8.0
                    }
                    else if avg_speed > 56 && avg_speed <= 62{
                        self.speed_score = 9.0
                    }
                    else if avg_speed > 62 && avg_speed <= 68{
                        self.speed_score = 10.0
                    }
                    let total_score = (self.angle_score + self.speed_score) / 2
                    return total_score
                }
                
                if self.avg_angle < 0 {
                    self.total_score = topwheelieORlean(avg_angle: -self.avg_angle, avg_speed: self.avg_speed)
                }
                else if self.avg_angle > 0 {
                    self.total_score = topwheelieORlean(avg_angle: self.avg_angle, avg_speed: self.avg_speed)
                }
                
                //********-----SAVE THESE VARIABLES AND PUSH TO API DATABASE BEFORE RESETTING THEM -----------***********//
                print(UserDefaults.standard.string(forKey: "username")!)
                
                StuntModel.post_stunt_to_db(avg_speed: round(self.avg_speed), avg_angle: round(self.avg_angle), total_angle: round(self.total_angle!), total_time: self.total_time, total_distance: self.total_distance!, stunt_type: self.stunt_type, total_score: round(self.total_score), screen_recording_url: "http://34.208.36.102/screen_recording_url/\(UserDefaults.standard.string(forKey: "username")!)/\(Date())", video_url: "http://34.208.36.102/video_url/\(UserDefaults.standard.string(forKey: "username")!)/\(Date())")

                /// amazon aws videos should be folder name video_url & screen_recording_url and file named username/datetime
                
                //********-----SAVE THESE VARIABLES AND PUSH TO API DATABASE BEFORE RESETTING THEM  ^^^^^^----***********//
                
                StuntModel.get_all_stunts(completionHandler: self.complete)
                
                self.avg_speed_arr = []
                self.avg_speed = 0.0
                self.avg_speed_sum = 0.0
                self.avg_angle_sum = 0.0
                self.avg_angle_arr = []
                self.avg_angle = 0.0
                self.total_angle = 0.0
                self.total_time = 0.0
                self.total_distance = 0.0
                self.time.text = String(0.0)
                self.distance.text = String(0.0)
                self.stunt_type = "none"
                self.current_wheelie_angle = nil
                self.current_stoppie_angle = nil
                self.current_left_lean_angle = nil
                self.current_right_lean_angle = nil
                self.stunting_speed = false
                self.total_score = 0.0
                self.speed_score = 0.0
                self.angle_score = 0.0
            }
            else {
                self.avg_speed_arr = []
                self.avg_speed = 0.0
                self.avg_speed_sum = 0.0
                self.avg_angle_sum = 0.0
                self.avg_angle_arr = []
                self.avg_angle = 0.0
                self.total_angle = 0.0
                self.total_time = 0.0
                self.total_distance = 0.0
                self.time.text = String(0.0)
                self.distance.text = String(0.0)
                self.stunt_type = "none"
                self.stunt_type_outlet.text = "\(self.stunt_type)"
                self.current_wheelie_angle = nil
                self.current_stoppie_angle = nil
                self.current_left_lean_angle = nil
                self.current_right_lean_angle = nil
                self.stunting_speed = false
                self.total_score = 0.0
                self.speed_score = 0.0
                self.angle_score = 0.0
            }
        })
    }
    
    /// endsession
    @IBAction func StopSession(_ sender: UIButton) {
        StuntModel.get_all_stunts(completionHandler: complete)

        self.stunt_timer = nil
        self.avg_speed_arr = []
        self.avg_speed_sum = 0.0
        self.avg_angle_sum = 0.0
        self.avg_speed = 0.0
        self.avg_angle_arr = []
        self.avg_angle = 0.0
        self.total_angle = 0.0
        self.total_time = 0.0
        self.total_distance = 0.0
        self.total_score = 0.0
        self.speed_score = 0.0
        self.angle_score = 0.0
        self.time.text = "\(String(0.0)) seconds"
        self.distance.text = "\(String(0.0)) feet"
        self.stunt_type = "none"
        self.stunt_type_outlet.text = "\(self.stunt_type)"
    }
    
    
    
    /// completion handler stuntsession
    func complete(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
        print ("***** hit completion handler stunt session")
        self.jsonfullreturn = JSON(data: data!)
        print(jsonfullreturn)
        var i = self.jsonfullreturn.count
        print(i)
        while i > 0 {
            print (i)
            print (((self.jsonfullreturn[i])["_user"])["username"])
            print (UserDefaults.standard.string(forKey: "username")!)
            if ((self.jsonfullreturn[i])["_user"])["username"].rawString() == UserDefaults.standard.string(forKey: "username")! {
                print("true")
                self.avgspeedoutlet.text = "\((self.jsonfullreturn[i])["avg_speed"]) MPH"
                self.avgangleoutlet.text = "\((self.jsonfullreturn[i])["avg_angle"])°"
                self.totalangleoutlet.text = "\((self.jsonfullreturn[i])["total_angle"])°"
                self.totaltimeoutlet.text = "\((self.jsonfullreturn[i])["total_time"]) Seconds"
                self.totaldistanceoutlet.text = "\((self.jsonfullreturn[i])["total_distance"]) Feet"
                self.stunttypeoutlet.text = (self.jsonfullreturn[i])["stunt_type"].rawString()
                let dateString = (self.jsonfullreturn[i])["createdAt"].rawString()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZ"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                let dateObj = dateFormatter.date(from: dateString!)
                dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
                self.datetimeoutlet.text = dateFormatter.string(from: dateObj!)
                print((self.jsonfullreturn[i])["avg_speed"])
            }
        i = i - 1
        print("\(i) is i")
        }
    }

    
    
    
    
    
    // UI Lifecycle ::::::::::::::::::::::::::::::::::::::::::
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        /// location
        locationManager = CLLocationManager()
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            self.locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.delegate = self
        if let locationmanager = locationManager {
            print("We have location manager")
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (Timer) in
                self.locationManager_func(manager: locationmanager, didUpdateLocations: self.locations as [AnyObject])
            })
        }
        else {
            print ("no location manager")
        }
        /// motion
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have a motion manager")
            detectMotion(manager: manager)
            
        }
        else {
            print("No manager")
        }
        StuntModel.get_all_stunts(completionHandler: complete)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    //// angle stuff
    func detectMotion(manager: CMMotionManager) {
        if !manager.isDeviceMotionAvailable {
            // This will print if running on simulator
            print("We cannot detect device motion using the simulator")
        }
        else {
            // This will print if running on iPhone
            print("We can detect device motion")
            // Make a custom queue in order to stay off the main queue
            let myq = OperationQueue()
            // Customize the update interval (seconds)
            manager.deviceMotionUpdateInterval = 0.2
            // Now we can start our updates, send it to our custom queue, and define a completion handler
            manager.startDeviceMotionUpdates(to: myq, withHandler: { (motionData: CMDeviceMotion?, error: Error?) in
                if let data = motionData {
                    // We access motion data via the "attitude" property
                    let attitude = data.attitude
//                    print("pitch: \(attitude.pitch) ----- roll: \(attitude.roll) ----- yaw: \(attitude.yaw)")
                    OperationQueue.main.addOperation {
                        
                        ///want an already adjusted pitch and roll
                        self.current_pitch = attitude.pitch * 180.0 / .pi
                        
                        if ((attitude.pitch * 180.0 / .pi) - self.temp_pos_pitch_offset) > 20 {
                            self.current_wheelie_angle = ((attitude.pitch * 180.0 / .pi) - self.temp_pos_pitch_offset)
                            self.current_right_lean_angle = nil
                            self.current_left_lean_angle = nil
                            self.current_stoppie_angle = nil
                            self.current_angle = ((attitude.pitch * 180.0 / .pi) - self.temp_pos_pitch_offset)
                            self.current_wheelie_angle = self.current_angle
                            self.angle.text = "\(round(self.current_angle))°"
                        }
                        else if ((attitude.pitch * 180.0 / .pi) - self.temp_neg_pitch_offset) < -10 {
                            self.current_right_lean_angle = nil
                            self.current_left_lean_angle = nil
                            self.current_wheelie_angle = nil
                            self.current_angle =  ((attitude.pitch * 180.0 / .pi) - self.temp_neg_pitch_offset)
                            self.current_stoppie_angle = self.current_angle
                            self.angle.text = "\(round(self.current_angle))°"
                        }
                        else if (attitude.roll * 180.0 / .pi) < -15 {
                            self.current_left_lean_angle = attitude.roll * 180.0 / .pi
                            self.current_right_lean_angle = nil
                            self.current_wheelie_angle = nil
                            self.current_stoppie_angle = nil
                            self.angle.text = "\(round(attitude.roll * 180.0 / .pi))°"
                            self.current_angle = attitude.roll * 180.0 / .pi
                        }
                        else if (attitude.roll * 180.0 / .pi) > 15 {
                            self.current_right_lean_angle = attitude.roll * 180.0 / .pi
                            self.current_left_lean_angle = nil
                            self.current_wheelie_angle = nil
                            self.current_stoppie_angle = nil
                            self.angle.text = "\(round(attitude.roll * 180.0 / .pi))°"
                            self.current_angle = attitude.roll * 180.0 / .pi
                        }
                        else {
                            self.current_right_lean_angle = nil
                            self.current_left_lean_angle = nil
                            self.current_wheelie_angle = nil
                            self.current_stoppie_angle = nil
                            if (attitude.roll  * 180.0 / .pi) > ((attitude.pitch  * 180.0 / .pi) - self.temp_pos_pitch_offset) {
                                self.angle.text = "\(round(attitude.roll * 180.0 / .pi))°"
                                self.current_angle = attitude.roll * 180.0 / .pi
                            }
                            else if (-attitude.roll * 180.0 / .pi) > ((attitude.pitch  * 180.0 / .pi) - self.temp_pos_pitch_offset) {
                                //left lean
                                self.angle.text = "\(round(attitude.roll * 180.0 / .pi))°"
                                self.current_angle = -(attitude.roll * 180.0 / .pi)

                            }
                            else {
                                self.angle.text = "\(round(attitude.pitch * 180.0 / .pi))°"
                                self.current_angle = (attitude.pitch * 180.0 / .pi) - self.temp_neg_pitch_offset
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    //// location stuff
    func locationManager_func(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var speed: CLLocationSpeed = CLLocationSpeed()
        manager.activityType = CLActivityType.otherNavigation
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()
        speed = (manager.location?.speed)!
//        print(speed)
        //mph is meters per sec to mph        meters/sec * 2.27272727273
        self.mph.text = "\(String(round(1000 * (speed * 2.27272727273)) / 1000)) mph"
        self.current_speed = speed * 2.27272727273 ///mph unrounded
        if (speed * 2.27272727273) > 0.1 { ///set low to test
            self.stunting_speed = true
        }
        else if (speed * 2.27272727273) <= 0.1 { ///set low to test
            self.stunting_speed = false
        }
        
    }
}
