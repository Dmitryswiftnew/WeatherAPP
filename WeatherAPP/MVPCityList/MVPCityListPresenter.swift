import Foundation

protocol IMVPCityListPresenter {
    func backButtonTapped()
    func didSelectRow(at index: Int)
}


final class MVPCityListPresenter: IMVPCityListPresenter {
    
    
    
    weak var view: IMVPCityListView?
    private let model: MVPWeatherModel
    
    init(model: MVPWeatherModel) {
        self.model = model
    }
    
    func backButtonTapped() {
        view?.navigationBack()
    }
    
    func didSelectRow(at index: Int) {
        print("Выбран город №\(index)")
    }
    
    
}
