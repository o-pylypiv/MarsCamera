//
//  ViewController.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import UIKit

class HomeVC: MCDataLoadingVC {
    
    var collectionView: UICollectionView!
    private var viewModel = PhotosViewModel()
    private var headerView = HeaderView()
    private let historyButton = MCIconTextButton(icon: UIImage(resource: .historyIcon), title: nil)
    
    private var minDate: Date?
    private var maxDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupCollectionView()
        setupHistoryButton()
        
        headerView.onDateButtonTapped = { [weak self] in self?.presentDatePicker() }
        headerView.onRoverButtonTapped = { [weak self] in self?.presentRoverPicker() }
        headerView.onCameraButtonTapped = { [weak self] in self?.presentCameraPicker() }
        headerView.onSaveButtonTapped = { [weak self] in self?.presentSaveFiltersAlert() }
        
        bindViewModel()
        viewModel.fetchRoverData()
    }
    
    private func setupHeaderView() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 202)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 150)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHistoryButton() {
        historyButton.setSize(width: 70, height: 70, iconSize: 44)
        historyButton.layer.cornerRadius = 35
        historyButton.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 44/255, alpha: 1)
        view.addSubview(historyButton)
        
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -21),
            historyButton.widthAnchor.constraint(equalToConstant: 70),
            historyButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        historyButton.addTarget(self, action: #selector(pushHistoryVC), for: .touchUpInside)
    }
    
    @objc private func pushHistoryVC() {
        let destVC = HistoryVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.didUpdatePhotos = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismissLoadingView()
                self.dismissEmptyStateView()
                
                if self.viewModel.photos.isEmpty {
                    self.showEmptyStateView(with: "No photos available.\nTry another date :)", in: self.collectionView)
                } else {
                    self.dismissEmptyStateView()
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
        
        viewModel.didEncounterError = { [weak self] errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismissLoadingView()
                self.dismissEmptyStateView()
                self.collectionView.reloadData()
                self.presentErrorOnMainThread(message: errorMessage)
            }
        }
        
        viewModel.didSetDateRange = { [weak self] minDate, maxDate in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.minDate = minDate
                self.maxDate = maxDate
                self.headerView.setDate(self.viewModel.selectedDateString.convertToDisplayFormat())
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
    
    private func presentDatePicker() {
        guard let minDate = minDate, let maxDate = maxDate else {
            presentErrorOnMainThread(message: "Date range not set.")
            return
        }
        
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        
        let datePickerView = MCDatePickerView()
        datePickerView.layer.cornerRadius = 50
        datePickerView.setDateRange(minDate: minDate, maxDate: maxDate)
        datePickerView.setDate(viewModel.selectedDateString)
        datePickerView.dateSelected = { [weak self] selectedDate in
            guard let self else {return}
            self.headerView.setDate(selectedDate.convertToDisplayFormat())
            self.viewModel.selectedDateString = selectedDate
            self.viewModel.selectedRover = "All"
            self.viewModel.selectedCamera = "All"
            self.headerView.roverFilterButton.changeTitle(newTitle: "All")
            self.headerView.cameraFilterButton.changeTitle(newTitle: "All")
            self.viewModel.getPhotos()
            self.dismissDatePicker()
        }
        datePickerView.cancelTapped = { [weak self] in
            self?.dismissDatePicker()
        }
        
        view.addSubview(dimmingView)
        dimmingView.addSubview(datePickerView)
        
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            datePickerView.centerXAnchor.constraint(equalTo: dimmingView.centerXAnchor),
            datePickerView.centerYAnchor.constraint(equalTo: dimmingView.centerYAnchor),
            datePickerView.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            datePickerView.heightAnchor.constraint(equalToConstant: 310)
        ])
        
        UIView.animate(withDuration: 0.3) { dimmingView.alpha = 1 }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissDatePicker() {
        if let dimmingView = view.subviews.first(where: { $0.backgroundColor == UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) }) {
            UIView.animate(withDuration: 0.3, animations: {
                dimmingView.alpha = 0
            }) { _ in
                dimmingView.removeFromSuperview()
            }
        }
    }
    
    private func presentRoverPicker() {
        let roverPickerVC = RoverPickerVC()
        roverPickerVC.viewModel.rovers = ["All"] + viewModel.validRovers 
        roverPickerVC.viewModel.selectedRover = headerView.roverFilterButton.title(for: .normal)
        
        roverPickerVC.onRoverSelected = { [weak self] selectedRover in
            print("Rover selected from picker: \(selectedRover)")
            self?.headerView.roverFilterButton.changeTitle(newTitle: selectedRover)
            self?.viewModel.updateFilters(rover: selectedRover, camera: "All")
            self?.headerView.cameraFilterButton.changeTitle(newTitle: "All")
            self?.viewModel.getPhotos()
        }
        
        roverPickerVC.modalPresentationStyle = .overCurrentContext
        roverPickerVC.modalTransitionStyle = .crossDissolve
        present(roverPickerVC, animated: true)
    }

    private func presentCameraPicker() {
        let cameraPickerVC = CameraPickerVC()
        cameraPickerVC.viewModel.cameras = viewModel.validCameras
        cameraPickerVC.viewModel.cameras.insert(CameraInfo(name: "All", fullName: "All") , at: 0)
        cameraPickerVC.viewModel.selectedRover = headerView.roverFilterButton.getTitle()
        
        cameraPickerVC.onCameraSelected = { [weak self] selectedCamera in
            self?.headerView.cameraFilterButton.changeTitle(newTitle: selectedCamera)
            self?.viewModel.updateFilters(rover: self?.viewModel.selectedRover, camera: selectedCamera)
            self?.viewModel.getPhotos()
        }
        
        cameraPickerVC.modalPresentationStyle = .overCurrentContext
        cameraPickerVC.modalTransitionStyle = .crossDissolve
        present(cameraPickerVC, animated: true)
    }
    
    private func presentSaveFiltersAlert() {
        //to do
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
        let photo = viewModel.photos[indexPath.item]
        cell.set(photo: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = viewModel.photos[indexPath.item]
        let detailViewModel = PhotoDetailViewModel(photo: selectedPhoto)
        let detailVC = PhotoDetailVC(viewModel: detailViewModel)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
}
