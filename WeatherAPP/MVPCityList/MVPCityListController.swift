import Foundation
import UIKit

protocol IMVPCityListView: AnyObject {
    func configureUI()
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
    
    
    
    init(presenter: IMVPCityListPresenter) {
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
        view.backgroundColor = .yellow
        
        
        
        
    }
    
}
