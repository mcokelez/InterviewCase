//
//  LocationManager.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 6.04.2022.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject  {
    
    static let shared = LocationManager()
    private let view = UIViewController()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    var completion: ((CLLocation) -> Void)?
    
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)){
        self.completion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        print("lat: \(location.coordinate.latitude) ,long: \(location.coordinate.longitude)")
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied,.restricted:
            presentSettingsAlertController(title: "Enable Notifications?",
                                           message: "To use this feature you must enable notifications in settings")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
    func presentSettingsAlertController(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: "Settings", style: .default)
        { (_) in
            guard let setttingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if(UIApplication.shared.canOpenURL(setttingsURL))
            {
                UIApplication.shared.open(setttingsURL) { (_) in}
            }
        }
        alertController.addAction(goToSettings)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
        view.present(alertController, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
