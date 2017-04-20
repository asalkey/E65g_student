//
//  GridView.swift
//  Assignment3
//
//  Created by Andy on 3/27/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView,GridViewDataSource {
    @IBInspectable var rows: Int = 10
    @IBInspectable var cols: Int = 10
    
    var gridDataSource : GridViewDataSource?
    
    @IBInspectable var livingColor = UIColor.black
    @IBInspectable var emptyColor = UIColor.white
    @IBInspectable var bornColor = UIColor.red
    @IBInspectable var gridColor = UIColor.blue
    @IBInspectable var diedColor = UIColor.yellow
    
    @IBInspectable var gridWidth = CGFloat(2.0)
    
    public subscript (row: Int, col: Int) -> CellState {
        get {return gridDataSource![row,col]}
        set {gridDataSource?[row,col] = newValue}
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation. */
    
    override func draw(_ rect: CGRect) {
        
        let gsize = CGSize(
            width: rect.size.width / CGFloat(self.cols),
            height: rect.size.height / CGFloat(self.rows)
        )
        
        let base = rect.origin
        
        /*circles*/
        (0 ..< self.cols).forEach { i in
            (0 ..< self.rows).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * gsize.width),
                    y: base.y + (CGFloat(i) * gsize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: gsize
                )
                
                let path = UIBezierPath(ovalIn: subRect)
                
                if let grid = gridDataSource {
                 switch grid[(i, j)] {
                  case .alive:
                    livingColor.setFill()
                  case .empty:
                    emptyColor.setFill()
                  case .born:
                    bornColor.setFill()
                  case .died:
                    diedColor.setFill()
                 }
                }
                
                path.fill()
            }
        }
        
        /*lines*/
        (0 ... self.cols + 1).forEach {
            drawLine(
                start: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y + (gsize.height * CGFloat($0))
                ),
                end: CGPoint(
                    x: rect.origin.x + rect.size.width,
                    y: rect.origin.y + (gsize.height * CGFloat($0))
                )
            )
        }
        
        (0 ... self.rows).forEach {
            drawLine(
                start: CGPoint(
                    x: rect.origin.x + (gsize.width * CGFloat($0)),
                    y: rect.origin.y
                ),
                end: CGPoint(
                    x: rect.origin.x + (gsize.width * CGFloat($0)),
                    y: rect.origin.y + rect.size.height
                )
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        path.lineWidth = gridWidth
        
        path.move(to: start)
        
        path.addLine(to: end)
        
        gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        if gridDataSource != nil {
            gridDataSource![pos.row, pos.col] = gridDataSource![pos.row, pos.col].isAlive ? .empty : .alive
            setNeedsDisplay()
        }
        
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(self.rows)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(self.cols)
        let position = (row: Int(row), col: Int(col))
        return position
    }
    

}
