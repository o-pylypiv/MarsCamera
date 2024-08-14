//
//  RoverPickerVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import UIKit

class RoverPickerVC: UIViewController {
    
    var rovers: [String] = ["All", "Curiosity", "Opportunity", "Spirit"]
    var selectedRover: String?
    var onRoverSelected: ((String) -> Void)?
    var photosViewModel: PhotosViewModel?
    
    private let pickerView = UIPickerView()
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
        
        if let selectedRover = selectedRover, let index = rovers.firstIndex(of: selectedRover) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        } else {
            pickerView.selectRow(0, inComponent: 0, animated: false)
            selectedRover = rovers[0]
        }
    }
    
    private func setupPickerCardView() {
        pickerCardView = UIView(frame: .zero)
        pickerCardView.backgroundColor = .white
        pickerCardView.layer.cornerRadius = 50
        pickerCardView.layer.shadowColor = UIColor.black.cgColor
        pickerCardView.layer.shadowOpacity = 0.2
        pickerCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        pickerCardView.layer.shadowRadius = 4

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
    
    @objc private func confirmButtonTapped() {
        guard let selectedRover = selectedRover else { return }
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
        return rovers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rovers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = rovers[row]
        let isSelected = title == selectedRover
        let font = isSelected ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 17)
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRover = rovers[row]
        pickerView.reloadAllComponents()
        print("Selected Rover is here: \(selectedRover ?? "None")")
    }
}
