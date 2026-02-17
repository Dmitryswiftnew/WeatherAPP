import Foundation
import UIKit


final class MVPCityListAssembly {
    func assembly() -> UIViewController {
        let model = MVPWeatherModel()
        let presenter = MVPCityListPresenter(model: model)
        let controller = MVPCityListController(presenter: presenter)
        
        
        presenter.view = controller
        
        return controller
    }
}
