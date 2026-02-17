import Foundation
import UIKit




final class MVPWeatherAssembly {
    func assembly() -> UIViewController {
        let model = MVPWeatherModel()
        let presenter = MVPWeatherPresenter()
        let controller = MVPWeatherController(presenter: presenter)
        
        presenter.view = controller
        return controller
    }
}
