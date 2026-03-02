import Foundation
import UIKit
import SnapKit


protocol IMVPWeatherView: AnyObject {
    func configureUI()
    func showCityListAndBack()
}

final class MVPWeatherController: UIViewController, IMVPWeatherView {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "🌍 Ваш город"
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--°"
        return label
    }()
    
    private let windowSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Ветер -- м/с"
        return label
    }()
    
    private let burgerButton: UIButton = {
        let button = UIButton(type: .system)
            button.setTitle("☰", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 32)
            return button
        }()
    
    
    private let presenter: IMVPWeatherPresenter
    var onCitySelected: ((MVPWeatherModel) -> Void)?
    
    init(presenter: IMVPWeatherPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureUI()
//        presenter.testNetwork() // проверка запросов с сервака
//        presenter.testCurrentLocation() // проверкк координат 
    }
    

    func configureUI() {
        view.backgroundColor = .lightGray
        
        view.addSubview(burgerButton)
        burgerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(60)

        }
        
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        
        view.addSubview(windowSpeedLabel)
        windowSpeedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(200)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        let burgerAction = UIAction { _ in
            self.presenter.burgerButtonTapped()
        }
        
        burgerButton.addAction(burgerAction, for: .touchUpInside)
    }
    
    func showCityListAndBack() {
        let cityListVC = MVPCityListAssembly().assembly()
        cityListVC.onCitySelected = { model in
            self.updateWeatherLabels(model)
            self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(cityListVC, animated: true)
    }

    private func updateWeatherLabels(_ model: MVPWeatherModel) {
        cityLabel.text = model.nameCity
        temperatureLabel.text = "\(Int(model.temp))°"
        windowSpeedLabel.text = "\(model.windSpeed) м/с"
    }

}
