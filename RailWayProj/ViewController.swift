//
//  ViewController.swift
//  RailWayProj
//
//  Created by iosadmin on 06/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func action(_ sender: Any) {
        performSegue(withIdentifier: "intcheck", sender: self)
    }
    
    @IBOutlet weak var labelStatusInternet: UILabel!
    @IBOutlet weak var buttonSetTitle: UIButton!
    @IBOutlet weak var labelInternet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if checkInternet.Connection(){
            labelInternet.text=""
            labelStatusInternet.text="Your device is connected to the internet"
            self.Alert(Message: "Connected")

            view.backgroundColor = UIColor(red: 87/255, green: 150/255, blue: 0/255, alpha: 1.0) /* #579600 */
        }
            
        else{
            
            buttonSetTitle.setTitle("",for:.normal)
             labelStatusInternet.text="You dont have internet!"
            labelInternet.text="You need to be conneted to the internet!"
            self.Alert(Message: "Your Device is not connected to the internet")
            view.backgroundColor = UIColor(red: 178/255, green: 0/255, blue: 0/255, alpha: 1.0) /* #b20000 */
            
        }
        
    }
    
    func Alert (Message: String){
        
        let alert = UIAlertController(title: "Internet Connection check", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
}


}
