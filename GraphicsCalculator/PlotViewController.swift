//
//  PlotViewController.swift
//  GraphicsCalculator
//
//  Created by Géza Mikló on 16/03/15.
//  Copyright (c) 2015 Géza Mikló. All rights reserved.
//

import UIKit


class PlotViewController: UIViewController, PlotDataSource {
    
    // MARK: properties and outlets
    @IBOutlet weak var plotView: PlotView! {
        didSet {
            plotView.addGestureRecognizer(UIPinchGestureRecognizer(target: plotView, action: "onPinched:"))
            plotView.addGestureRecognizer(UIPanGestureRecognizer(target: plotView, action: "onPanned:"))
            
            // Add double tap recognizer
            let doubleTapRecognizer = UITapGestureRecognizer(target: plotView, action: "onDoubleTapped:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            plotView.addGestureRecognizer(doubleTapRecognizer)

            plotView.plotDataSource = self
        }
    }
    
    var calculatorCache = Dictionary<Double, Double>()
    
    var calculatorBrainProgram : AnyObject = "" {
        didSet {
            println("Loading brain program")
            brain.program = calculatorBrainProgram
            updateUI()
        }
    }
        
    var brain = CalculatorBrain()
    var axesDrawer = AxesDrawer()
    
    
    
    //MARK: View lifecycle methods
    override func viewDidLayoutSubviews() {
        plotView.axesCenter = CGPoint(x: plotView.bounds.width / 2, y: plotView.bounds.size.height / 2)
    }
    
    
    //MARK: helper methods
    
    func updateUI() {
        title = brain.description
        plotView?.setNeedsDisplay()
    }
    
    
    
    // MARK: PlotDatasource delegate
    
    /*
    CPU hog!!!
    While scaling or panning it will take a lot of CPU time
    Cannot be cached because depending on scale almost always a different set ot x values will be sent
    */
    func getYValueFor(x: Double) -> Double? {
        brain.variableValues["M"] = x
        return brain.evaluate()
    }
}
