//
//  ControlsViewController.swift
//  Control
//
//  Created by Eric McGary on 12/31/16.
//
//

import UIKit

protocol ControlsViewControlerDelegate
{
    func controlsDidUpdateSpeeds(speeds:(left:Int, right:Int))
}

class ControlsViewController: UIViewController
{

    private let linearScale = LinearScale()
    
    private var leftSpeed:Int = 0 {
        didSet {
            delegate?.controlsDidUpdateSpeeds(speeds: (leftSpeed,rightSpeed))
        }
    }
    
    private var rightSpeed:Int = 0 {
        didSet {
            delegate?.controlsDidUpdateSpeeds(speeds: (leftSpeed,rightSpeed))
        }
    }
    
    private var viewHeight:CGFloat = 0.0
    private var center:CGFloat = 0.0;
    
    @IBOutlet weak var lefControlPadView: UIView!
    @IBOutlet weak var rightControlPadView: UIView!

    var delegate:ControlsViewControlerDelegate?
    
    override func viewDidLayoutSubviews()
    {
        linearScale.domain = [0.0, Double(lefControlPadView.frame.height + 10.0)] // 10.0 is the status bar height
        linearScale.range = [255.0, -255.0]
    }

    @IBAction func handleLeftPanGesture(_ sender: UIPanGestureRecognizer)
    {
        if sender.numberOfTouches > 0 {
            leftSpeed = roundToIncrement(increment: 20,value: Int(linearScale.scale(value: Double(sender.location(ofTouch: 0, in: view).y))))
        } else {
            leftSpeed = 0
        }
    }
    
    @IBAction func handleRightPanGesture(_ sender: UIPanGestureRecognizer)
    {
        if sender.numberOfTouches > 0 {
            rightSpeed = roundToIncrement(increment: 20, value: Int(linearScale.scale(value: Double(sender.location(ofTouch: 0, in: view).y))))
        } else {
            rightSpeed = 0
        }
    }
    
    private func roundToIncrement(increment:Int, value : Int) -> Int {
        return increment * Int(round(Double(value) / Double(increment)))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
