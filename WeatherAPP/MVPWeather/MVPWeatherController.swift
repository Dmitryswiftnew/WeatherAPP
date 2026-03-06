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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
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
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeather), for: .valueChanged)
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        containerView.addSubview(burgerButton)
        containerView.addSubview(cityLabel)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(windowSpeedLabel)
        
        burgerButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(60)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(burgerButton.snp.bottom).offset(50)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityLabel.snp.bottom).offset(40)
            make.width.height.equalTo(100)
        }
        
        windowSpeedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(40)
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.bottom.equalToSuperview().offset(-40)
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

    @objc private func refreshWeather() {
        refreshControl.endRefreshing()
        presenter.loadCurrentWeather { [weak self] model in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                if let model = model {
                    self?.updateWeatherLabels(model)
                }
            }
        }
    }
}
