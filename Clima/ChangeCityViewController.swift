//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Joshua Zimmerman on 08/10/2017.

import UIKit


// Protocol declaration
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
    
}


class ChangeCityViewController: UIViewController {
    
    // Delegate variable
    var delegate : ChangeCityDelegate?
    
    //The IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Gets the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        //3 Dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //The IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
