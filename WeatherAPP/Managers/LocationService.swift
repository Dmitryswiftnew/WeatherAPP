import Foundation
import CoreLocation
import UIKit

protocol ILocationService {
    func getCurrentCoordinates(completion: @escaping (_ lat: Double, _ lon: Double) -> Void)
}

final class LocationService: NSObject, ILocationService {
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Double, Double) -> Void)?
    
    func getCurrentCoordinates(completion: @escaping (_ lat: Double, _ lon: Double) -> Void) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        locationCompletion = completion
    }
}
 
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        locationCompletion?(lat, lon)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Ошибка локации \(error)")
        locationManager.startUpdatingLocation()
        locationCompletion?(37.7749, -122.4194)
    }
}

