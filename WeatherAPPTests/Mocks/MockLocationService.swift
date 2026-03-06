import Foundation
@testable import WeatherAPP

final class MockLocationService: ILocationService {
    func getCurrentCoordinates(completion: @escaping (Double, Double) -> Void) {
        completion(53.90, 27.5667)
    }
}
