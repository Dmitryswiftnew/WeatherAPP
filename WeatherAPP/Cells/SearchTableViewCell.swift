import Foundation
import UIKit

enum SearchState {
    case normal
    case success
    case error
}

final class SearchTableViewCell: UITableViewCell {
    static var identifier: String { "\(Self.self)" }
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите город..."
        textField.font = .systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private var goButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("→", for: .normal)
        button.tintColor = .systemGreen
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.isHidden = true
        return button
    }()
    
    var onSearch: ((String) ->Void)?
    
    var searchState: SearchState = .normal {
        didSet {
            switch searchState {
            case .normal:
                searchTextField.textColor = .black
            case .success:
                searchTextField.textColor = .systemGreen
                goButton.isHidden = searchState != .success
            case .error:
                searchTextField.textColor = .systemRed
                goButton.isHidden = searchState == .error
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        contentView.addSubview(searchTextField)
        contentView.addSubview(goButton)
        
        goButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(searchTextField)
            make.width.height.equalTo(30)
        }
        
        
        let goButtonAction = UIAction { _ in
            self.goButtonTapped()
        }
        goButton.addAction(goButtonAction, for: .touchUpInside)
    }
    
    @objc private func textChanged() {
        searchState = .normal
        onSearch?(searchTextField.text ?? "")
    }
    
    
    func goButtonTapped() {
        print("Переход и показ данных")
    }
}
    

    




