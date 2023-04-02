//
//  TableViewCell.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 25)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

extension TableViewCell {
    private func configureCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:self.topAnchor,constant: 8),
            containerView.bottomAnchor.constraint(equalTo:self.bottomAnchor,constant: -8),
            containerView.leftAnchor.constraint(equalTo:self.leftAnchor,constant: 8),
            containerView.rightAnchor.constraint(equalTo:self.rightAnchor,constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo:containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo:containerView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}

extension TableViewCell {
    func setCell(model: ColorModel) {
        titleLabel.text = "\(model.id ?? 0) - \(model.name?.capitalized ?? "")"
        titleLabel.textColor = .white
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.containerView.backgroundColor = UIColor(hex:model.color ?? "")
    }
}
