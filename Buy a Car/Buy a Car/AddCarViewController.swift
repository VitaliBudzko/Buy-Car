//
//  AddCarViewController.swift
//  Buy a Car
//
//  Created by Sasha Dubikovskaya on 04.05.2019.
//  Copyright © 2019 Buy a Car. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class AddCarViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var addCarImageView: UIImageView!
    
    @IBOutlet weak var manufacturerTextField: UITextField!
    
    @IBOutlet weak var modelTextField: UITextField!
    
    @IBOutlet weak var caryearTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBAction func addPhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addCarImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        saveCar { (done) in
            if done {
                addCarImageView.image = nil
                manufacturerTextField.text = ""
                modelTextField.text = ""
                caryearTextField.text = ""
                priceTextField.text = ""
                print("We need to return now")
            } else {
                print("Try again")
            }
        }
    }
    
    // Core Data
    
    var car = [Cars]()
    
    func saveCar(comletion: (_ finished: Bool) ->()) {
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let car = Cars(context: managedContext)
        
        car.manufacturer = manufacturerTextField.text
        car.model = modelTextField.text
        car.carYear = caryearTextField.text
        car.price = priceTextField.text
        if let image = addCarImageView.image?.pngData() {
            car.image = image
        }
        
        do {
            try managedContext.save()
            print("Data saved")
        } catch {
            print("Failed to save data: " + error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCarImageView.layer.borderWidth = 1
        addCarImageView.layer.borderColor = (UIColor.blue).cgColor
        //registerForKeyboardNotifications()
    }
    
    // Keyboard control
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // Move view
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    deinit {
        removeKeyboardNotifications()
    }
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
