//
//  WeatherTableViewCell.swift
//  SwiftQuiz
//
//  Created by Admin on 05/04/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel : UILabel!
    @IBOutlet var highTempLabel : UILabel!
    @IBOutlet var lowTempLabel : UILabel!
    @IBOutlet var iconImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    }
    
    
}
