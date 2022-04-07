//
//  ViewController.swift
//  SwiftQuiz
//
//  Created by Alban on 04/04/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate  {
    
    
    @IBOutlet var table: UITableView!
    var models = [Weather]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register 2 cells
      
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
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
        
        print("\(long) | \(lat)")
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func getInfosApi(){
        
        let lat: Int = 48
        let lon: Int = 2
        let ville = "Paris"
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
                            print(tempEnDegrees)
                            
                            
                            if let weather = data["weather"] as? [[String : AnyObject]]{
                                print(weather[0]["icon"]!)
                                print("https://openweathermap.org/img/w/\(weather[0]["icon"]!).png")
                                
                                /*
                                 self.weatherImageView.load(url: URL(string: "https://openweathermap.org/img/w/\(weather[0]["icon"]!).png")!)
                                 }*/
                                
                                
                                
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

struct Weather {
    
}
