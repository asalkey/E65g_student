//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Andy on 4/17/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var aliveCounter: UILabel!
    @IBOutlet weak var emptyCounter: UILabel!
    @IBOutlet weak var bornCounter: UILabel!
    @IBOutlet weak var diedCounter: UILabel!
    @IBOutlet weak var reseet: UIButton!
    
    var aliveStat = 0
    var emptyStat = 0
    var bornStat  = 0
    var diedStat  = 0
    
    var engine: EngineProtocol!
    var gridDataSource: GridViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
              self.stats()
        }

    }
    
    func stats(){
        engine = StandardEngine.engine
        
        (0 ..< engine.cols).forEach { i in
            (0 ..< engine.rows).forEach { j in
                    let grid = engine.grid[j,i]
                    switch grid {
                    case .alive:
                        aliveStat += 1
                    case .empty:
                        emptyStat += 1
                    case .born:
                        bornStat  += 1
                    case .died:
                        diedStat  += 1
                    }
                
            }
        }
        
        aliveCounter.text = "Alive: \(String(aliveStat))"
        emptyCounter.text = "Empty: \(String(emptyStat))"
        bornCounter.text = "Born: \(String(bornStat))"
        diedCounter.text = "Died: \(String(diedStat))"
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        
        aliveCounter.text = "Alive: 0"
        emptyCounter.text = "Empty: 0"
        bornCounter.text = "Born: 0"
        diedCounter.text = "Died: 0"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
