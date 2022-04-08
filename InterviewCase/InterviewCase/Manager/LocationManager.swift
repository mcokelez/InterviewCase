//
//  LocationManager.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 6.04.2022.
//

import Foundation
import CoreLocation
import UIKit

protocol PermissionIsDenied : NSObject {
    var isDenied : Bool {get set}
}

class LocationManager: NSObject, PermissionIsDenied {
    
    static let shared = LocationManager()
   
    var isDenied: Bool = false
    
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
            self.presentSettingsAlertController(title: "Enable Notifications?",
                                               message: "To use this feature you must enable notifications in settings")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func presentSettingsAlertController(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: "Settings", style: .default, handler: {action in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        alertController.addAction(goToSettings)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
        UIApplication.topViewController()?.present(alertController, animated: false, completion: nil)
    }
    
}



