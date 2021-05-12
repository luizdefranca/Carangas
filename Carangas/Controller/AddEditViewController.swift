//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    //MARK: - Proprieties
    var car: Car!

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    // MARK: - Lifecicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            // modo edicao
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }


    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {

        if car == nil {
            // adicionar carro novo
            car = Car()
        }

        car.name = (tfName?.text)!
        car.brand = (tfBrand?.text)!
        if tfPrice.text!.isEmpty {
            tfPrice.text = "0"
        }
        car.price = Double(tfPrice.text!)!
        car.gasType = scGasType.selectedSegmentIndex

        if car._id == nil {
            // new car
            Rest.save(car: car) { (success) in
                self.goBack()
            }
        } else {
            // 2 - edit current car
            Rest.update(car: car) { (success) in
                self.goBack()
            }

        }

        Rest.save(car: car) { (success) in
            self.goBack()
        }
    }

    

    func goBack() {

        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }

    }

    

    

}
