//
//  RoadListExtension.swift
//  RailWayProj
//
//  Created by iosadmin on 10/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//


import Foundation
import CoreData

extension RoadListScreen {
    func loadData(){
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
                let managedContext = self.appDelegate?.persistentContainer.viewContext
                managedContext?.perform {
                     let datas = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    print(datas!)
                    for value in datas! {
                        let value = value as? [String:Any]
                        self.version=String(value!["version"] as! Int)
                        self.lineId=String(value!["commuterLineID"] as! String)
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
                        do { let newRide: RWP = try RWP.checkForRide(version: self.version ?? "No trip id!", context: managedContext!)!
                            newRide.setValue(self.version ?? "No id", forKey: "versionC")
                            newRide.setValue(self.lineId ?? "No line", forKey: "typeTrainC")
                            newRide.setValue(self.departure ?? "No Station code", forKey: "departureCodeC")
                            newRide.setValue(self.departureFull ?? "No Full Station name", forKey: "departureC")
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
                            self.appDelegate?.saveContext()
                        } catch let error as NSError {
                            print("Could not save. \(error)")
                        }
                    }
                  
                        
                    }
                
                }
                
            
        
    }.resume()
    }
    func nameToCode(){
        let urlCode="https://rata.digitraffic.fi/api/v1/metadata/stations"
        let urlObj=URL(string: urlCode)
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            do {
                var codeDest=""
                var codeFrom=""
                var stations = try JSONDecoder().decode([FCname].self, from:data!)
                for names in stations{
                    if (names.stationName==self.arrival){
                        codeDest = names.stationShortCode
                        self.arrival=codeDest
                        self.arrivalFull=names.stationName
                        print(codeDest)
                    }
                    if (names.stationName==self.departure){
                        
                        codeFrom = names.stationShortCode
                        self.departure=codeFrom
                        self.departureFull=names.stationName
                        print(codeFrom)
                    }
                }
                if codeDest=="", codeFrom==""{
                    self.Alert(Message: "Incorrect information!")
                    
                }
                
            }
            catch {
                print("WE ve got and error+!")
            }
            
            self.loadData()}.resume()
        
    }
}
