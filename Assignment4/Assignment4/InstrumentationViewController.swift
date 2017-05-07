//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
   
    @IBOutlet weak var rowsText: UITextField!
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var colsText: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var refreshSwitch: UISwitch!
    

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
    

}

