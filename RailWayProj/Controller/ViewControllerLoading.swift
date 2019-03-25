//
//  ViewControllerLoading.swift
//  RailWayProj
//
//  Created by iosadmin on 13/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerLoading: UIViewController {
    let AppDelegate = UIApplication.shared.delegate as? AppDelegate
    var destination: String?
    var departureDate: String?
    var fromWhere: String?
    var date: String?
    var arrival: String?
    var departure: String?
    var arrivalFull: String?
    var departureFull: String?
    var lineId: String?
    var platformArrival: String?
    var platformDeparture: String?
    var version: String?
    var versions:[String]=Array()
    var arrivalTime: String?
    var departureTime: String?
    var typeArrival: String?
    var typeDeparture: String?
    var stations:[String]=Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Gets data from the api, assing the, to core data

loadData()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        //MARK: Get data from API

        let urlCode = URL(string: "https://rata.digitraffic.fi/api/v1/live-trains/station/"+self.departure!+"/"+self.arrival!+"?departure_date="+self.date!)!
        print(urlCode)
        URLSession.shared.dataTask(with: urlCode) {data, response, error in
            if let error = error {
                print("Client error \(error)")
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...209).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            
            if let data=data {
                let managedContext = self.AppDelegate?.persistentContainer.viewContext
                managedContext?.perform {
                    //MARK: Parsing

                    let datas = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    print(datas!)
                    for value in datas! {
                        let value = value as? [String:Any]
                        self.version=String(value!["version"] as! Int)
                        self.lineId=String(value!["commuterLineID"] as! String)
                        self.departureDate=String(value!["departureDate"] as! String)
                        let timeTableRows=value!["timeTableRows"] as! NSArray
                        print(self.version!,self.lineId!)
                        for description in timeTableRows{
                            let description = description as? [String:Any]
                            if (self.departure==description!["stationShortCode"] as! String){
                                self.departureTime=description!["scheduledTime"] as! String
                                print(self.departureTime!)
                                self.typeDeparture=description!["type"] as! String
                                print(self.typeDeparture!)
                                self.platformDeparture=description!["commercialTrack"] as! String
                                print(self.platformDeparture!)
                            }
                            if (self.arrival==description!["stationShortCode"] as! String){
                                self.arrivalTime=description!["scheduledTime"] as! String
                                print(self.arrivalTime!)
                                self.typeArrival=description!["type"] as! String
                                print(self.typeArrival!)
                                self.platformArrival=description!["commercialTrack"] as! String
                                print(self.platformArrival!)
                            }
                        }
                        //MARK: Getting CoreData Filled

                        do { let newRide: RWP = try RWP.checkForRide(version: self.version ?? "No trip id!", context: managedContext!)!
                            newRide.setValue(self.version ?? "No id", forKey: "versionC")
                            print(self.version)
                            newRide.setValue(self.lineId ?? "No line", forKey: "typeTrainC")
                            newRide.setValue(self.departure ?? "No Station code", forKey: "departureCodeC")
                            newRide.setValue(self.departureFull ?? "No Full Station name", forKey: "departureC")
                            newRide.setValue(self.departureDate ?? "No date of trip", forKey: "dateOfTripC")
                            newRide.setValue(self.departureTime ?? "No time", forKey: "timeDepC")
                            newRide.setValue(self.typeDeparture ?? "No type of departure", forKey: "typeDepartureC")
                            newRide.setValue(self.platformDeparture ?? "No platform provided", forKey: "platformDepC")
                            newRide.setValue(self.arrivalFull ?? "No full name for station", forKey: "arrivalC")
                            newRide.setValue(self.arrival ?? "No code for station", forKey: "arrivalCodeC")
                            newRide.setValue(self.arrivalTime ?? "No arrival time", forKey: "timeArrC")
                            newRide.setValue(self.typeArrival ?? "No type of arrival", forKey: "typeArrivalC")
                            newRide.setValue(self.platformArrival ?? "No platform provided", forKey: "platformArrC")
                        } catch {
                            print(error)
                        }
                        
                        do {
                            try managedContext?.save()
                            self.AppDelegate?.saveContext()
                        } catch let error as NSError {
                            print("Could not save. \(error)")
                        }
                    }
                    
                    
                }
                
            }
            
            
            
            }.resume()
    }

    
    // MARK: - Navigation
    //MARK: Navigating to the tableView

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "goToTableView") {
     guard let tableVC = segue.destination as? RoadListScreen else {
     fatalError("Unexpected destination: \(segue.destination)")
     }
            tableVC.version=self.version
            tableVC.versions=self.versions
            tableVC.departureFull=self.departureFull
            tableVC.date=self.date
            tableVC.arrivalFull=self.arrivalFull
            tableVC.departure=self.departure
            tableVC.arrival=self.arrival
    }
            
        else {
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
