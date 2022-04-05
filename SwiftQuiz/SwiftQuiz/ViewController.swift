//
//  ViewController.swift
//  SwiftQuiz
//
//  Created by Alban on 04/04/2022.
//

import UIKit

// Location: CoreLocation
// custom cell: collection view
// API / request to get the data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var table: UITableView!
    
    var models = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register 2 cells
        
        table.delegate = self
        table.dataSource = self
    }

    // Table $
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell()

}

struct Weather {
    
}

