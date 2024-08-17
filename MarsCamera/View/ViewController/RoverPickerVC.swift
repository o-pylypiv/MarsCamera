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
    }
    
    private func setupPickerCardView() {
        pickerCardView = UIView(frame: .zero)
        pickerCardView.backgroundColor = .white
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

        let stackView = UIStackView(arrangedSubviews: [cancelButton, titleLabel, confirmButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pickerCardView)
        pickerCardView.addSubview(pickerView)
        pickerCardView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerCardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickerCardView.heightAnchor.constraint(equalToConstant: 310),
            
            stackView.topAnchor.constraint(equalTo: pickerCardView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: pickerCardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: pickerCardView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            pickerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            pickerView.leadingAnchor.constraint(equalTo: pickerCardView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerCardView.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerCardView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)
    }

    private func bindViewModel() {
        viewModel.didUpdateRovers = { [weak self] in
            DispatchQueue.main.async {
                self?.pickerView.reloadAllComponents()
            }
        }
    }

    @objc private func confirmButtonTapped() {
        guard let selectedRover = viewModel.selectedRover else {
            print("No rover selected!")
            return
        }
        print("Confirmed Rover: \(selectedRover)")
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
        print("Row \(row) selected")
        viewModel.selectRover(at: row)
        print("Selected Rover is: \(viewModel.selectedRover ?? "None")")
    }
}
