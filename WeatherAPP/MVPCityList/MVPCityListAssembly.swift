import Foundation
import UIKit


final class MVPCityListAssembly {
    func assembly() -> UIViewController {
        let locationService = LocationService()
        let networkService = NetworkSevice()
        let presenter = MVPCityListPresenter(locationService: locationService, networkService: networkService)
        let controller = MVPCityListController(presenter: presenter)
        
        
        presenter.view = controller
        
        return controller
    }
}
