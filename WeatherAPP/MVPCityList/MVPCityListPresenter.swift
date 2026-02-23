import Foundation

protocol IMVPCityListPresenter {
    func backButtonTapped()
    func didSelectRow(at index: Int)
    func getCurrentCityName() -> String 
    
}


final class MVPCityListPresenter: IMVPCityListPresenter {
    weak var view: IMVPCityListView?
    
    private let locationService: ILocationService
    private let networkService: INetworkService
    private var currentCity: String = "Загрузка..."
   
    
    init(locationService: ILocationService = LocationService(),
         networkService: INetworkService = NetworkSevice()) {
        self.locationService = locationService
        self.networkService = networkService
        loadCurrentCity()
    
    }
    
    func getCurrentCityName() -> String {
        currentCity
    }
    
    private func loadCurrentCity() {
        view?.showLoading()
        
        locationService.getCurrentCoordinates { [weak self] lat, lon in
            self?.networkService.getWeatherByCoordinates(lat: lat, lon: lon) { model in
                DispatchQueue.main.async { [weak self] in
                    self?.view?.hideLoading()
                    if let model = model {
                        print("Текущий город \(model.nameCity)")
                        self?.currentCity = model.nameCity
                        self?.view?.reloadTableView()
                    } else {
                        self?.currentCity = "Ошибка"
                        self?.view?.reloadTableView()
                    }

                }
            }
        }
    }
    
    
    
    func backButtonTapped() {
        view?.navigationBack()
    }
    
    func didSelectRow(at index: Int) {
        print("Выбран город №\(index)")
    }
    
    
}
