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
        // Do any additional setup after loading the view, typically from a nib.
        rowsStepper.value = Double(engine.rows)
        colsStepper.value = Double(engine.cols)
        
        rowsText.text = "\(engine.rows)"
        colsText.text = "\(engine.cols)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gridSize(_ sender: UIStepper) {
        let rows = Int(sender.value)
        let cols = Int(sender.value)
        engine.updateGridSize(rows: rows, cols: cols)
        rowsText.text = "\(rows)"
        colsText.text = "\(cols)"
    }
    

}

