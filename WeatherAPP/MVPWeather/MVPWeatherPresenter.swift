import Foundation
import UIKit


protocol IMVPWeatherPresenter {
    func burgerButtonTapped()
    func testNetwork()
}

final class MVPWeatherPresenter: IMVPWeatherPresenter {
    
   var view: IMVPWeatherView?
    
    func testNetwork() {
        let network = NetworkSevice()
        
        network.getWeatherByCity("Москва") { data in
            print("Москва: \(data?.count ?? 0) байт")
        }
        
        network.getWeatherByCoordinates(lat: 53.90, lon: 27.56) { data in
            print("Минск coords: \(data?.count ?? 0) байт")
        }
    }
    

    
    func burgerButtonTapped() {
        view?.showCityList()
    }
    
}
