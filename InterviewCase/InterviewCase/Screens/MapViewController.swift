//
//  MapViewController.swift
//  InterviewCase
//
//  Created by Maviye Çökelez on 7.04.2022.
//

import UIKit
import MapKit

protocol DismissMapViewController {
    var didHide: Bool {get set}
}

class MapViewController: UIViewController, DismissMapViewController {
    
    var didHide: Bool = false
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.subViewsSetup()
        
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else {return}
                
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                
                let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
                
                self.map.setRegion(region, animated: true)
                self.map.addAnnotation(pin)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.openQRScannerView()
        }
    }
    
    
    func openQRScannerView(){
        let alertController = UIAlertController(title: "QR", message: "Tercihinle, alışverişinde mağaza girişindeki QR kodu okutman gerekecektir, onaylıyor musun?", preferredStyle: .alert)
        let goToScanVC = UIAlertAction(title: "OK", style: .default)
        { (_) in
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "ScanViewController")
                destVC.modalPresentationStyle = .overFullScreen
                self.present(destVC, animated: false, completion: nil)
            }
        }
        alertController.addAction(goToScanVC)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
        self.present(alertController, animated: true)
    }
    
    @IBAction func didCancelButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func subViewsSetup() {
        self.subView.layer.cornerRadius = 20
        self.subView.layer.masksToBounds = true
        self.map.layer.cornerRadius = 20
        self.map.layer.masksToBounds = true
        self.subView.layer.borderColor = CGColor.init(gray: 1, alpha: 1)
        self.subView.layer.borderWidth = 10
    }
}


