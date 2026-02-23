import Foundation
import UIKit


protocol IMVPWeatherPresenter {
    func burgerButtonTapped()
    func testNetwork()
    func testCurrentLocation()
}

final class MVPWeatherPresenter: IMVPWeatherPresenter {
    weak var view: IMVPWeatherView?
    private let locationService: ILocationService
    private let networkService: INetworkService
    
    init(locationService: ILocationService, networkService: INetworkService) {
        self.locationService = locationService
        self.networkService = networkService
        
    }
    
    
    func testNetwork() {                                       // тестирование
        let network = NetworkSevice()
        
        network.getWeatherByCity("Вашингтон") { model in
            if let model = model {
                print(" \(model.nameCity): \(model.temp)°")
                print("   \(model.description), ветер \(model.windSpeed)м/с")
            } else {
                print(" Ошибка получения погоды")
            }
        }
        
    }
    
    func testCurrentLocation() {
        let testLat: Double = 37.566
        let testLon: Double = 126.978
      networkService.getWeatherByCoordinates(lat: testLat, lon: testLon) { model in
                if let model = model {
                    print("\(model.nameCity): \(model.temp)°")
                } else {
                    print(" Ошибка получения координат")
                }
            }
        }
    

    
    func burgerButtonTapped() {
        view?.showCityList()
    }
    
}
