import Foundation

protocol IMVPCityListPresenter {
    func backButtonTapped()
    func getCurrentCityName() -> String
    func searchCity(_ cityName: String)
    func getCities() -> [String]
    func deleteCity(at index: Int)
    func didSelectRow(at indexPath: IndexPath)
}

final class MVPCityListPresenter: IMVPCityListPresenter {
    weak var view: IMVPCityListViewController?
    
    private let locationService: ILocationService
    private let networkService: INetworkService
    private let saveLoadManager: ISaveLoadManager
    private var currentCity: String = NSLocalizedString("network problem current cell", comment: "Если город не найден проблема сети")
    private var searchTimer: Timer?
    
    var cities: [String] = []
    private var currentWeatherModel: MVPWeatherModel?
    private var selectedWeatherModel: MVPWeatherModel?
    private var searchWeatherModel: MVPWeatherModel?
    
    
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
                        self.currentCity = model.nameCity
                        self.currentWeatherModel = model
                        self.view?.reloadTableView()
                    } else {
                        self.view?.showErrorAlert(NSLocalizedString("error", comment: "ошибка"), NSLocalizedString("something went wrong", comment: ""))
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
                    self.searchWeatherModel = model
                    if !self.cities.contains(model.nameCity) {
                        self.cities.insert(model.nameCity, at: 0)
                        self.saveLoadManager.saveCities(self.cities)
                    }
                    self.view?.reloadTableView()
                } else {
                    self.view?.showErrorAlert(NSLocalizedString("error", comment: ""), NSLocalizedString("city not found", comment: ""))
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
    
    func didSelectRow(at indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            if let model = currentWeatherModel {
                view?.selectedCity(model)
            }
        case 1:
            if let model = searchWeatherModel {
                view?.selectedCity(model)
            }
        case 2:
            let cityName = getCities()[indexPath.row]
            self.view?.showLoading()
            networkService.getWeatherByCity(cityName) { [weak self] model in
                DispatchQueue.main.async { [weak self] in
                    self?.view?.hideLoading()
                    if let model = model {
                        self?.searchWeatherModel = model
                        self?.view?.selectedCity(model)
                    }
                }
            }
        default: break
        }
    }
    
}
