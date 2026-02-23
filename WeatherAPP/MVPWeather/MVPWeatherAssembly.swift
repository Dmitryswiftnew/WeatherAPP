import Foundation
import UIKit




final class MVPWeatherAssembly {
    func assembly() -> UIViewController {
        let locationService = LocationService()
        let networkService = NetworkSevice()
        let presenter = MVPWeatherPresenter(locationService: locationService, networkService: networkService)
        let controller = MVPWeatherController(presenter: presenter)
        
        presenter.view = controller
        return controller
    }
}
