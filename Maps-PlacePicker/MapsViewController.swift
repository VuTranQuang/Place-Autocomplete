//
//  MapsViewController.swift
//  Maps-PlacePicker
//
//  Created by Vu on 5/16/19.
//  Copyright © 2019 Vu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapsViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!


    let marker = GMSMarker()
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        return locationManager
    }()
    var selectedPlace: GMSPlace? {
        didSet {
            guard let place = selectedPlace else {
//                addressLabel.text = ConstantString.pickupPlacePlease
                return
            }
//            addressContainerView.backgroundColor = UIColor.white
//            addressLabel.text = place.formattedAddress ?? "Tại vị trí gim"
            let camera2 = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 18.0)
            mapView.camera = camera2
        }
    }

    var currentLocation: CLLocation?
    var zoomLevel: Float = 18.0
    var mapbounds:GMSCoordinateBounds? {
        if let visibleRegion = mapView?.projection.visibleRegion() {
            return GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func onClickPlace(_ sender: UIButton) {
        //        let config = GMSPlacePickerConfig(viewport: nil)
        //        let placePicker = GMSPlacePickerViewController(config: config)
        //        placePicker.delegate = self
        //        present(placePicker, animated: true, completion: nil)
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate

        present(autocompleteController, animated: true, completion: nil)
    }





}
extension MapsViewController: CLLocationManagerDelegate {


    func setupLocationManager() {
        let _ = locationManager
        //        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.isHidden = true
    }
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.currentLocation = currentLocation
        print("Current Location: \(currentLocation)")

        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            mapView.isHidden = false
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

}
extension MapsViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        marker.map = nil
        selectedPlace = place
        print("\(place.coordinate.latitude)")

        print("\(place.coordinate.longitude)")

        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                              longitude: place.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }

        showMarker(position: mapView.camera.target)
        dismiss(animated: true, completion: nil)

    }

    func showMarker(position: CLLocationCoordinate2D) {
        marker.position = position
        marker.map = mapView
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error:", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}





