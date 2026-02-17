import Foundation
import UIKit
import SnapKit


protocol IMVPWeatherView {
    
}

final class MVPWeatherController: UIViewController, IMVPWeatherView {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        return label
    }()
    
    private let windowLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()
    
    private let burgerButton: UIButton = {
        let button = UIButton(type: .system)
        let burgerImage = UIImage(systemName: "line.3.horizontal")
            button.setImage(burgerImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    
    private let presenter: IMVPWeatherPresenter
    
    init(presenter: IMVPWeatherPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    func configureUI() {
        view.backgroundColor = .lightGray
        
        view.addSubview(burgerButton)
        burgerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Offsets.topOffsetBurger)
            make.left.equalToSuperview().offset(Constants.Offsets.baseOffset)
            make.height.width.equalTo(Constants.SizeButton.sizeBurgerButton)
        }
        
        
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.Offsets.topOffsetTemperature)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
        
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        
        view.addSubview(windowLabel)
        windowLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(120)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
        
        let burgerAction = UIAction { _ in
            self.presenter.burgerButtonTapped()
        }
    
        burgerButton.addAction(burgerAction, for: .touchUpInside)
        
    }
    
}
