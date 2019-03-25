//
//  RoadListScreen.swift
//  RailWayProj
//
//  Created by iosadmin on 08/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//

import UIKit
import CoreData
struct FCname: Decodable {
    let stationName: String
    let stationShortCode: String
}
struct DepArr: Codable {
    let commuterLineID: String
    let version: String
    let timeTableRows: [timeTableRows]
}
struct timeTableRows: Codable {
    let stationShortCode: String
    let type: String
    let scheduledTime:String
    let commercialTrack: String
}

class RoadListScreen: UIViewController {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var fetchedResultsController: NSFetchedResultsController<RWP>?
    var destination: String?
    var fromWhere: String?
    var date: String?
    var arrival: String?
    var departure: String?
    var arrivalFull: String?
    var departureFull: String?
    var lineId: String?
    var versions:[String]=Array()
    var platformArrival: String?
    var platformDeparture: String?
    var version: String?
    var arrivalTime: String?
    var departureTime: String?
    var typeArrival: String?
    var typeDeparture: String?
    var stations:[String]=Array()

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: FetchReq, sorting, predicating

           let fetchRequest:NSFetchRequest<RWP> = RWP.fetchRequest()

            let sortDescriptor = NSSortDescriptor(key:"versionC", ascending:true)
            let sortDescriptor2 = NSSortDescriptor(key:"timeDepC", ascending:true)
            let sortDescriptor3 = NSSortDescriptor(key:"departureC", ascending:true)
            fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2, sortDescriptor3]
        print(self.version!)
            let predicate3 = NSPredicate(format: "departureC == %@ ", self.departureFull!)
            let predicate4 = NSPredicate(format: "arrivalC == %@ ", self.arrivalFull!)
            let predicate5 = NSPredicate(format: "dateOfTripC == %@ ", self.date!)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate5, predicate3, predicate4])
        fetchRequest.predicate = andPredicate
            let managedContext = self.appDelegate?.persistentContainer.viewContext
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: "versionC", cacheName: "RWPCache")
            self.fetchedResultsController!.delegate = self as? NSFetchedResultsControllerDelegate
            try? self.fetchedResultsController?.performFetch()
                print(self.version!)
        if let arrival=arrival,
            let departure=departure,
            let date=date {
            print ("\(arrival)")
              print ("\(departure)")
              print ("\(date)")
        }
      
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
    }
    func Alert (Message: String){
        
        let alert = UIAlertController(title: "checking for valid input", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: FILLING UP TABLEVIEW
extension RoadListScreen: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController!.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "roadCell", for: indexPath) as? TableViewCellData else {
            fatalError("The dequeued cell is not an instance of NewTableViewCell")
        }
        
        guard let ride = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("error")
        }
        
        cell.stationName.text = "From "+ride.departureC!
        cell.stationTime.text = "Time of departure: "+ride.timeDepC!
        cell.stationStatus.text = ride.typeDepartureC
        cell.stationPlatform.text = "To platform #"+ride.platformDepC!
        cell.stationName2.text = "To "+ride.arrivalC!
        cell.stationTime2.text = "Time of arrival "+ride.timeArrC!
        cell.stationStatus2.text = ride.typeArrivalC
        cell.stationPlatform2.text = "To platform #"+ride.platformArrC!
        print(ride.versionC)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController!.sections?.count ?? 1
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller Changed Content")
        tableView.reloadData()
    }
   
    
    
}
