//
//  ViewController.swift
//  SwiftQuiz
//
//  Created by Alban on 04/04/2022.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getQuote()
        
        getInfosApi()
    }
    
    
    func getInfosApi(){
        
        let lat: Int = 48
        let lon: Int = 2
        
        let quoteUrl = URL(string: "\(Constants.apiBaseURL)?q=Paris&appid=\(Constants.apiKey)" )!
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
                                
                                self.weatherImageView.load(url: URL(string: "https://openweathermap.org/img/w/\(weather[0]["icon"]!).png")!)
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
            }
            
        }
            
        task.resume()
        
    }
    
    


}

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
