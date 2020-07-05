//
//  HospitalTableViewController.swift
//  emerge-van-niranjan
//
//  Created by Niranjan on 6/24/20.
//  Copyright © 2020 NiranjanVaswani. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import CoreLocation

class HospitalTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var currentLocation: [Double] = [1,2]
    var bookings: NSDictionary = [:]
    struct Objects{
        var Name : Any = ""
        var Time: Any = ""
    }
    var travelTimeArray = [Any]()
    var objectArray = [Objects]()
    
    func getUserLocation(){
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
         }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
    
        let waitTimeTask = URLSession.shared.dataTask(with: URL(string :"https://helloworld-6dcqnh4gka-uw.a.run.app")!) { data,response ,error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let myDict = json as? NSDictionary{
                    for (key, value) in myDict {
                        print("\(key) -> \(value)")
                        if let time = value as? String{
                            self.objectArray.append(Objects(Name: key, Time: time))
                }}}}
            catch {
                print("JSON error: \(error.localizedDescription)")
                }}
        for var (object) in self.objectArray{
        
        if var waitTime = object.Time as? String {
            waitTime = waitTime.trimmingCharacters(in: .whitespacesAndNewlines)
            if let hours = Int(waitTime.prefix(2)){
                if let minutes = Int(waitTime.suffix(2)){
                    object.Time = hours*60 + minutes}}
            
            
            }}
        
        waitTimeTask.resume()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        if (self.currentLocation[0] != locations.last?.coordinate.latitude) && (self.currentLocation[1] != locations.last?.coordinate.longitude){
            
            self.currentLocation[0] = (locations.last?.coordinate.latitude)! as Double
            
            self.currentLocation[1] = (locations.last?.coordinate.longitude)! as Double
            
            let locationString = String(currentLocation[1]) + "," + String(currentLocation[0])
            
            let url = "https://api.mapbox.com/directions-matrix/v1/mapbox/driving-traffic/" + locationString + ";-123.1245,49.2622;-123.127930,49.281435;-123.146935,49.16873;-123.068991,49.320956;-123.095800,49.258308;-123.245415,49.264181;-123.129116,49.277396;-123.083663,49.312363?sources=0&destinations=1;2;3;4;5;6;7;8?&access_token=pk.eyJ1IjoibmFqbmFyaW52IiwiYSI6ImNrYzc0emt4cjBqeDgyd3Fwc2VteW1zazUifQ.Y_nh339cT90-LW4anOowbQ"
            
            let travelTimeTask = URLSession.shared.dataTask(with: URL(string:(url))!){data, response, error in do {
            
            let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let jsonDict=json as? NSDictionary{
                    if let array = jsonDict["durations"] as? [Array<Any>]{
                        
                        
                        for i in array{
                            for j in i{
                                self.travelTimeArray.append(j)
                            }
                    
                            
                        }
        
                    }
                }            }
            catch{
                 print("JSON error: \(error.localizedDescription)")
            }
            }
            
            travelTimeTask.resume()
            
        }}
        
        

            
            
        
        

    

   
}


        
    
        
        

    
    

    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


