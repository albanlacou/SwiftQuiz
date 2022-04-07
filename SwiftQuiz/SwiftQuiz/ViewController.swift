//
//  ViewController.swift
//  SwiftQuiz
//
//  Created by Alban on 04/04/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {
    let ville = "Paris"
    @IBOutlet weak var City: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet var table: UITableView!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var temperature: UILabel!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        City.text = ville
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        getInfosApi()
    }
    
    @objc func swipeFunc(gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            performSegue(withIdentifier: "Right", sender: self)
        }
        else if gesture.direction == .left {
            performSegue(withIdentifier: "Left", sender: self)
        }
        else if gesture.direction == .up {
            performSegue(withIdentifier: "Up", sender: self)
        }
        else if gesture.direction == .down {
            performSegue(withIdentifier: "Down", sender: self)
        }
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
    }
    
    // Table
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func getInfosApi(){
        
        let lat: Int = 48
        let lon: Int = 2
        
        let quoteUrl = URL(string: "\(Constants.apiBaseURL)?q=\(ville)&appid=\(Constants.apiKey)" )!
        var request = URLRequest(url: quoteUrl)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers){
                        
                        if let data = json as? [String: AnyObject]{
                            let main = data["main"]
                            let tempEnKelvin = main!["temp"]!! as? Double
                            let tempEnDegrees = Int(tempEnKelvin!) - 273
                            DispatchQueue.main.async {
                                self.temperature.text = "\(tempEnDegrees)°C"
                            }
                            let tempEnKelvinMax = main!["temp_max"]!!
                            print(tempEnDegrees)
                            
                            
                            if let weather = data["weather"] as? [[String : AnyObject]]{
                                print(weather[0]["icon"]!)
                                print("https://openweathermap.org/img/w/\(weather[0]["icon"]!).png")
                                
                                
                                 self.weatherImage.load(url: URL(string: "https://openweathermap.org/img/w/\(weather[0]["icon"]!).png")!)
                                 
                                
                                
                                
                            }
                            
                        }
                        
                    }
                }
                
            }
            
            
            
        }
        
        task.resume()
        
        
    }}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
