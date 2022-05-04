//
//  BottomSheetView.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 04.05.2022.
//

import UIKit

class BottomSheetView: UIView {
    private var viewModel: BottomSheetViewModel?

    private let title = UILabel(frame: .zero)
    private let label = UILabel(frame: .zero)
    private let number = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        title.font = .systemFont(ofSize: 14)
        title.textColor = .gray

        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black

        number.font = .systemFont(ofSize: 18)
        number.textColor = .black

        [title, label, number].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        [
            title.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),

            label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: title.leadingAnchor),

            number.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            number.leadingAnchor.constraint(equalTo: label.leadingAnchor)
        ].forEach { $0.isActive = true }
    }

    func setupView(with viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel

        title.text = viewModel.title
        label.text = viewModel.label
        number.text = viewModel.number
    }

}
