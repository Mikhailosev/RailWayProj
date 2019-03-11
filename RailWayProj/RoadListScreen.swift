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
    var platformArrival: String?
    var platformDeparture: String?
    var version: String?
    var arrivalTime: String?
    var departureTime: String?
    var typeArrival: String?
    var typeDeparture: String?
    

    
    @IBOutlet weak var tableView: UITableView!
    var roads: [tableViewCells] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        nameToCode()
        let fetchRequest:NSFetchRequest<RWP> = RWP.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key:"versionC", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let managedContext = appDelegate?.persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: "versionC", cacheName: "RWPCache")
        fetchedResultsController!.delegate = self as? NSFetchedResultsControllerDelegate
        try? fetchedResultsController?.performFetch()
        if let arrival=arrival,
            let departure=departure,
            let date=date {
            print ("\(arrival)")
              print ("\(departure)")
              print ("\(date)")
        }
    roads = createArray()
      
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
    }
    func createArray () -> [tableViewCells] {
        var tempArr: [tableViewCells]=[]
        let Cell1 = tableViewCells(title: "Oh lalalaaa")
        let Cell2 = tableViewCells(title: "Oh lululul")
        tempArr.append(Cell1)
        tempArr.append(Cell2)
        return tempArr
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
        
        cell.stationName.text = ride.departureC
        cell.stationTime.text = ride.timeDepC
        cell.stationStatus.text = ride.typeDepartureC
        cell.stationPlatform.text = ride.platformDepC
        cell.stationName2.text = ride.arrivalC
        cell.stationTime2.text = ride.timeArrC
        cell.stationStatus2.text = ride.typeArrivalC
        cell.stationPlatform2.text = ride.platformArrC
        
        
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
