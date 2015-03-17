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
            plotView.addGestureRecognizer(UIPanGestureRecognizer(target: plotView, action: "onPanned:"))
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
    
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(animated: Bool) {
        plotView.axesCenter = CGPoint(x: plotView.bounds.size.width / 2, y: plotView.bounds.size.height / 2)
    }
    func updateUI() {
        title = brain.description
        plotView?.setNeedsDisplay()
    }
    
    func getYValueFor(x: Double) -> Double? {
        brain.variableValues["M"] = x
        return brain.evaluate()
    }
}
