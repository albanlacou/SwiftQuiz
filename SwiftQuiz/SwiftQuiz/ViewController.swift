//
//  ViewController.swift
//  SwiftQuiz
//
//  Created by Alban on 04/04/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate  {
    let ville = "Seattle"
    let defaults = UserDefaults.standard
    @IBOutlet weak var City: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet var table: UITableView!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var temperature: UILabel!
    
    var models = [Weather]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        City.text = ville
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        getInfosApi()
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
    
    func SetInFavoris(villeAMettreFavoris: String){
        if var tabVilleEnregistrer = self.defaults.object(forKey: "VilleEnFavoris") as? Array<String> {
            var i = 0
            
                for villesEnregistrer in tabVilleEnregistrer{
                    i = i+1
                    if villeAMettreFavoris == villesEnregistrer{
                        tabVilleEnregistrer.remove(at: i)
                    }else{
                        tabVilleEnregistrer.append(villeAMettreFavoris)
                    }
                }
            
            self.defaults.set(tabVilleEnregistrer, forKey: "VilleEnFavoris")
        }else{
            var tab = [] as Array<String>
            tab.append(villeAMettreFavoris)
            self.defaults.set(tab, forKey: "VilleEnFavoris")
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
    
    func convertKelvinToDegrees(tempEnKelvin: Int)-> Int{
        return tempEnKelvin - 273
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func createUrlApi(lat: Int = -1000, long: Int = -1000, city: String = "")->URL{
        var quoteUrl = URL(string: "")
        if lat != -1000 && long != -1000 && city == ""{
            quoteUrl = URL(string: "\(Constants.apiBaseURL)?q=\(ville)&appid=\(Constants.apiKey)" )!
        }else if lat == -1000 && long == -1000 && city != ""{
            quoteUrl = URL(string: "\(Constants.apiBaseURL)?lat=\(lat)&long=\(long)&appid=\(Constants.apiKey)" )!
        }
        return quoteUrl!
    }
    
    func getInfosApi(){
        
        let lat: Int = 48
        let lon: Int = 2
        
        
        var request = URLRequest(url: createUrlApi(city: ville))
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers){
                        
                        if let data = json as? [String: AnyObject]{
                            let main = data["main"]
                            let tempEnKelvin = main!["temp"]!! as? Double
                            let tempEnDegrees = self.convertKelvinToDegrees(tempEnKelvin: Int(tempEnKelvin!))
                            DispatchQueue.main.async {
                                self.temperature.text = "\(tempEnDegrees)°C"
                            }
                            
                            let tempEnKelvinMax = main!["temp_max"]!! as? Double
                            let tempEnDegreesMax = self.convertKelvinToDegrees(tempEnKelvin: Int(tempEnKelvinMax!))
                            DispatchQueue.main.async {
                                self.maxTemp.text = "Min: \(tempEnDegreesMax)°C"
                            }
                            
                            
                            let tempEnKelvinMin = main!["temp_min"]!! as? Double
                            let tempEnDegreesMin = self.convertKelvinToDegrees(tempEnKelvin: Int(tempEnKelvinMin!))
                            DispatchQueue.main.async {
                                self.minTemp.text = "Min: \(tempEnDegreesMin)°C"
                            }
                            
                            
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

struct Weather {
    
}
