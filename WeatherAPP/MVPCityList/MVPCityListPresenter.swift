import Foundation

protocol IMVPCityListPresenter {
    
}


final class MVPCityListPresenter: IMVPCityListPresenter {
    
    weak var view: IMVPCityListView?
    private let model: MVPWeatherModel
    
    init(model: MVPWeatherModel) {
        self.model = model
    }
}
