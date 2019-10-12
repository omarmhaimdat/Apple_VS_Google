//
//  OutputViewController.swift
//  Apple_VS_Google
//
//  Created by M'haimdat omar on 07-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {
    
    let inputImage: UIImageView = {
        let image = UIImageView(image: UIImage())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let result: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.font = UIFont(name: "Avenir", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let dissmissButton: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToDissmiss(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8801638484, green: 0.9526746869, blue: 0.9862166047, alpha: 1)
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        view.addSubview(dissmissButton)
        view.addSubview(inputImage)
        view.addSubview(result)
    }
    
    func setupLayout() {
        
        dissmissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        dissmissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        inputImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        inputImage.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        
        result.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        result.bottomAnchor.constraint(equalTo: dissmissButton.topAnchor, constant: -40).isActive = true
        result.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 20).isActive = true
        result.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -20).isActive = true
        
    }
    
    @objc func buttonToDissmiss(_ sender: BtnPleinLarge) {
        self.dismiss(animated: true, completion: nil)
    }
}

