//
//  CameraPickerVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 13.08.2024.
//

import UIKit

class CameraPickerVC: UIViewController {
    
    var viewModel = CameraPickerViewModel()
    var onCameraSelected: ((String) -> Void)?
    
    var pickerView: UIPickerView!
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    private let titleLabel = UILabel()
    private var pickerCardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupPickerCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedCamera = viewModel.selectedCamera, let index = viewModel.cameras.firstIndex(where: { $0.name == selectedCamera }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    private func setupPickerCardView() {
        pickerCardView = UIView(frame: .zero)
        pickerCardView.backgroundColor = .backgroundOne
        pickerCardView.layer.cornerRadius = 50
        pickerCardView.layer.shadowColor = UIColor.black.cgColor
        pickerCardView.layer.shadowOpacity = 0.2
        pickerCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        pickerCardView.layer.shadowRadius = 4

        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        confirmButton.setImage(UIImage(resource: .tick), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        cancelButton.setImage(UIImage(resource: .closeDark), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        titleLabel.text = "Camera"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.customTitle2

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
    
    @objc private func confirmButtonTapped() {
        if viewModel.selectedCamera == nil, viewModel.cameras.count > 0 {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            viewModel.selectedCamera = viewModel.getCameraName(for: selectedRow)
        }
        guard let selectedCamera = viewModel.selectedCamera else {
            presentAlert(title: "Select a Camera", message: "Please select a camera.")
            return
        }
        onCameraSelected?(selectedCamera)
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

extension CameraPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.cameras.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getCameraFullName(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedCamera = viewModel.getCameraName(for: row)
    }
    
}
