import Foundation


protocol IMVPCityListPresenter {
    func backButtonTapped()
    func didSelectRow(at index: Int)
    func getCurrentCityName() -> String 
    func searchCity(_ cityName: String)
    func getCities() -> [String]
}


final class MVPCityListPresenter: IMVPCityListPresenter {
    weak var view: IMVPCityListViewController?
    
    
    private let locationService: ILocationService
    private let networkService: INetworkService
    private var currentCity: String = "Загрузка..."
    private var searchTimer: Timer?
   
    var cities: [String] = ["Минск"] // хардкодим временно
    private var selectedWeatherModel: MVPWeatherModel?
    
    init(locationService: ILocationService = LocationService(),
         networkService: INetworkService = NetworkSevice()) {
        self.locationService = locationService
        self.networkService = networkService
        loadCurrentCity()
    
    }
    
    func getCurrentCityName() -> String {
        currentCity
    }
    
    func getCities() -> [String] {
        return cities
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
    
    func searchCity(_ cityName: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.performCitySearch(cityName)
        }
    }
    
    
    private func performCitySearch(_ cityName: String) {
        guard !cityName.isEmpty else { return }
        
        view?.showLoading()
        
        networkService.getWeatherByCity(cityName) { [weak self] model in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                if let model = model {
                    self?.view?.setSearchSuccess(true)
                    self?.selectedWeatherModel = model
                    self?.cities.insert(model.nameCity, at: 0)
                    self?.view?.reloadTableView()
                } else {
                    self?.view?.setSearchSuccess(false)
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
