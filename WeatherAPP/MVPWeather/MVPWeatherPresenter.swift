import Foundation
import UIKit


protocol IMVPWeatherPresenter {
    func burgerButtonTapped()
}

final class MVPWeatherPresenter: IMVPWeatherPresenter {
    
    var view: IMVPWeatherView?
    
    
    func burgerButtonTapped() {
        print("Нажал на бургер")
    }
    
}
