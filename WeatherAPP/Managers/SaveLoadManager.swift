import Foundation

protocol ISaveLoadManager {
    func saveCities(_ cities: [String])
    func loadCities(for key: Keys) -> [String]
    func clearCitiesKey()
}

enum Keys: String {
    case city
}

final class SaveLoadManager: ISaveLoadManager {

    private let defaults = UserDefaults.standard
    
    func saveCities(_ cities: [String]) {
        defaults.set(cities, forKey: Keys.city.rawValue)
    }
    
    func loadCities(for key: Keys) -> [String] {
        return defaults.object(forKey: Keys.city.rawValue) as? [String] ?? []
    }
    
    func clearCitiesKey() {
        defaults.removeObject(forKey: Keys.city.rawValue)
        print("Ключ очищен")
    }
}

