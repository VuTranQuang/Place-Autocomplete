//
//  ViewController.swift
//  Maps-PlacePicker
//
//  Created by Vu on 5/15/19.
//  Copyright © 2019 Vu. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController  {
    var mapView: GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 21.032836, longitude: 105.765650, zoom: 16)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 21.032836, longitude: 105.765650)
        marker.title = "Đơn Nguyên 5, KTX Mỹ Đình II"
        marker.snippet = "Nam Từ Liêm"
        marker.map = mapView
    }

    @IBAction func onClickSearch(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.navigationController?.pushViewController(autoCompleteController, animated: true)
//        present(autoCompleteController, animated: true, completion: nil)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("\(place.name)")
        print("\(place.formattedAddress)")
        print("\(place.coordinate.latitude)")
        print("\(place.coordinate.longitude)")
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error:", error.localizedDescription)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
