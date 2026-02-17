import Foundation
import UIKit




final class MVPWeatherAssembly {
    func assembly() -> UIViewController {
        _ = MVPWeatherModel()
        let presenter = MVPWeatherPresenter()
        let controller = MVPWeatherController(presenter: presenter)
        
        presenter.view = controller
        return controller
    }
}
