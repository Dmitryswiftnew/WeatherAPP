import Foundation
import UIKit

final class SearchTableViewCell: UITableViewCell {
    static var identifier: String { "\(Self.self)" }
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите город..."
        textField.font = .systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var onSearch: ((String) ->Void)?
    
    var isSuccess = false {
        didSet {
            searchTextField.textColor = isSuccess ? .systemGreen : .label
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
    }
    
    
    @objc private func textChanged() {
        isSuccess = false 
        onSearch?(searchTextField.text ?? "")
    }
    
}
    
    
    
    
    




