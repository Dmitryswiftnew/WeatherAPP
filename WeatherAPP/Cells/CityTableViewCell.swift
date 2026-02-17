import Foundation
import UIKit
import SnapKit

final class CityTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    func configure(cityName: String) {
        cityNameLabel.text = cityName
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
        cityNameLabel.text = nil
    }
    
}
