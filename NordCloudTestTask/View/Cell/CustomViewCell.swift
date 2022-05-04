//
//  CustomViewCell.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 02.05.2022.
//

import UIKit

class CustomViewCell: UICollectionViewCell {

    private let dataView = UIView(frame: .zero)
    private let callIcon = UIImageView(frame: .zero)
    private let durationLabel = UILabel(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let phoneLabel = UILabel(frame: .zero)
    private let timeLabel = UILabel(frame: .zero)

    private var phoneLabelConstraint = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit () {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        dataView.layer.cornerRadius = 5

        durationLabel.font = .italicSystemFont(ofSize: 14)
        durationLabel.textColor = .gray

        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        phoneLabel.font = .systemFont(ofSize: 16)
        phoneLabel.textColor = .black

        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .right

        contentView.addSubview(dataView)
        dataView.backgroundColor = .white
        dataView.translatesAutoresizingMaskIntoConstraints = false

        [callIcon, durationLabel, nameLabel, phoneLabel, timeLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            dataView.addSubview(view)
        }

        [
            dataView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dataView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dataView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dataView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            callIcon.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 20),
            callIcon.centerXAnchor.constraint(equalTo: durationLabel.centerXAnchor),
            callIcon.heightAnchor.constraint(equalToConstant: 40),
            callIcon.widthAnchor.constraint(equalToConstant: 40),

            durationLabel.topAnchor.constraint(equalTo: callIcon.bottomAnchor, constant: 10),
            durationLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor, constant: 20),

            nameLabel.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: callIcon.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -20),

            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            phoneLabel.leadingAnchor.constraint(equalTo: callIcon.trailingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -20),

            timeLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor, constant: -20),
            timeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 70)
        ].forEach { $0.isActive = true }

        phoneLabelConstraint = phoneLabel.centerYAnchor.constraint(equalTo: dataView.centerYAnchor)

    }

    func setupCell(with viewModel: CellViewModel) {
        print(viewModel)
        callIcon.image = viewModel.callIcon
        durationLabel.text = viewModel.duration
        if let name = viewModel.name {
            phoneLabelConstraint.isActive = false

            nameLabel.isHidden = false
            nameLabel.text = name

            phoneLabel.font = .systemFont(ofSize: 16)

        } else {
            nameLabel.isHidden = true
            phoneLabelConstraint.isActive = true

            phoneLabel.font = .boldSystemFont(ofSize: 16)
        }

        phoneLabel.text = viewModel.phone
        timeLabel.text = viewModel.time
    }

}
