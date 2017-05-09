//
//  StuntModel.swift
//  BucketListCRUD
//
//  Created by Andy Feng on 4/18/17.
//  Copyright © 2017 Andy Feng. All rights reserved.
//  http://34.208.36.102 my api url

import Foundation
class StuntModel {
    
    static func get_all_stunts(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://192.168.1.56:8000/stunts/all")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
    static func post_stunt_to_db(_user: String, avg_speed: Double, avg_angle: Double, total_angle: Double, total_time: Double, total_distance: Double, stunt_type: String, screen_recording_url: String, video_url: String) -> Void {
        // Create the url to request
        print ("trying to connect to api")
        if let urlToReq = URL(string: "http://192.168.1.56:8000/stunts/newstunt") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            print ("connected to api")
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            let bodyData = "avg_speed=\(avg_speed)&avg_angle=\(avg_angle)&total_angle=\(total_angle)&total_time=\(total_time)&total_distance=\(total_distance)&stunt_type=\(stunt_type)&screen_recording_url=\(screen_recording_url)&video_url=\(video_url)"
            request.httpBody = bodyData.data(using: .utf8)
            //  Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest)
            task.resume()
        }
    }
    static func register(username: String, password: String, picture_url: String, motorcycle_decible: Double) -> Void {
        // Create the url to request
        print ("trying to connect to api")
        if let urlToReq = URL(string: "http://192.168.1.56:8000/users/register") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            print ("connected to api")
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            let bodyData = "username=\(username)&password=\(password)&picture_url=\(picture_url)&motorcycle_decible=\(motorcycle_decible)"
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest)
            task.resume()
        }
    }
    static func login(username: String, password: String, completionHandler: @escaping(_ response: URLResponse?)  -> Void) {
        // Create the url to request
        print ("trying to connect to api")
        if let urlToReq = URL(string: "http://192.168.1.56:8000/users/login") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            print ("connected to api")
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            let bodyData = "username=\(username)&password=\(password)"
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest)
            task.resume()
        }
    }


    
}
