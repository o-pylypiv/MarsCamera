//
//  RoverPickerVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import UIKit

class RoverPickerVC: UIViewController {
    
    var viewModel = RoverPickerViewModel()
    var onRoverSelected: ((String) -> Void)?
    
    var pickerView: UIPickerView!
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    private let titleLabel = UILabel()
    private var pickerCardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupPickerCardView()
        
        bindViewModel()
        
        if let allIndex = viewModel.rovers.firstIndex(of: "All") {
            pickerView.selectRow(allIndex, inComponent: 0, animated: false)
            viewModel.selectRover(at: allIndex)
        }
    }
    
    private func bindViewModel() {
        viewModel.didUpdateRovers = { [weak self] in
            DispatchQueue.main.async {
                self?.pickerView.reloadAllComponents()
            }
        }
    }
    
    private func setupPickerCardView() {
        pickerCardView = UIView(frame: .zero)
        pickerCardView.backgroundColor = .backgroundOne
        pickerCardView.layer.cornerRadius = 50

        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        confirmButton.setImage(UIImage(resource: .tick), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        cancelButton.setImage(UIImage(resource: .closeDark), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        titleLabel.text = "Rover"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.customTitle2

        let stackView = UIStackView(arrangedSubviews: [cancelButton, titleLabel, confirmButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pickerCardView)
        pickerCardView.addSubview(pickerView)
        pickerCardView.addSubview(stackView)
        let padding: CGFloat = 16

        stackView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerCardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickerCardView.heightAnchor.constraint(equalToConstant: 310),
            
            stackView.topAnchor.constraint(equalTo: pickerCardView.topAnchor, constant: padding/2),
            stackView.leadingAnchor.constraint(equalTo: pickerCardView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: pickerCardView.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            pickerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding/2),
            pickerView.leadingAnchor.constraint(equalTo: pickerCardView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerCardView.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerCardView.bottomAnchor, constant: -padding/2)
        ])
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func confirmButtonTapped() {
        guard let selectedRover = viewModel.selectedRover else { return }
        onRoverSelected?(selectedRover)
        dismissPicker()
    }

    @objc private func cancelButtonTapped() {
        dismissPicker()
    }

    @objc private func dismissPicker() {
        pickerCardView.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
}

extension RoverPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.rovers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getRoverName(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectRover(at: row)
    }
    
}
