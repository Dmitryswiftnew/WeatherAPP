@testable import WeatherAPP

final class MockNetworkService: INetworkService {
    var weatherModel: MVPWeatherModel?
    var getWeatherByCityCalled = false
    var getWeatherByCoordinatesCalled = false
    
    func getWeatherByCity(_ cityName: String, completion: @escaping (WeatherAPP.MVPWeatherModel?) -> Void) {
        getWeatherByCityCalled = true
        completion(weatherModel)
    }
    
    func getWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (WeatherAPP.MVPWeatherModel?) -> Void) {
        getWeatherByCoordinatesCalled = true
        completion(weatherModel)
    }
}
