//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by MacOS on 13/12/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var highTempLable: UILabel!
    @IBOutlet weak var lowTempLable: UILabel!
    @IBOutlet weak var dayLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor=UIColor(red: 39/255, green: 123/255, blue: 192/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: DailyWeatherEntry){
        self.highTempLable.textAlignment = .center
        self.lowTempLable.textAlignment = .center
        self.lowTempLable.text = "\(Int(Int(model.temperatureLow)-32)*5/9)ºC"
        self.highTempLable.text = "\(Int(Int(model.temperatureHigh)-32)*5/9)ºC"
        self.dayLable.text = getDayForDate(Date(timeIntervalSince1970: Double( model.time)))
        
        let icon = model.icon.lowercased()
        if icon.contains("cloud"){
            self.imgIcon.image = UIImage(named: "cloud")

        } else if icon.contains("rain"){
            self.imgIcon.image = UIImage(named: "rain")

        } else {
            self.imgIcon.image = UIImage(named: "sun")
        }
    }
    
    func getDayForDate(_ date: Date?) -> String {
            guard let inputDate = date else {
                return ""
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Monday
            return formatter.string(from: inputDate)
        }
}
