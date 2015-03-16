//
//  PlotView.swift
//  GraphicsCalculator
//
//  Created by Géza Mikló on 16/03/15.
//  Copyright (c) 2015 Géza Mikló. All rights reserved.
//

import UIKit

protocol PlotDataSource {
    func getYValueFor(x: Double) -> Double?
}

@IBDesignable
class PlotView: UIView {
    @IBInspectable
    var color : UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    var drawColor : UIColor?
    
    @IBInspectable
    var scale : CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var axesDrawer = AxesDrawer()
    
    var plotDataSource : PlotDataSource? = nil
    var scaleStep : CGFloat = 1.0

    override func drawRect(rect: CGRect) {
        let center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        axesDrawer.color = color
        axesDrawer.contentScaleFactor = scale
        axesDrawer.drawAxesInRect(bounds, origin: center, pointsPerUnit: scale)

        println("~~~~~~~~~~~~~~~~~~~~")
        println("Scale \(scale)")
        
        var x = CGFloat(0.0)
        
        let plotBezierPath = UIBezierPath()
        plotBezierPath.moveToPoint(CGPoint(x: 0.0, y: center.y))
        
        while x < bounds.size.width {
            let xDouble = Double((x - center.x) / scale)
            if let yDouble = plotDataSource?.getYValueFor(xDouble) ?? 0 as Double {
                var yTransformed = center.y - CGFloat(yDouble) * scale
                println(yTransformed)
                plotBezierPath.addLineToPoint(CGPoint(x: x, y: yTransformed))
            }
            x += max(1, 1 / scale) + scaleStep
        }
        if (drawColor == nil) {
            drawColor = color
        }
        drawColor!.set()

        plotBezierPath.stroke()
        println("Scale \(scale)")
        println("~~~~~~~~~~~~~~~~~~~~")

    }
    
    func onPinched(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            // Draft mode
            scaleStep = 15.0
            drawColor = UIColor.grayColor()
            scale *= gesture.scale
            gesture.scale = 1.0
        case .Ended :
            scaleStep = 1.0
            drawColor = color
            scale *= gesture.scale
            gesture.scale = 1.0
        default: break
        }
    }
}
