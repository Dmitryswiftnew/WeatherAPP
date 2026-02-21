import Foundation
import SwiftyJSON


protocol INetworkService {
    func getWeatherByCity(_ cityName: String, completion: @escaping (Data?) -> Void)
    func getWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Data?) -> Void)
}


enum RequestType: String {
    case GET
}



final class NetworkSevice: INetworkService {
    
    private let baseURLString = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "464a3a6e5b45305ac50bac982fbd017a"
    
    
    func getWeatherByCity(_ cityName: String, completion: @escaping (Data?) -> Void) {
      let params = "?q=\(cityName)&lang=ru&appid=\(apiKey)&units=metric"
        sendRequest(type: .GET, params: params, completion: completion)
    }
    
    func getWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Data?) -> Void) {
        let params = "?lat=\(lat)&lon=\(lon)&lang=ru&appid=\(apiKey)&units=metric"
        sendRequest(type: .GET, params: params, completion: completion)
    }
    
    
    private func sendRequest(type: RequestType, params: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: "\(baseURLString)\(params)") else {
            print("Кривая урла")
            return completion(nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(nil) // потом сюда можно повесить обработчик ошибок
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Код ответа: \(httpResponse.statusCode)")
                } else {
                    print("Код ответа: \(httpResponse.statusCode)")
                    return
                }
            }
            completion(data)
        }.resume()
        
    }
    
    
}
