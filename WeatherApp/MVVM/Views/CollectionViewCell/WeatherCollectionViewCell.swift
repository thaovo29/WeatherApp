//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by MacOS on 14/12/2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containView.layer.cornerRadius = 8
        containView.layer.shadowColor = UIColor.darkGray.cgColor
        containView.layer.shadowRadius = 2.0
        containView.layer.shadowOpacity = 0.70
        containView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containView.layer.masksToBounds = false
    }
    
    static let identifier = "WeatherCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    func configure(with model: HourlyWeatherEntry){
        self.lblTemp.text = "\(Manager.shared.changeDegreeFromFToC(degree: model.temperature))ºC"
       
        self.imgIcon.image = UIImage(named: "sun")
        self.lblHour.text = Manager.shared.getHourForDate(date: Date(timeIntervalSince1970: Double( model.time)))
    }
}
