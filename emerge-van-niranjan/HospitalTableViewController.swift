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

class MyCell: UITableViewCell{

    @IBOutlet weak var HospitalName: UILabel!
    @IBOutlet weak var TravelTime: UILabel!
    @IBOutlet weak var WaitTime: UILabel!
    @IBOutlet weak var TotalTime: UILabel!
}
    
class HospitalTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    
    
    
    var locationManager: CLLocationManager?
    var currentLocation: [Double] = [1,2]
    var bookings: NSDictionary = [:]
    struct Object{
        var Name : Any = ""
        var Time: Any = ""
        var Travel: Any = ""
    }
    var travelTimeArray = [Any]()
    var objectArray = [Object]()
    
    func compileObjects(){
        print(objectArray)
    }
    
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
                        
                        if var waitTime = value as? String{
                            waitTime = waitTime.trimmingCharacters(in: .whitespacesAndNewlines)
                            if let hours = Int(waitTime.prefix(2)){
                                if let minutes = Int(waitTime.suffix(2)){
                                    
                                    let time = Int(hours*60 + minutes)
                                    
                                        self.objectArray.append(Object(Name: key, Time: time))
                                    

                                }}}}
                    
                    
                    DispatchQueue.main.async{
                        self.tableView.reloadData()}

                }}
            catch {
                print("JSON error: \(error.localizedDescription)")
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
                    if let array = jsonDict["durations"] as? [Any]{
                        if let times = array[0] as? [Double]{
                            for time in times{
                                self.travelTimeArray.append(Int(time))
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
    
    
    
        
        

            
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }
        
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "EstimateTableViewCell", for: indexPath) as! MyCell
            
            
            cell.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha:1)
            let a = objectArray.count > 0
            let b = travelTimeArray.count > 0
            
            if a{
                let index = indexPath.row
                cell.HospitalName.text = (self.objectArray[index].Name as! String)
                if let time = self.objectArray[index].Time as? Int{
                    cell.WaitTime.text = String(time) + " mins"
                }
                cell.HospitalName.adjustsFontSizeToFitWidth = true
                
            }
            
            if b{
                if let travelTime = travelTimeArray[indexPath.row] as? Int{
                    cell.TravelTime.text = String(travelTime) + " mins"
                }
            }
            
            if a && b{
                if let travel = self.travelTimeArray[indexPath.row] as? Int {
                    if let wait = self.objectArray[indexPath.row].Time as? Int{
                        cell.TotalTime.text = String(wait+travel) + " mins"
                    }
                }
            }
            
            
            
            
            
            
            return cell
            
         }

    

   
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


