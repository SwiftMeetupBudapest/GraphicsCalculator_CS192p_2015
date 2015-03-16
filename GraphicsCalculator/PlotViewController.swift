//
//  PlotViewController.swift
//  GraphicsCalculator
//
//  Created by Géza Mikló on 16/03/15.
//  Copyright (c) 2015 Géza Mikló. All rights reserved.
//

import UIKit


class PlotViewController: UIViewController, PlotDataSource {
    
    @IBOutlet weak var plotView: PlotView! {
        didSet {
            plotView.addGestureRecognizer(UIPinchGestureRecognizer(target: plotView, action: "onPinched:"))
            plotView.plotDataSource = self
        }
    }
    
    var calculatorBrainProgram : AnyObject = "" {
        didSet {
            println("Loading brain program")
            brain.program = calculatorBrainProgram
            updateUI()
        }
    }
        
    var brain = CalculatorBrain()
    var axesDrawer = AxesDrawer()
    
    func updateUI() {
        title = brain.description
        plotView?.setNeedsDisplay()
    }
    
    func getYValueFor(x: Double) -> Double? {
        brain.variableValues["M"] = x
        return brain.evaluate()
    }
}
