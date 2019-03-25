//
//  ViewControllerAutoDeparture.swift
//  RailWayProj
//
//  Created by iosadmin on 12/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//

import UIKit
// MARK: View that get the input for arrival, helping a person, autocompleting his/her inputs
class ViewControllerAutoDeparture: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    


    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchCell: UITableView!
    var searchBarText:String?
    var namesStations:[String]=Array()
    var originalNamesStations:[String]=Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarText=""

    searchCell.delegate=self
        searchCell.dataSource=self
        searchBar.delegate=self
        // Do any additional setup after loading the view.
        for station in namesStations{
            originalNamesStations.append(station)
        }
        searchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
    }
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    // MARK: Actual auto Copmlete function

    @objc func searchRecords(_ textField: UITextField){
    self.namesStations.removeAll()
        if textField.text?.count != 0 {
            for station in originalNamesStations {
                if let stationToSearch = textField.text {
                    let range = station.lowercased().range(of: stationToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.namesStations.append(station)
                    }
                }
            }
        }else {
            for station in originalNamesStations{
                namesStations.append(station)
            }
        }
        searchCell.reloadData()
    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "station")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "station")
        }
        cell?.textLabel?.text = namesStations[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            self.searchBar.text = namesStations[indexPath.row]

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
