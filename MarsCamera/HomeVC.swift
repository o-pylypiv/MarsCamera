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
    var selectedDateString: String!
    
    private let historyButton = MCIconTextButton(icon: UIImage(resource: .historyIcon), title: nil)
    
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
        getPhotos()
        print(headerView.roverFilterButton.getTitle()!)
    }
    
    private func setupHeaderView() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(headerView)
        headerView.setDate(Date().convertToMonthDayYearFormat())
        selectedDateString = Date().convertToAPIFormat()
        
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
                    self.collectionView.reloadData()
                    self.showEmptyStateView(with: "No photos available.\n Try another date, rover or camera :)", in: self.view)
                } else {
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.dismissEmptyStateView()
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
                self.showEmptyStateView(with: "No photos available.\n Try another date, rover or camera :)", in: self.view)
            }
        }
    }
    
    func getPhotos() {
        showLoadingView()
        
        let rover = headerView.roverFilterButton.getTitle()
        var camera: String? = headerView.cameraFilterButton.getTitle()
        let date = selectedDateString
        
        if camera == "All" { camera = nil }
        if rover == "All" {
            fetchAllRoversPhotos(camera: camera, date: date)
        } else {
            viewModel.fetchPhotos(rover: rover, camera: camera, date: date)
        }
    }
    
    private func fetchAllRoversPhotos(camera: String?, date: String?) {
        let rovers = [RoverNames.curiosity, RoverNames.opportunity, RoverNames.spirit]
        var allPhotos: [Photo] = []
        let group = DispatchGroup()
        var hasErrorOccurred = false
        
        rovers.forEach { rover in
            group.enter()
            viewModel.fetchPhotos(rover: rover, camera: camera, date: date) { [weak self] result in
                defer { group.leave() }
                
                switch result {
                case .success(let photos):
                    allPhotos.append(contentsOf: photos)
                case .failure(let error):
                    hasErrorOccurred = true
                    self?.viewModel.didEncounterError?(error.rawValue)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            if hasErrorOccurred {
                print("An error occurred while fetching photos.")
                self?.presentErrorOnMainThread(message: "Failed to load photos. Please try again later.")
            }
            
            self?.viewModel.photos = allPhotos
            if allPhotos.isEmpty {
                print("No photos available for the selected criteria.")
                self?.viewModel.didUpdatePhotos?()
            } else {
                self?.viewModel.didUpdatePhotos?()
            }
        }
    }
    
    private func presentDatePicker() {
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        
        let datePickerView = MCDatePickerView()
        datePickerView.layer.cornerRadius = 50
        datePickerView.setDate(selectedDateString)
        datePickerView.dateSelected = { [weak self] selectedDate in
            self?.headerView.setDate(selectedDate.convertToDisplayFormat())
            print("Selected date: \(selectedDate)")
            self?.selectedDateString = selectedDate
            self?.getPhotos()
            self?.dismissDatePicker()
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
        roverPickerVC.rovers = ["All", "Curiosity", "Opportunity", "Spirit"]
        roverPickerVC.selectedRover = headerView.roverFilterButton.title(for: .normal)
        
        roverPickerVC.onRoverSelected = { [weak self] selectedRover in
            print("Rover selected from picker: \(selectedRover)")
            self?.headerView.roverFilterButton.changeTitle(newTitle: selectedRover)
            self?.getPhotos()
        }
        roverPickerVC.modalPresentationStyle = .overCurrentContext
        roverPickerVC.modalTransitionStyle = .crossDissolve
        present(roverPickerVC, animated: true)
    }

    private func presentCameraPicker() {
        let cameraPickerVC = CameraPickerVC()
        let cameraPickerViewModel = CameraPickerViewModel()
        
        cameraPickerViewModel.selectedRover = headerView.roverFilterButton.getTitle()
        cameraPickerVC.viewModel = cameraPickerViewModel
        
        cameraPickerVC.onCameraSelected = { [weak self] selectedCamera in
            guard let self else {return}
            self.headerView.cameraFilterButton.changeTitle(newTitle: selectedCamera)
            self.getPhotos()
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
