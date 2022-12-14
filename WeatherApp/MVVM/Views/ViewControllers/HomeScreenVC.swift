//
//  ViewController.swift
//  WeatherApp
//
//  Created by MacOS on 12/12/2022.
//

import UIKit
import CoreLocation
class HomeScreenVC: UIViewController, CLLocationManagerDelegate {
    var vm = HomeScreenVM()
    var locationMagager = CLLocationManager()
    var currentLocation: CLLocation?
    var current : CurrentWeather?
    var hourlyModels = [HourlyWeatherEntry]()
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("show me")
        setupLocation()
    }
    func setupLocation(){
        locationMagager.delegate = self
        locationMagager.requestWhenInUseAuthorization()
        locationMagager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationMagager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {return}
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("\(long) | \(lat)")
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            // validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("error \(error)")
            }
            
            guard let result = json else {return}
            let entries = result.daily.data
            self.vm.models.append(contentsOf: entries)
            let currentWeather = result.currently
            self.current = currentWeather
            
            self.hourlyModels = result.hourly.data
            
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
    }
    func createTableHeader() -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 3))
        headerView.backgroundColor = UIColor(red: 255/255, green: 178/255, blue: 0, alpha: 1)
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: (headerView.frame.size.width-20)/2, height: headerView.frame.size.height * 0.25))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 10+locationLabel.frame.size.height, width: (headerView.frame.size.width-20)/2, height: headerView.frame.size.height * 0.45))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: locationLabel.frame.size.height + tempLabel.frame.size.height,width: (headerView.frame.size.width-20)/2, height: headerView.frame.size.height * 0.3))
        let timeLabel = UILabel(frame: CGRect(x: (headerView.frame.size.width-20)/2, y: 10, width: (headerView.frame.size.width-20)/2, height: headerView.frame.size.height/4))
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 3))
        let iconImage = UIImageView(frame: CGRect(x: (headerView.frame.size.width-20)/2, y: timeLabel.frame.size.height + 10, width: (headerView.frame.size.width-20)/2, height: headerView.frame.size.height * 2 / 4))
        
        let status = self.current?.summary
        
        if status?.contains("Cloud") ?? false{
            iconImage.image = UIImage(named: "cloud")
            background.image = UIImage(named: "cloudBack")

        } else if status?.contains("Rain") ?? false {
            iconImage.image = UIImage(named: "rain")
            background.image = UIImage(named: "rainBack")

        } else{
            iconImage.image = UIImage(named: "sun")
            background.image = UIImage(named: "clearBack")

        }
        
        iconImage.contentMode = .scaleAspectFit
        
        headerView.addSubview(background)
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(timeLabel)
        headerView.addSubview(iconImage)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        timeLabel.textAlignment = .center
        
        
        tempLabel.textColor = UIColor(red: 12/255.0, green: 65/255.0, blue: 117/255.0, alpha: 1)
        locationLabel.textColor = UIColor(red: 12/255.0, green: 65/255.0, blue: 117/255.0, alpha: 1)
        summaryLabel.textColor = UIColor(red: 12/255.0, green: 65/255.0, blue: 117/255.0, alpha: 1)
        timeLabel.textColor = UIColor(red: 12/255.0, green: 65/255.0, blue: 117/255.0, alpha: 1)
        locationLabel.text = "Current Location"
        timeLabel.text = "Today"
        guard let currentWeather = self.current else {
            return UIView()
        }
        
        tempLabel.text = "\(Manager.shared.changeDegreeFromFToC(degree: currentWeather.temperature))°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 80)
        summaryLabel.text = self.current?.summary
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        summaryLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        summaryLabel.numberOfLines = 0
        
        locationLabel.layer.shadowColor = UIColor.white.cgColor
        locationLabel.layer.shadowRadius = 2.0
        locationLabel.layer.shadowOpacity = 0.70
        locationLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        locationLabel.layer.masksToBounds = false
        
        tempLabel.layer.shadowColor = UIColor.white.cgColor
        tempLabel.layer.shadowRadius = 2.0
        tempLabel.layer.shadowOpacity = 0.70
        tempLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        tempLabel.layer.masksToBounds = false
        
        summaryLabel.layer.shadowColor = UIColor.white.cgColor
        summaryLabel.layer.shadowRadius = 2.0
        summaryLabel.layer.shadowOpacity = 0.70
        summaryLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        summaryLabel.layer.masksToBounds = false
        
        timeLabel.layer.shadowColor = UIColor.white.cgColor
        timeLabel.layer.shadowRadius = 2.0
        timeLabel.layer.shadowOpacity = 0.70
        timeLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        timeLabel.layer.masksToBounds = false
        
        iconImage.layer.shadowColor = UIColor.white.cgColor
        iconImage.layer.shadowRadius = 2.0
        iconImage.layer.shadowOpacity = 0.70
        iconImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        iconImage.layer.masksToBounds = false
        return headerView
    }
}

extension HomeScreenVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // 1 cell that is collectiontableviewcell
            return 1
        }
        // return models count
        return vm.models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else{return UITableViewCell()}
        cell.configure(with: vm.models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }
        return 70
    }
}
