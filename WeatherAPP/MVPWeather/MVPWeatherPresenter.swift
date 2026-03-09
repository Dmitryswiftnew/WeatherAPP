import Foundation
import UIKit

protocol IMVPWeatherPresenter {
    func burgerButtonTapped()
    func loadCurrentWeather(completion: @escaping (MVPWeatherModel?) -> Void)
}

final class MVPWeatherPresenter: IMVPWeatherPresenter {
    weak var view: IMVPWeatherViewController?
    private let locationService: ILocationService
    private let networkService: INetworkService
    
    init(locationService: ILocationService, networkService: INetworkService) {
        self.locationService = locationService
        self.networkService = networkService
    }
    
    func loadCurrentWeather(completion: @escaping (MVPWeatherModel?) -> Void) {
        locationService.getCurrentCoordinates { lat, lon in
            self.networkService.getWeatherByCoordinates(lat: lat, lon: lon) { model in
                DispatchQueue.main.async {
                    completion(model)
                }
            }
        }
    }
    
    func burgerButtonTapped() {
        view?.showCityListAndBack()
    }
}
