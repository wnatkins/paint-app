//
//  ColorViewController.swift
//  paintapp
//
//  Created by Whitney Atkinson on 12/12/19.
//  Copyright © 2019 Whitney Atkinson. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

	var color: UIColor!
	@IBOutlet weak var lineWidth: UISlider!
	@IBOutlet weak var redSlider: UISlider!
	@IBOutlet weak var greenSlider: UISlider!
	@IBOutlet weak var blueSlider: UISlider!
	@IBOutlet weak var redLabel: UILabel!
	@IBOutlet weak var greenLabel: UILabel!
	@IBOutlet weak var blueLabel: UILabel!
	@IBOutlet weak var colorPreview: UIImageView!
	@IBOutlet weak var widthLabel: UILabel!
	weak var delegate: dataDelegate? = nil
	var widthColor: Float!
	var red: CGFloat = 0.0
	var green: CGFloat = 0.0
	var blue: CGFloat = 0.0
	var alpha: CGFloat = 0.0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//nav. controller title and set rounded corners on the color preview
		self.title = "Colors"
		colorPreview.layer.cornerRadius = 10.0
    }
	
	override func viewWillAppear(_ animated: Bool) {
		//updates the width and color with the previously set values when the view appears again
		widthLabel.text = String(widthColor)
		lineWidth.value = widthColor
		colorPreview.backgroundColor = color
		//calls this function to update the slider values every time to view appears again. allows for sliders to keep the values even after the user exits and returns to the view
		setLabelsAndSliders()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		//when user taps back button, send the current color and width to the mainView to be used for drawing
		delegate?.colorSelected(color: color)
		delegate?.widthSet(widthColor: widthColor)
	}
	
	@IBAction func lineWidth(_ sender: Any) {
		//sets line width as defined by the slider
		let value = roundf((lineWidth.value) * 10)
		widthLabel.text = String(value/10)
		widthColor = value/10
	}
	
	@IBAction func redSlider(_ sender: Any) {
		//sets the red RGB value as defined by the slider and updates the label color and text dyanmically to match the value. also updates the color variable as the values change
		redLabel.textColor = UIColor(red: (CGFloat(redSlider.value) / 255), green: 0, blue: 0, alpha: 1.0)
		redLabel.text = String(round(redSlider.value))
		colorPreview.backgroundColor = UIColor(red: (CGFloat(redSlider.value) / 255), green: (CGFloat(greenSlider.value) / 255), blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
		color = UIColor(red: (CGFloat(redSlider.value) / 255), green: (CGFloat(greenSlider.value) / 255), blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
	}
	
	@IBAction func greenSlider(_ sender: Any) {
		//sets the green RGB value as defined by the slider and updates the label color and text dyanmically to match the value. also updates the color variable as the values change
		greenLabel.textColor = UIColor(red: 0, green: (CGFloat(greenSlider.value) / 255), blue: 0, alpha: 1.0)
		greenLabel.text = String(round(greenSlider.value))
		colorPreview.backgroundColor = UIColor(red: (CGFloat(redSlider.value) / 255), green: (CGFloat(greenSlider.value) / 255), blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
		color = UIColor(red: (CGFloat(redSlider.value) / 255), green: (CGFloat(greenSlider.value) / 255), blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
	}
	
	@IBAction func blueSlider(_ sender: Any) {
		//sets the blue RGB value as defined by the slider and updates the label color and text dyanmically to match the value. also updates the color variable as the values change
		blueLabel.textColor = UIColor(red: 0, green: 0, blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
		blueLabel.text = String(round(blueSlider.value))
		colorPreview.backgroundColor = UIColor(red: (CGFloat(redSlider.value) / 255), green: (CGFloat(greenSlider.value) / 255), blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
		color = UIColor(red: (CGFloat(redSlider.value) / 255), green: (CGFloat(greenSlider.value) / 255), blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
	}
	
	func setLabelsAndSliders(){
		//grabs the RGB values from the current color
		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		//sets the respective values for each color slider and label
		redSlider.value = roundf(Float(red * 255))
		redLabel.text = String(redSlider.value)
		greenSlider.value = roundf(Float(green * 255))
		greenLabel.text = String(greenSlider.value)
		blueSlider.value = roundf(Float(blue * 255))
		blueLabel.text = String(greenSlider.value)
		redLabel.textColor = UIColor(red: (CGFloat(redSlider.value) / 255), green: 0, blue: 0, alpha: 1.0)
		greenLabel.textColor = UIColor(red: 0, green: (CGFloat(greenSlider.value) / 255), blue: 0, alpha: 1.0)
		blueLabel.textColor = UIColor(red: 0, green: 0, blue: (CGFloat(blueSlider.value) / 255), alpha: 1.0)
	}
}

protocol dataDelegate: class {
	//a delegate to allow for values to be passed from this ColorViewController back to the original ViewController so the values can be used for drawing
	func colorSelected(color: UIColor)
	func widthSet(widthColor: Float)
}
