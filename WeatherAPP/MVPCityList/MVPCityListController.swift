import Foundation
import UIKit

protocol IMVPCityListView: AnyObject {
    func configureUI()
    func navigationBack()
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
            make.top.equalToSuperview().offset(74)
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
}

extension MVPCityListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else { return CityTableViewCell() }
        
        if indexPath.row == cities.count {
            cell.configure(cityName: "➕ Добавить город")
        } else {
            cell.configure(cityName: cities[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath.row)
    }
    
    
}

