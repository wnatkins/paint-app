//
//  ViewController.swift
//  paintapp
//
//  Created by Whitney Atkinson on 12/12/19.
//  Copyright © 2019 Whitney Atkinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, dataDelegate {
	

	@IBOutlet weak var colorButton: UIButton!
	var beginPoint = CGPoint.zero
	var endPoint: CGPoint!
	var continuous = false
	var width: CGFloat = 10.0
	@IBOutlet weak var drawSpace: UIImageView!
	var drawColor: UIColor!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//default color is black
		drawColor = UIColor.black
		//gives color button rounded corners so it looks nice
		colorButton.layer.cornerRadius = 10.0
	}
	
	override func viewWillAppear(_ animated: Bool) {
		//set button color as the current drawing color
		colorButton.backgroundColor = drawColor
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//when color button is tapped viewcontroller prepares the send the current color and width to the ColorViewController
		if segue.identifier == "showColorView" {
			let controller = segue.destination as! ColorViewController
			controller.delegate = self
			controller.color = drawColor
			controller.widthColor = Float(width)
        }
	}
	
	//this and widthSet are protocol stubs from ColorViewController so that the color and width selected on ColorViewController get sent back to mainView for use.
	func colorSelected(color: UIColor) {
        drawColor = color
    }
	
	func widthSet(widthColor: Float) {
		width = CGFloat(widthColor)
	}

	//sets the starting point of a user's touch and marks that the touch is not continuous/a swpie
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else{
			return
		}
		continuous = false
		beginPoint = touch.location(in: drawSpace)
	}
	
	//draws the actual lines
	func draw(from startPoint: CGPoint, to endPoint: CGPoint){
		//creates a graphics context the same size as the drawSpace that takes the actual drawing
		UIGraphicsBeginImageContext(drawSpace.frame.size)
		guard let context = UIGraphicsGetCurrentContext() else{
			return
		}
		
		//sets boundaries for where to draw. users can only draw on the imageView
		drawSpace.image?.draw(in: drawSpace.bounds)
		
		//draws line from startPoint to endPoint
		context.move(to: startPoint)
		context.addLine(to: endPoint)
		
		//sets color, width, brush shape(LineCap), and how values are composited by context
		context.setLineCap(.round)
		context.setBlendMode(.normal)
		context.setLineWidth(CGFloat(width))
		context.setStrokeColor(drawColor.cgColor)
		
		//paints line on path startPoint -> endPoint
		context.strokePath()
		
		//sets the drawSpace's image as the drawing from the context defined at the beginning
		drawSpace.image = UIGraphicsGetImageFromCurrentImageContext()
		//sets drawSpace visible
		drawSpace.alpha = 1
		//clears the grahpics context
		UIGraphicsEndImageContext()
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	  guard let touch = touches.first else {
		return
	  }
	  //sets continuous = true which means the user dragged their finger across the screen so you draw a line begingPoint -> currentPoint where beginPoint = currentPoint as currentPoint changes while finger is moved
	  continuous = true
	  let currentPoint = touch.location(in: drawSpace)
	  draw(from: beginPoint, to: currentPoint)
		
	  beginPoint = currentPoint
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		//when touch has ended checks if continuous, if false, draw a single point
		if !continuous{
			draw(from: beginPoint, to: beginPoint)
		}
	}
	
	@IBAction func clearCanvas(_ sender: Any) {
		//checks if canvas is empty, if so tell user and allow them to cancel and draw something
		if drawSpace.image == nil{
			let notice = UIAlertController(title: "Your canvas is already empty!", message:"You need to draw before you can erase!", preferredStyle: .alert)
			notice.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
			self.present(notice, animated: true)
		}
		else{
			//if canvas is not empty, ask user if they are sure they would like to erase. if yes, clear canvas, if no then cancel.
			let alert = UIAlertController(title: "Are you sure you would like to erase your canvas?", message: "It cannot be recovered later!", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
				do {
					self.drawSpace.image = nil
				}
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	@IBAction func eraserTapped(_ sender: Any) {
		//when eraser is tapped set the drawColor is white and the color button as white 
		drawColor = UIColor.white
		colorButton.backgroundColor = UIColor.white
	}
	
	

}

