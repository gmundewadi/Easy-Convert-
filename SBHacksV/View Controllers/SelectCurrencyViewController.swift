//
//  SelectCurrencyViewController.swift
//  Text Recognition Currency Exchange
//
//  Created by 王传正 on 2018/2/17.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit

protocol SelectCurrencyViewControllerDelegate: class {
    func setCurrency(code: String)
}

class SelectCurrencyViewController: UITableViewController {
    
    private let currency = Currency()
    
    weak var delegate: SelectCurrencyViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyItem", for: indexPath)
        let flagImageView = cell.viewWithTag(1000) as! UIImageView
        let codeLabel = cell.viewWithTag(1001) as! UILabel
        let nameLabel = cell.viewWithTag(1002) as! UILabel
        
        let code = currency.names.keys.sorted()[indexPath.row]
        flagImageView.image = UIImage(named: code)
        codeLabel.text = code
        nameLabel.text = currency.names[code]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let codeLabel = cell.viewWithTag(1001) as! UILabel
            if currency.exchangeRates != nil {
                self.delegate?.setCurrency(code: codeLabel.text!)
                dismiss(animated: true, completion: nil)
            } else {
                showUpdateErrorAlert()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showUpdateErrorAlert() {
        let alert = UIAlertController(title: "Wait", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
