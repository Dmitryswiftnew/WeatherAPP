import Foundation
@testable import WeatherAPP

final class MockSaveLoadManager: ISaveLoadManager {
    var savedCities: [String] = []
    var loadedCities: [String] = []
    
    func saveCities(_ cities: [String]) {
        savedCities = cities
    }
    
    func loadCities(for key: Keys) -> [String] {
        loadedCities
    }
    
    func clearCitiesKey() {
        savedCities = []
    }
}

