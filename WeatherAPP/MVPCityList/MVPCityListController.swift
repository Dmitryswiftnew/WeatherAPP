import Foundation
import UIKit

protocol IMVPCityListView: AnyObject {
    func configureUI()
    func navigationBack()
    func reloadTableView()
    func showLoading()
    func hideLoading()
}

final class MVPCityListController: UIViewController, IMVPCityListView {
    
    private let presenter: IMVPCityListPresenter
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private var backButton: UIButton = {
        let button = UIButton(type: .system)
        let backImage = UIImage(systemName: "chevron.left")
        button.setImage(backImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var cities: [String] = ["Минск"] // хардкодим временно
    
    init(presenter: IMVPCityListPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        configureUI()
    }
    
    
   
    func configureUI() {
        view.backgroundColor = .gray
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(44)
        }
        
        let backAction = UIAction { _ in
            self.presenter.backButtonTapped()
        }
        backButton.addAction(backAction, for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        
    }
    
    func navigationBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showLoading() {
        print("Загрузка текущего города...")
    }
    
    func hideLoading() {
        print("Город загружен!")
    }
    
}

extension MVPCityListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return cities.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Текущий город"
        case 1: return "Поиск"
        case 2: return "История"
        default: return nil
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else { return CityTableViewCell() }
        
        switch indexPath.section {
        case 0: cell.configure(cityName: presenter.getCurrentCityName())
        case 1: cell.configure(cityName: "Поиск города")
        case 2: cell.configure(cityName: cities[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath.row)
    }
    
    
}

