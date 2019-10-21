//
//  ViewController.swift
//  Apple_VS_Google
//
//  Created by M'haimdat omar on 07-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import Vision
import Firebase

let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var whatService: String?
    var recognizedTxt: String?
    let vision = Vision.vision()
    
    let logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "default").resized(newSize: CGSize(width: screenWidth, height: screenWidth)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let apple: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToUploadApple(_:)), for: .touchUpInside)
        button.setTitle("Apple", for: .normal)
        let icon = UIImage(named: "upload")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        
        return button
    }()
    
    let google: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToUploadGoogle(_:)), for: .touchUpInside)
        button.setTitle("Google", for: .normal)
        let icon = UIImage(named: "upload")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.8801638484, green: 0.9526746869, blue: 0.9862166047, alpha: 1)
        
        addSubviews()
        setupLayout()
        
    }
    
    func addSubviews() {
        view.addSubview(logo)
        view.addSubview(apple)
        view.addSubview(google)
    }
    
    func setupLayout() {
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 20).isActive = true
        
        google.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        google.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        google.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        google.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        apple.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        apple.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        apple.heightAnchor.constraint(equalToConstant: 80).isActive = true
        apple.bottomAnchor.constraint(equalTo: google.topAnchor, constant: -20).isActive = true
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.recognizedTxt = ""
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if self.whatService == "Apple" {
                let requestHandler = VNImageRequestHandler(cgImage: pickedImage.cgImage!, options: [:])
                let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                for currentObservation in observations {
                    let topCandidate = currentObservation.topCandidates(1)
                        if let recognizedText = topCandidate.first {
                            self.recognizedTxt = self.recognizedTxt! + "\n" + recognizedText.string
                            print(self.recognizedTxt!)
                            DispatchQueue.main.async {
                                let controller = OutputViewController()
                                controller.result.text = self.recognizedTxt
                                controller.inputImage.image = pickedImage
                                picker.dismiss(animated: true, completion: nil)
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                        
                    }
                }
                
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true
                request.customWords = ["Omar", "MHAIMDAT", "omar", "mhaimdat"]
                try? requestHandler.perform([request])
                
            } else if self.whatService == "Google" {
                googleMlOCR(image: pickedImage) { (text) in
                    DispatchQueue.main.async {
                        let controller = OutputViewController()
                        controller.result.text = text
                        controller.inputImage.image = pickedImage
                        picker.dismiss(animated: true, completion: nil)
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func buttonToUploadApple(_ sender: BtnPleinLarge) {
        self.whatService = "Apple"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToUploadGoogle(_ sender: BtnPleinLarge) {
        self.whatService = "Google"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func googleMlOCR(image: UIImage, completion: @escaping (String?)->()) {
        let textRecognizer = vision.onDeviceTextRecognizer()
        let image = VisionImage(image: image)
        
        textRecognizer.process(image) { result, error in
            if let error = error {
                completion(error as? String)
            } else {
                completion(result?.text)
            }
        }
    }
    
}

