@testable import WeatherAPP
import XCTest

private enum Expected {
    static let moscowTemp: Double = 22.5
    static let moscowCity: String = "Москва"
    static let windSpeed: Double = 100
    static let defaultCity: String = "Проблема сети..."
    static let resultDeleteCity: [String] = ["Минск"]
    static let savedCitiesAfterDelete: [String] = []
}

final class MVPCityListPresenterTests: XCTestCase {
    
    var sut: MVPCityListPresenter!
    
    private var networkServiceMock: MockNetworkService!
    
    
    override func setUp() {
        super.setUp()
        
        networkServiceMock = MockNetworkService()
        sut = MVPCityListPresenter(networkService: networkServiceMock)
    }
    
    override func tearDown() {
        networkServiceMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_searchCity_Moscow_Success() {
        // given
        networkServiceMock.weatherModel = MVPWeatherModel(
            main: "Clear", description: "охуенно", icon: "01d",
            temp: Expected.moscowTemp, windSpeed: Expected.windSpeed,
            nameCity: Expected.moscowCity, cod: 200)
        // when
        sut.searchCity(Expected.moscowCity)
        
        let expectation = XCTestExpectation(description: "Сеть отзвонила")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(networkServiceMock.getWeatherByCityCalled,
                      "NetworkService.getWeatherByCity должен быть вызван"
        )
    }
    
    func test_getCurrentCityName_Default() {
        // given
        
        // when
        let result = sut.getCurrentCityName()
        
        // then
        XCTAssertEqual(result, Expected.defaultCity)
    }
    
    func test_deleteCity_RemovesCity() {
        // given
        sut.cities = ["Москва", "Минск"]
        
        // when
        sut.deleteCity(at: 0)
        
        // then
        XCTAssertEqual(sut.getCities(), Expected.resultDeleteCity)
    }
    
    
    func test_didSelectRow_SectionFirst_CurrentCity() {
        // given
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        // when
        sut.didSelectRow(at: indexPath)
        
        // then
        XCTAssertEqual(sut.getCurrentCityName(), Expected.defaultCity)
    }
    
    func test_saveLoadManager_SaveCities() {
        // given
        let mockSaveLoad = MockSaveLoadManager()
        mockSaveLoad.loadedCities = ["Лондон"]
        
    sut = MVPCityListPresenter(
        locationService: MockLocationService(),
        networkService: networkServiceMock,
        saveLoadManager: mockSaveLoad
    )
        // when
        sut.deleteCity(at: 0)
        
        // then
        XCTAssertEqual(mockSaveLoad.savedCities, Expected.savedCitiesAfterDelete)
    }
}
