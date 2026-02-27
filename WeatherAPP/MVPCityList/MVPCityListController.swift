import Foundation
import UIKit
import SVProgressHUD

protocol IMVPCityListViewController: AnyObject {
    func configureUI()
    func navigationBack()
    func reloadTableView()
    func showLoading()
    func hideLoading()
    func setSearchSuccess(_ success: Bool)
    func showErrorAlert(_ title: String, _ message: String)
}

final class MVPCityListController: UIViewController, IMVPCityListViewController {
    
    private let presenter: IMVPCityListPresenter
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
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
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showErrorAlert(_ title: String, _ message: String) {
        hideLoading()
        setSearchSuccess(false)
        showAlert(title: title, message: message)
    }
    
    
    func setSearchSuccess(_ success: Bool) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SearchTableViewCell{
            cell.searchState = success ? .success : .error
        }
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
        case 2: return presenter.getCities().count
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
            cell.configure(cityName: presenter.getCurrentCityName())
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
            as! SearchTableViewCell
            cell.onSearch = { [weak self] cityName in
                self?.presenter.searchCity(cityName)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as!
            CityTableViewCell
            cell.configure(cityName: presenter.getCities()[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 2 {
            presenter.deleteCity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath.row)
    }

}

