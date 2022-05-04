//
//  ViewController.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    private var dataViewModel = DataViewModel()

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let noMissedCallsLabel = UILabel(frame: .zero)
    private let spinner = UIActivityIndicatorView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Missed calls"
        view.backgroundColor = .white
        commonInit()
    }

    private func commonInit() {
        dataViewModel.reloadCollectionView = {
            DispatchQueue.main.async {
                if self.collectionView.isHidden {
                    self.noMissedCallsLabel.isHidden = true
                    self.collectionView.isHidden = false
                }
                self.collectionView.reloadData()
            }
        }
        dataViewModel.noMissedCalls = {
            DispatchQueue.main.async {
                self.collectionView.isHidden = true
                self.noMissedCallsLabel.isHidden = false
            }
        }
        dataViewModel.showLoading = {
            DispatchQueue.main.async { self.spinner.startAnimating() }
        }
        dataViewModel.hideLoading = {
            DispatchQueue.main.async { self.spinner.stopAnimating() }
        }
        dataViewModel.getData()

        let safeArea = view.safeAreaLayoutGuide

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 100)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal

        collectionView.setCollectionViewLayout(layout, animated: true)

        noMissedCallsLabel.text = "No missed calls yet"
        noMissedCallsLabel.textAlignment = .center

        [collectionView, noMissedCallsLabel, spinner].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }

        [
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            noMissedCallsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            noMissedCallsLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            noMissedCallsLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor),

            spinner.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ].forEach { $0.isActive = true }

        noMissedCallsLabel.isHidden = true

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CustomViewCell.self, forCellWithReuseIdentifier: "callCell")
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.setupView(with: dataViewModel.getBottomSheetViewModel(at: indexPath))
        self.present(bottomSheetVC, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataViewModel.numberOfCells
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "callCell", for: indexPath) as! CustomViewCell

        cell.setupCell(with: dataViewModel.getCellViewModel(at: indexPath))
        return cell
    }

}
