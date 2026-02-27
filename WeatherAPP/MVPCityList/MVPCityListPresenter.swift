import Foundation

protocol IMVPCityListPresenter {
    func backButtonTapped()
    func didSelectRow(at index: Int)
    func getCurrentCityName() -> String
    func searchCity(_ cityName: String)
    func getCities() -> [String]
    func deleteCity(at index: Int)
}

final class MVPCityListPresenter: IMVPCityListPresenter {
    weak var view: IMVPCityListViewController?
    
    private let locationService: ILocationService
    private let networkService: INetworkService
    private let saveLoadManager: ISaveLoadManager
    private var currentCity: String = "Загрузка..."
    private var searchTimer: Timer?
    
    var cities: [String] = [] // хардкодим временно
    private var selectedWeatherModel: MVPWeatherModel?
    
    init(locationService: ILocationService = LocationService(),
         networkService: INetworkService = NetworkSevice(),
         saveLoadManager: ISaveLoadManager = SaveLoadManager()
    )
    {
        self.locationService = locationService
        self.networkService = networkService
        self.saveLoadManager = saveLoadManager
        cities = saveLoadManager.loadCities(for: .city)
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
                    guard let self else { return }
                    self.view?.hideLoading()
                    if let model = model {
                        print("Текущий город \(model.nameCity)")
                        self.currentCity = model.nameCity
                        self.view?.reloadTableView()
                    } else {
                        self.view?.showErrorAlert("Ошибка", "Что-то пощло не так")
                        self.view?.reloadTableView()
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
                guard let self else { return }
                self.view?.hideLoading()
                if let model = model {
                    self.view?.setSearchSuccess(true)
                    self.selectedWeatherModel = model
                    self.cities.insert(model.nameCity, at: 0)
                    self.saveLoadManager.saveCities(self.cities)
                    self.view?.reloadTableView()
                } else {
                    self.view?.showErrorAlert("Ошибка", "Город не найден")
                }
            }
        }
    }
    
    func deleteCity(at index: Int) {
        cities.remove(at: index)
        saveLoadManager.saveCities(cities)
    }
    
    func backButtonTapped() {
        view?.navigationBack()
    }
    
    func didSelectRow(at index: Int) {
        print("Выбран город №\(index)")
    }
    
}
