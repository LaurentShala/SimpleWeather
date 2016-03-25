//
//  ViewController.swift
//  Weather
//
//  Created by Laurent Shala on 2/18/16.
//  Copyright © 2016 Laurent Shala. All rights reserved.
//  

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var day1Label: UILabel!
    @IBOutlet var day2Label: UILabel!
    @IBOutlet var day3Label: UILabel!
    
    @IBOutlet var day1TempLabel: UILabel!
    @IBOutlet var day2TempLabel: UILabel!
    @IBOutlet var day3TempLabel: UILabel!
    
    @IBOutlet var zipTextField: UITextField!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var iconDay1: UIImageView!
    @IBOutlet var iconDay2: UIImageView!
    @IBOutlet var iconDay3: UIImageView!
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        zipTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.zipTextField.delegate = self
        zipTextField.attributedPlaceholder = NSAttributedString(string:"Enter Zipcode", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    func updateData(currentURL: NSURL){
        Alamofire.request(.GET, currentURL).responseJSON { response in
            let json = JSON(data: response.data!)
            
            let currentTemp_F = json["current_observation"]["temp_f"].double!
            let currentCondition = json["current_observation"]["weather"].string!
            let currentLocation = json["current_observation"]["display_location"]["city"].string!
            
            var iconsTitle = [String]()
            iconsTitle.append(json["current_observation"]["icon"].string!)
            iconsTitle.append(json["forecast"]["simpleforecast"]["forecastday"][1]["icon"].string!)
            iconsTitle.append(json["forecast"]["simpleforecast"]["forecastday"][2]["icon"].string!)
            iconsTitle.append(json["forecast"]["simpleforecast"]["forecastday"][3]["icon"].string!)
            
            // MARK: - Dictionary
            var weatherDict = [String: String]()
            weatherDict["day1"] =  json["forecast"]["simpleforecast"]["forecastday"][1]["date"]["weekday_short"].string!
            weatherDict["day1High"] = json["forecast"]["simpleforecast"]["forecastday"][1]["high"]["fahrenheit"].string!
            weatherDict["day1Low"] = json["forecast"]["simpleforecast"]["forecastday"][1]["low"]["fahrenheit"].string!
            
            weatherDict["day2"] = json["forecast"]["simpleforecast"]["forecastday"][2]["date"]["weekday_short"].string!
            weatherDict["day2High"] = json["forecast"]["simpleforecast"]["forecastday"][2]["high"]["fahrenheit"].string!
            weatherDict["day2Low"] = json["forecast"]["simpleforecast"]["forecastday"][2]["low"]["fahrenheit"].string!
            
            weatherDict["day3"] = json["forecast"]["simpleforecast"]["forecastday"][3]["date"]["weekday_short"].string!
            weatherDict["day3High"] = json["forecast"]["simpleforecast"]["forecastday"][3]["high"]["fahrenheit"].string!
            weatherDict["day3Low"] = json["forecast"]["simpleforecast"]["forecastday"][3]["low"]["fahrenheit"].string!
            
            var images = [UIImageView]()
            images.append(self.iconImage)
            images.append(self.iconDay1)
            images.append(self.iconDay2)
            images.append(self.iconDay3)
            
            var dayLabels = [UILabel]()
            dayLabels.append(self.day1Label)
            dayLabels.append(self.day2Label)
            dayLabels.append(self.day3Label)
            
            var dayTempLabels = [UILabel]()
            dayTempLabels.append(self.day1TempLabel)
            dayTempLabels.append(self.day2TempLabel)
            dayTempLabels.append(self.day3TempLabel)
            
            for i in 0 ..< images.count {
                switch(iconsTitle[i]){
                case "chanceflurries" :  images[i].image = UIImage(named: "SnowWhite")
                case "chancerain"     :  images[i].image = UIImage(named: "RainWhite")
                case "chancesleet"    :  images[i].image = UIImage(named: "SnowWhite")
                case "chancesnow"     :  images[i].image = UIImage(named: "SnowWhite")
                case "chancetstorms"  :  images[i].image = UIImage(named: "ThunderWhite")
                case "clear"          :  images[i].image = UIImage(named: "ClearWhite")
                case "cloudy"         :  images[i].image = UIImage(named: "CloudWhite")
                case "flurries"       :  images[i].image = UIImage(named: "SnowWhite")
                case "mostlycloudy"   :  images[i].image = UIImage(named: "MostlyCloudyWhite")
                case "mostlysunny"    :  images[i].image = UIImage(named: "MostlySunnyWhite")
                case "partlycloudy"   :  images[i].image = UIImage(named: "PartlyCloudyWhite")
                case "partlysunny"    :  images[i].image = UIImage(named: "PartlyCloudyWhite")
                case "sleet"          :  images[i].image = UIImage(named: "SnowWhite")
                case "rain"           :  images[i].image = UIImage(named: "RainWhite")
                case "snow"           :  images[i].image = UIImage(named: "SnowWhite")
                case "sunny"          :  images[i].image = UIImage(named: "ClearWhite")
                case "tstorms"        :  images[i].image = UIImage(named: "ThunderWhite")
                default               :  images[i].image = UIImage(named: "CloudWhite")
                }
            }
            
            dayLabels[0].text = "\(weatherDict["day1"]!)"
            dayLabels[1].text = "\(weatherDict["day2"]!)"
            dayLabels[2].text = "\(weatherDict["day2"]!)"
            
            dayTempLabels[0].text = "\(weatherDict["day1High"]!)/\(weatherDict["day1Low"]!)"
            dayTempLabels[1].text = "\(weatherDict["day2High"]!)/\(weatherDict["day2Low"]!)"
            dayTempLabels[2].text = "\(weatherDict["day3High"]!)/\(weatherDict["day3Low"]!)"
            
            self.tempLabel.text = "\(Int(round(currentTemp_F)))°"
            self.conditionLabel.text = "\(currentCondition)"
            self.locationLabel.text = "\(currentLocation)"
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let zipcode = zipTextField.text!
        let url = NSURL(string: "http://api.wunderground.com/api/0d5b46eb763221c4/forecast/conditions/q/\(zipcode).json")!
        updateData(url)
        
        zipTextField.resignFirstResponder()
        return true
    }
}
