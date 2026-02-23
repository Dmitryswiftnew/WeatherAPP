import Foundation

final class MVPWeatherModel {
    
    let main: String
    let description: String
    let icon: String
    let temp: Double
    let windSpeed: Double
    let nameCity: String
    let cod: Int
    
    init(main: String, description: String, icon: String, temp: Double, windSpeed: Double, nameCity: String, cod: Int) {
        self.main = main
        self.description = description
        self.icon = icon
        self.temp = temp
        self.windSpeed = windSpeed
        self.nameCity = nameCity
        self.cod = cod
    }
}



