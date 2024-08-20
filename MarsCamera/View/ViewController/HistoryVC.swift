//
//  HistoryVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 14.08.2024.
//

import UIKit

class HistoryVC: MCDataLoadingVC, UIGestureRecognizerDelegate {
    
    var viewModel = HistoryViewModel()
    var historyCollectionView: UICollectionView!
    private let navBarView = UIView()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.font = UIFont.customLargeTitle
        label.textAlignment = .center
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .left), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundOne
        setupNavigationBar()
        setupCollectionView()
        
        bindViewModel()
        viewModel.getAllSavedFilters()
    }
    
    private func bindViewModel() {
        viewModel.didUpdateItems = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.dismissLoadingView()
                self.dismissEmptyStateView()
                
                if self.viewModel.savedFilters.isEmpty {
                    self.historyCollectionView.reloadData()
                    self.showEmptyStateView(with: "Browsing history is empty.", in: self.historyCollectionView)
                } else {
                    self.dismissEmptyStateView()
                    self.historyCollectionView.reloadData()
                    self.historyCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
        
        viewModel.didEncounterError = { [weak self] errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismissLoadingView()
                self.dismissEmptyStateView()
                self.historyCollectionView.reloadData()
                self.presentErrorOnMainThread(message: errorMessage)
            }
        }
        viewModel.didStartLoading = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { self.showLoadingView() }
        }
        
        viewModel.didEndLoading = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { self.dismissLoadingView() }
        }
    }
    
    private func setupNavigationBar() {
        navBarView.backgroundColor = .accentOne
        view.addSubview(navBarView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        
        navBarView.addSubview(backButton)
        navBarView.addSubview(historyLabel)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 132),
            
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: historyLabel.centerYAnchor),
            
            historyLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
            historyLabel.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -20)
        ])
        
        backButton.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 150)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        
        historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        historyCollectionView.backgroundColor = .backgroundOne
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
    
        historyCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.reuseID)
        view.addSubview(historyCollectionView)
        
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyCollectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            historyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savedFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = historyCollectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.reuseID, for: indexPath) as! HistoryCell
        let filterItem = viewModel.savedFilters[indexPath.row]
        cell.set(filter: filterItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Menu Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Use", style: .default, handler: { _ in
            let selectedFilterItem = self.viewModel.savedFilters[indexPath.row]
            self.viewModel.applyFilter(filter: selectedFilterItem)
        }))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            let selectedFilterItem = self.viewModel.savedFilters[indexPath.row]
            self.viewModel.deleteFilter(filter: selectedFilterItem)
            self.historyCollectionView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
}
