//
//  BottomSheetViewController.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 04.05.2022.
//

import UIKit

class BottomSheetViewController: UIViewController {

    private let containerView = UIView(frame: .zero)
    private let backgroundView = UIView(frame: .zero)
    private let contentView = BottomSheetView(frame: .zero)

    private let height: CGFloat = 150

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    private func commonInit() {
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.23
        containerView.layer.shadowRadius = 4

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16

        backgroundView.backgroundColor = .clear

        [backgroundView, containerView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            super.view.addSubview(view)
        }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentView)

        [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height),

            contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ].forEach { $0.isActive = true }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        backgroundView.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc private func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            dismiss(animated: true)
        }
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .ended {
            if translation.y > 20 {
                dismiss(animated: true)
            }
        }
    }

    func setupView(with viewModel: BottomSheetViewModel) {
        contentView.setupView(with: viewModel)
    }

}
