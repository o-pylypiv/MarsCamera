//
//  MCDatePickerView.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import UIKit

class MCDatePickerView: UIView {
    
    var dateSelected: ((String) -> Void)?
    var cancelTapped: (() -> Void)?
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .tick), for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .closeDark), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Date"
        title.font = UIFont.customTitle2
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .backgroundOne
        layer.cornerRadius = 50
        
        addSubview(datePicker)
        addSubview(confirmButton)
        addSubview(cancelButton)
        addSubview(titleLabel)
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            confirmButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    func setDateRange(minDate: Date, maxDate: Date) {
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    func setDate(_ date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: date) {
            datePicker.setDate(date, animated: false)
        }
    }
    
    @objc private func confirmButtonTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        dateSelected?(dateString)
        removeFromSuperview()
    }
    
    @objc private func cancelButtonTapped() {
        cancelTapped?()
        removeFromSuperview()
    }
    
}
