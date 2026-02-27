import Foundation
import UIKit


final class MVPCityListAssembly {
    func assembly() -> UIViewController {
        let locationService = LocationService()
        let networkService = NetworkSevice()
        let saveLoadManager = SaveLoadManager()
        let presenter = MVPCityListPresenter(locationService: locationService, networkService: networkService, saveLoadManager: saveLoadManager)
        let controller = MVPCityListController(presenter: presenter)
        
        
        presenter.view = controller
        
        return controller
    }
}
