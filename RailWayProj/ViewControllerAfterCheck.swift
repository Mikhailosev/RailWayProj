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
    @IBOutlet weak var finish: UIImageView!
    @IBOutlet weak var arrows: UIImageView!
    @IBOutlet weak var toOutlet: UITextField!
    @IBOutlet weak var fromOutlet: UITextField!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var start: UIImageView!
    @IBAction func goToTableView(_ sender: UIButton) {
       performSegue(withIdentifier: "goToTableViewController", sender: self)
    }
    private var datePicker: UIDatePicker?

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewControllerAfterCheck.dateChanged(datePicker:)),for: .valueChanged)
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(ViewControllerAfterCheck.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        inputTextField.inputView=datePicker
setBackground()
        // Do any additional setup after loading the view.
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
        if (segue.identifier == "goToTableViewController") {
            guard let tableVC = segue.destination as? RoadListScreen else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            tableVC.arrival = toOutlet.text
            tableVC.date=inputTextField.text
            tableVC.departure=fromOutlet.text
            
        } else {
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }

}
