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
    var scaleStep : CGFloat = 0.0 // Needed for draft mode
    
    var axesCenter : CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }

    var plotEquation = true
    
    override func drawRect(rect: CGRect) {
        if (axesCenter == nil) {
            axesCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        }
        let center = axesCenter!
        axesDrawer.color = color
        axesDrawer.contentScaleFactor = scale
        axesDrawer.drawAxesInRect(bounds, origin: center, pointsPerUnit: scale)

        if !plotEquation {
            return
        }
        
        println("~~~~~~~~~~~~~~~~~~~~")
        println("Scale \(scale)")
        
        var x = CGFloat(0.0)
        
        let plotBezierPath = UIBezierPath()
        plotBezierPath.moveToPoint(CGPoint(x: 0.0, y: center.y))
        
        while x < bounds.size.width {
            let xDouble = Double((x - center.x) / scale)
            if let yDouble = plotDataSource?.getYValueFor(xDouble) ?? 0 as Double {
                var yTransformed = center.y - CGFloat(yDouble) * scale
                println("y: \(yTransformed)")
                plotBezierPath.addLineToPoint(CGPoint(x: x, y: yTransformed))
            }
            //x += 1 + scaleStep; //Draft mode //max(1, 1 / scale) + scaleStep
            x += 1
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
            /*
            // Draft mode - draw in bigger steps to be ugly but quick
            scaleStep = 15.0
            drawColor = UIColor.grayColor()
            */
            plotEquation = false
            scale *= gesture.scale
            gesture.scale = 1.0
        case .Ended :
            /*
            // Exit Draft mode - draw in normal steps to be nice and slow
            scaleStep = 0
            drawColor = color
            */
            plotEquation = true
            scale *= gesture.scale
            gesture.scale = 1.0
        default: break
        }
    }
    
    func onPanned(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Changed :
            let translation = gesture.translationInView(self)
            /*
            // Draft mode - draw in bigger steps to be ugly but quick
            scaleStep = 15.0
            drawColor = UIColor.grayColor()
            */
            axesCenter = CGPoint(x: axesCenter!.x + translation.x, y: axesCenter!.y + translation.y)
            plotEquation = false
            gesture.setTranslation(CGPoint(x: 0.0, y: 0.0), inView: self)
        case .Ended :
            let translation = gesture.translationInView(self)
            /*
            // Exit Draft mode - draw in normal steps to be nice and slow
            scaleStep = 0
            drawColor = color
            */
            plotEquation = true
            axesCenter = CGPoint(x: axesCenter!.x + translation.x, y: axesCenter!.y + translation.y)
            gesture.setTranslation(CGPoint(x: 0.0, y: 0.0), inView: self)
        default: break
        }
    }
    
    func onDoubleTapped(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            let location = gesture.locationInView(self)
            axesCenter = CGPoint(x: location.x, y: location.y)
        default: break
        }
    }
}
