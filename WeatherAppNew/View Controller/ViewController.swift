//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Zaoksky on 13.06.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var apparentTemperature: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func regreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "2a6d8e376a69c1ae07d4a52dd0c2dfdc")
    let coordinates = Coordinates(latitude: 61.972991, longitude: 15.270559)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        refreshButton.backgroundColor = .red
        refreshButton.layer.cornerRadius = refreshButton.frame.size.height / 2
        
        getCurrentWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        print("My location latitude: \(latitude), longitude: \(longitude)")
        
    }
    
    func getCurrentWeatherData() {
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            self.toggleActivityIndicator(on: false)
            switch result {
            case.Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                let alertController = UIAlertController(title: "Unable to get data",
                                                        message: "\(error.localizedDescription)",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            default:break
            }
        }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        self.apparentTemperature.text = currentWeather.apparentTemperatureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.pressureLabel.text = currentWeather.pressureString
    }
}
