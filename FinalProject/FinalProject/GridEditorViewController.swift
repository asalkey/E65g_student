//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Andy on 5/7/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var gridTitle: UITextField!
    
    var plots = [[Int]]()
    var savePlots = [[Int]]()
    var saveGrid = [String:[[Int]]]()
    var saveClosure: (([String:[[Int]]]) -> Void)?
    var engine: StandardEngine!
    var delegate: EngineDelegate?
    var numColsRows = Int()
    
    var instrumentation = InstrumentationViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        engine = StandardEngine.getEngine()
        engine.delegate = self
        gridView.gridDataSource = self
        numColsRows = plots.count + 5
        
        engine.updateGridSize(rows:  numColsRows ,cols:  numColsRows )
    
        (0..<plots.count).forEach { i in
            let row = plots[i][0]
            let col = plots[i][1]
            
            numColsRows = i + 1
            
            engine.grid[row,col] = CellState.alive
        }
        
        navigationController?.isNavigationBarHidden = false

    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.rows = engine.rows
        self.gridView.cols = engine.cols
        self.gridView.setNeedsDisplay()
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "GridUpdated"),
            object: nil,
            userInfo: ["engine" : self]
        )
        
        var title = "no title"
        if gridTitle.text == nil{
            title = gridTitle.text!
        }
        
        self.savePlots = []
        for i in 0..<self.gridView.rows {
            for j in 0..<self.gridView.cols {
                if engine.grid[i, j] == CellState.alive || engine.grid[i, j] == CellState.born {
                   self.savePlots.append([i,j])
                }
            }
        }
        
        saveGrid[title] = self.savePlots
        
        self.saveClosure!(saveGrid)
        self.navigationController?.popViewController(animated: true)
     
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
