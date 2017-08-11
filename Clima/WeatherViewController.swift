//
//  ViewController.swift
//  WeatherApp
//
//  Created by Joshua Zimmerman on 08/10/2017.


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "5af6d5fc855755b2b174f471447690fb"
    

    // Instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    // Networking
    /***************************************************************/
    
    // getWeatherData method here
    
    func getWeatherData(url: String, parameters: [String: String]){
        
        Alamofire.request(url,  method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess { // Checks if JSON object returned sucessful
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!) // Assigns the JSON result to constant
                self.updateWeatherData(json: weatherJSON)
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
                
            }
        }
    }
    
    
    
    
    
    // JSON Parsing
    /***************************************************************/
   
    
    // UpdateWeatherData method
    // Takes JSON object as parameter
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json ["main"]["temp"].double { // Checks if valid json is passed
        
        weatherDataModel.temperature = Int((9/5)*(tempResult - 273.15)+32) // converts K degrees to F
        
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }
        else {
            
            cityLabel.text = "Weather unavailable"
            
        }
    }

    
    
    
    // UI Updates
    /***************************************************************/
    
    
    // UpdateUIWithWeatherData method
   
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city // Assigns the city name gotten from weather API
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    
    // Location Manager Delegate Methods
    /***************************************************************/
    
    
    // didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let location = locations[locations.count - 1] // Const to store last location in in array
        
      
        // Checks if location is valid. If valid location found, Stop updating location
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation() // Stops updating location
           
            // Stops current class from recieving messages from location manager while its in the process of being stopped
             locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
        
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    // didFailWithError method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    // Change City Delegate methods
    /***************************************************************/
    
    
    // userEnteredANewCityName Delegate method
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

    
    // PrepareForSegue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
        
        destinationVC.delegate = self
            
        }
    }
    
    
    
    
}


