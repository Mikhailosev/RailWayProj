//
//  ViewControllerAfterCheck.swift
//  RailWayProj
//
//  Created by iosadmin on 07/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerAfterCheck: UIViewController {
    //MARK: Segues for UITextfields

    @IBAction func arrival(_ sender: Any) {
        performSegue(withIdentifier: "autoArrival", sender: self)
    }
    
    @IBAction func departure(_ sender: Any) {
    performSegue(withIdentifier: "autoDeparture", sender: "self")
    }
    
    
    @IBOutlet weak var finish: UIImageView!
    @IBOutlet weak var arrows: UIImageView!
    @IBOutlet weak var toOutlet: UITextField!
    @IBOutlet weak var fromOutlet: UITextField!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var start: UIImageView!
    private var datePicker: UIDatePicker?
    @IBOutlet weak var backgroundImageView: UIImageView!
    var arrival: String?
    var departure: String?
    var nameStations:[String]=Array()
    var nameStationArrival: String?
    var codeStationArrival:String?
    var nameStationDeparture: String?
    var codeStationDeparture:String?
    var newVar: String!
    var newVar2:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameToCode()
        fromOutlet.text=newVar
        toOutlet.text=newVar2
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewControllerAfterCheck.dateChanged(datePicker:)),for: .valueChanged)
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(ViewControllerAfterCheck.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        inputTextField.inputView=datePicker
setBackground()
        
        // Assigning values to OUTLETS.
    }
    override func viewWillAppear(_ animated: Bool) {
        fromOutlet.text=newVar
        toOutlet.text=newVar2
    }
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        inputTextField.text=dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    //MARK: Setting background
    

    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        backgroundImageView.image = UIImage(named: "gradient")
        start.image=UIImage(named: "start2")
        finish.image=UIImage(named: "finish")
        arrows.image=UIImage(named: "arrows")
        
        
view.sendSubviewToBack(backgroundImageView)
    }
    
    // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "autoArrival":
            guard let tableVC = segue.destination as? ViewControllerAutoArrival else {
                fatalError("Unexpected destination: \(segue.destination)")
                
            }
             tableVC.namesStations=self.nameStations
            
        case "goToLoading":
            guard let tableVC = segue.destination as? ViewControllerLoading else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            self.nameToCode()
            tableVC.arrival = self.codeStationArrival
            print(self.codeStationArrival)
            tableVC.arrivalFull=toOutlet.text
            print(self.toOutlet.text)
            tableVC.date=inputTextField.text
            print(self.inputTextField.text)
            tableVC.departureFull=fromOutlet.text
            print(self.fromOutlet.text)
            tableVC.departure=self.codeStationDeparture
            print(self.codeStationDeparture)
            
        
            
        case "autoDeparture":
            guard let tableVC = segue.destination as? ViewControllerAutoDeparture else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            tableVC.namesStations=self.nameStations
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    //MARK: UNWINDING

    @IBAction func unwindToCoreFromDeparture(_ sender:UIStoryboardSegue) {
        guard let departureVC =  sender.source as? ViewControllerAutoDeparture else {return}
        departureVC.searchBarText!=departureVC.searchBar.text!
        print(departureVC.searchBarText!)
        newVar=departureVC.searchBarText!
        fromOutlet.text=newVar
        nameToCode()
    }
    @IBAction func unwindToCoreFromArrival(_ sender:UIStoryboardSegue) {
        guard let arrivalVC =  sender.source as? ViewControllerAutoArrival else {return}
        arrivalVC.searchBarText!=arrivalVC.searchBar.text!
        print(arrivalVC.searchBarText!)
        newVar2=arrivalVC.searchBarText!
        fromOutlet.text=newVar2
        nameToCode()
    }
    //MARK: GETTING CODES OF STATION FROM USER INPUT

    func nameToCode(){
        let urlCode="https://rata.digitraffic.fi/api/v1/metadata/stations"
        let urlObj=URL(string: urlCode)
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            do {self.nameStations.removeAll()
                var stations = try JSONDecoder().decode([FCname].self, from:data!)
                for names in stations{
                    if (names.stationName==self.newVar2){
                    var nameStation = names.stationName
                    var stationCode=names.stationShortCode
                        self.nameStationArrival=nameStation
                        self.codeStationArrival=stationCode
                    }
                    if (names.stationName==self.newVar){
                        var nameStation = names.stationName
                        var stationCode=names.stationShortCode
                        self.nameStationDeparture=nameStation
                        self.codeStationDeparture=stationCode
                    }
                    var nameStationActual = names.stationName
                    self.nameStations.append(nameStationActual)
                
                }
            }
            catch {
                print("WE ve got and error+!")
            }
                
            }.resume()
}
        
    }


