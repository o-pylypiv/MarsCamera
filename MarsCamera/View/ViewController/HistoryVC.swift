//
//  HistoryVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 14.08.2024.
//

import UIKit

class HistoryVC: MCDataLoadingVC, UIGestureRecognizerDelegate {
    
    let historyItems: [String] = []

    private let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .left), for: .normal)
        return button
    }()
    
    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundOne
        setupNavigationBar()
        setupTableView()
        setEmptyState()
    }
    
    private func setupNavigationBar() {
        let navBarView = UIView()
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
    
    private func setupTableView() {
        view.addSubview(historyTableView)
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.dataSource = self
        historyTableView.delegate = self
        
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 132),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setEmptyState() {
        if historyItems.isEmpty {
            showEmptyStateView(with: "Browsing history is empty.", in: view)
            historyTableView.isHidden = true
        } else {
            dismissEmptyStateView()
            historyTableView.isHidden = false
        }
    }
    
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseID, for: indexPath) as! HistoryCell
        // Set data
        cell.configure(rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019")
        return cell
    }
    
}
