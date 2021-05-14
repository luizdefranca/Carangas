//  CarViewController.swift
//  Carangas

import UIKit
import WebKit

class CarViewController: UIViewController {

    // MARK: - Proprieties
    var car: Car!

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = "\(car.price)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let vc = segue.destination as? AddEditViewController
           vc?.car = car
       }

    

}
