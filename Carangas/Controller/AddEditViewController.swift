//  AddEditViewController.swift
//  Carangas
//

import UIKit

enum CarOperationAction {
    case add_car
    case edit_car
    case get_brands
}

class AddEditViewController: UIViewController {

    //MARK: - Proprieties
    var car: Car!
    var brands: [Brand] = []
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self

        return picker
    } ()

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
        loadBrands()
        addToolBar()

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

        car.price = Double(tfPrice.text!) ?? 0.0
        car.gasType = scGasType.selectedSegmentIndex

        if car._id == nil {
            // new car
            Rest.save(car: car) { success in
                print("Car saved: \(success)")
                self.goBack()
            }
        } else {
            // 2 - edit current car
            Rest.update(car: car) { success in
                print("Car updated: \(success)")
                self.goBack()
            }

        }
//
//        Rest.save(car: car) { (success) in
//            self.goBack()
//        }
    }

    @objc fileprivate func cancel() {
        tfBrand.resignFirstResponder()
    }

    @objc fileprivate func done() {
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].fipeName
        cancel()
    }

    fileprivate func addToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btSpace, btDone]

        tfBrand.inputAccessoryView = toolbar
        tfBrand.inputView = pickerView
    }

    fileprivate func loadBrands() {

        Rest.loadBrands { brands in
            guard let brands = brands else {return}

            // ascending order
            self.brands = brands.sorted(by: {$0.fipeName < $1.fipeName})

            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        } onError: { error in

            print("\(error.description) \nfile: \(#file) - function: \(#function) - line: \(#line)")
        }

    }
    fileprivate func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
} //End AddEditViewController

//MARK: - Extensions
extension AddEditViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let brand = brands[row]
        return brand.fipeName
    }
}

extension AddEditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  brands.count
    }

}

