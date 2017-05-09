//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"

class InstrumentationViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var rowsText: UITextField!
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var colsText: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var list: UITableView!
    @IBOutlet weak var addRow: UIButton!
    
    var titles =  [String]()
    var gridCoordinates =  [String:[[Int]]]()
    var passedData = [String:[[Int]]]()

    var engine: StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.getEngine()
        refreshSwitch.setOn(false, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
        rowsStepper.value = Double(engine.rows)
        colsStepper.value = Double(engine.cols)
        
        rowsText.text = "\(engine.rows)"
        colsText.text = "\(engine.cols)"
        
        jsonFetcher()
        
    }
    
    func jsonFetcher(){
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            
            let jsonArray = json as! NSArray
            
            (0..<jsonArray.count).forEach { i in
                let jsonDictionary = jsonArray[i] as! NSDictionary
                let jsonTitle = jsonDictionary["title"] as! String
                self.titles.append(jsonTitle)
                let jsonContents = jsonDictionary["contents"] as! [[Int]]
                self.gridCoordinates[jsonTitle] = jsonContents
            }
            
            OperationQueue.main.addOperation {
                self.list.reloadData()
            }
            
        }
    }
    
    
    @IBAction func addRow(_ sender: Any) {
        self.gridCoordinates["untitled"] = [[0,0]]
        self.titles = ["untitled"]
        self.list.reloadData()
    }

    @IBAction func refreshSwitch(_ sender: UISwitch) {
        if sender.isOn {
            engine.refreshRate = Double(refreshSlider.value)
        } else {
            engine.refreshRate = 0.0
        }
    }
    
    @IBAction func refreshSlider(_ sender: UISlider) {
        if refreshSwitch.isOn {
            engine.refreshRate = 0.0
            engine.refreshRate = Double(refreshSlider.value)
        }
        else {
            engine.refreshRate = 0.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rowsEditingEndedOnExit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = "\(self.engine.rows)"
            }
            return
        }
        
        rowsStepper.value = Double(val)
        engine.updateGridSize(rows: val, cols: val)
    }
    
    @IBAction func colsEditingEndedOnExit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = "\(self.engine.cols)"
            }
            return
        }
        
        colsStepper.value = Double(val)
        engine.updateGridSize(rows: val, cols: val)
    }

    @IBAction func rowSize(_ sender: UIStepper) {
        let rows = Int(sender.value)
        let cols = Int(sender.value)
        engine.updateGridSize(rows: rows, cols: cols)
        rowsText.text = "\(rows)"
    }
    
    @IBAction func colSize(_ sender: UIStepper) {
        let rows = Int(sender.value)
        let cols = Int(sender.value)
        engine.updateGridSize(rows: rows, cols: cols)
        colsText.text = "\(cols)"
    }
    
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = self.titles[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let newData = titles[indexPath.section]
            titles[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = list.indexPathForSelectedRow
        if let indexPath = indexPath {
            let key = self.titles[indexPath.item]
            let plots = gridCoordinates[key]
       
            if let vc = segue.destination as? GridEditorViewController {
                vc.plots = plots!
                vc.saveClosure = { saveGrid in
                    self.passedData["heyo"] = [[1]]
                    self.list.reloadData()
                }
            }
        }
    }

}

