//
//  ViewController.swift
//  Buy a Car
//
//  Created by Sasha Dubikovskaya on 03.05.2019.
//  Copyright © 2019 Buy a Car. All rights reserved.
//

import UIKit
import CoreData

var carsArray = [Cars]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createPopoverVC))
        tapGesture.numberOfTapsRequired = 1
        manufactureButton.addGestureRecognizer(tapGesture)
        modelButton.addGestureRecognizer(tapGesture)
        priceButton.addGestureRecognizer(tapGesture)
    }
    
    // Popover view controller
    
    @objc func createPopoverVC () -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(withIdentifier: "PopVC") as! PopoverTableViewController
        popVC.modalPresentationStyle = .popover
        return popVC
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var manufactureButton: UIButton!
    
    @IBAction func manufacture(_ sender: Any) {
        
        let manufacturerPopVC = createPopoverVC()
        let popoverVC = manufacturerPopVC.popoverPresentationController
        popoverVC?.delegate = self
        popoverVC?.sourceView = manufactureButton
        popoverVC?.sourceRect = CGRect(x: manufactureButton.bounds.midX, y: manufactureButton.bounds.midY, width: 0, height: 0)
        
        self.navigationController?.present(manufacturerPopVC, animated: true)
    }
    
    @IBOutlet weak var modelButton: UIButton!
    
    @IBAction func model(_ sender: Any) {
        
        let modelPopVC = createPopoverVC()
        let popoverVC = modelPopVC.popoverPresentationController
        popoverVC?.delegate = self
        popoverVC?.sourceView = modelButton
        popoverVC?.sourceRect = CGRect(x: 200, y: 50, width: 0, height: 0)
        
        self.navigationController?.present(modelPopVC, animated: true)
    }
    
    @IBOutlet weak var priceButton: UIButton!
    
    @IBAction func price(_ sender: Any) {
        
        let pricePopVC = createPopoverVC()
        let popoverVC = pricePopVC.popoverPresentationController
        popoverVC?.delegate = self
        popoverVC?.sourceView = priceButton
        popoverVC?.sourceRect = CGRect(x: priceButton.bounds.midX, y: priceButton.bounds.midY, width: 0, height: 0)
        
        //pricePopVC.preferredContentSize = CGSize(width: 200, height: 250)
        
        self.navigationController?.present(pricePopVC, animated: true)
        
    }
    
    
    let secondAppdelegate = appDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableView.automaticDimension
        
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData { (done) in
            if done {
                print("Data is ready to be used in table view")
                print(carsArray)
            }
        }
        tableView.reloadData()
    }
    
    // Get data from core data
    
    func fetchData (comletion: (_ compete: Bool) -> ()) {
        let secondAppdelegate = appDelegate
        let managedContext = secondAppdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cars")
        
        request.returnsObjectsAsFaults = false
        
        do {
            carsArray = try managedContext.fetch(request) as! [Cars]
            print("Data fetched")
        } catch {
            print("Unable to fetch data: " + error.localizedDescription)
        }
    }
    
    // Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CarTableViewCell
        let car = carsArray[indexPath.row]
        if let image = car.image {
            cell.carImage.image = UIImage(data: image)!
        }
        cell.manufactureLabel.text = car.manufacturer
        cell.modelLabel.text = car.model
        cell.caryearLabel.text = car.carYear
        cell.priceLabel.text = car.price
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedContext = secondAppdelegate.persistentContainer.viewContext
            managedContext.delete(carsArray[indexPath.row])
            
            do {
                try managedContext.save()
                carsArray.remove(at: indexPath.row)
                tableView.reloadData()
            } catch {
                print("Error deleting from coreData:", error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        
        let car = carsArray[indexPath.row]
        vc.detailCar = car
        if let image = car.image {
            vc.imageFromMain = UIImage(data: image)!
        }
        vc.manufacturerFromMaim = car.manufacturer ?? ""
        vc.modelFromMaim = car.model ?? ""
        vc.caryearFromMaim = car.carYear ?? ""
        vc.priceFromMaim = car.price ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    // Popover view controller present size

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
