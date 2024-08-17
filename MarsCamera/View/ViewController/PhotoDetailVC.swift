//
//  PhotoDetailVC.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import UIKit

class PhotoDetailVC: UIViewController {
    private var viewModel: PhotoDetailViewModel?
    
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let cancelButton = UIButton()
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPhoto()
    }
    
    private func setupView() {
        view.backgroundColor = .black
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setImage(UIImage(resource: .closeLight), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func loadPhoto() {
        guard let viewModel = viewModel else { return }
        if let url = viewModel.imageURL {
            NetworkManager.shared.downloadImage(from: url.absoluteString) { [weak self] image in
                DispatchQueue.main.async { self?.imageView.image = image }
            }
        }
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoDetailVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
