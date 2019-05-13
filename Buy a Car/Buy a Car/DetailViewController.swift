//
//  DetailViewController.swift
//  Buy a Car
//
//  Created by Sasha Dubikovskaya on 10.05.2019.
//  Copyright © 2019 Buy a Car. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailCarImage: UIImageView!
    
    @IBOutlet weak var detailManufacturerTF: UITextField!
    
    @IBOutlet weak var detailModelTF: UITextField!
    
    @IBOutlet weak var detailCarYearTF: UITextField!
    
    @IBOutlet weak var detailPriceTF: UITextField!
    
    @IBAction func editDetails(_ sender: Any) {
        detailManufacturerTF.isEnabled = true
        detailModelTF.isEnabled = true
        detailCarYearTF.isEnabled = true
        detailPriceTF.isEnabled = true
    }
    
    var detailCar: Cars?
    
    // Get data from core data
    
    func fetchData (comletion: (_ compete: Bool) -> ()) {
        let thirdAppDelegate = appDelegate
        let managedContext = thirdAppDelegate.persistentContainer.viewContext;
        let request = NSFetchRequest <NSFetchRequestResult>(entityName: "Cars")
        request.returnsObjectsAsFaults = false
        do {
            carsArray = try managedContext.fetch(request) as! [Cars]
            print("Data fetched")
        } catch {
            print("Unable to fetch data: " + error.localizedDescription)
        }
    }
    
    @IBAction func saveDetails(_ sender: Any) {
        let thirdAppDelegate = appDelegate
        let managedContext = thirdAppDelegate.persistentContainer.viewContext
        
        // Delete old object from core data
        
        for element in carsArray {
            var i = 0
            if detailCar == element {
                managedContext.delete(element)
                do {
                    try managedContext.save()
                    carsArray.remove(at: i)
                } catch {
                    print("Error deleting from coreData:", error.localizedDescription)
                }
            }
            i += 1
        }
 
        // Edit data in core data
        
        let newCar = NSEntityDescription.insertNewObject(forEntityName: "Cars", into: managedContext)
        if let image = detailCarImage.image?.pngData() as NSData? {
            newCar.setValue(image, forKey: "image")
        }
        newCar.setValue(detailManufacturerTF.text ?? "", forKey: "manufacturer")
        newCar.setValue(detailModelTF.text ?? "", forKey: "model")
        newCar.setValue(detailCarYearTF.text ?? "", forKey: "carYear")
        newCar.setValue(detailPriceTF.text ?? "", forKey: "price")

        do {
            try managedContext.save()
            print("Data saved")
        } catch {
            print("Failed to save data: " + error.localizedDescription)
        }
        
        detailManufacturerTF.isEnabled = false
        detailModelTF.isEnabled = false
        detailCarYearTF.isEnabled = false
        detailPriceTF.isEnabled = false
    }
    
    var imageFromMain = UIImage()
    var manufacturerFromMaim = String()
    var modelFromMaim = String()
    var caryearFromMaim = String()
    var priceFromMaim = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        detailCarImage.layer.borderWidth = 1
        detailCarImage.layer.borderColor = (UIColor.blue).cgColor
        
        // Data from View Controller
        
        detailCarImage.image = imageFromMain
        detailManufacturerTF.text = manufacturerFromMaim
        detailModelTF.text = modelFromMaim
        detailCarYearTF.text = caryearFromMaim
        detailPriceTF.text = priceFromMaim
        
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
