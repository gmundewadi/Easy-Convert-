
//  Currency.swift
//  OCRCurrencyConverter
//
//  Created by 王传正 on 2019/1/11.
//  Copyright © 2019 zcgr. All rights reserved.
//

import Foundation

typealias Rate = [String : Double]

protocol CurrencyDelegate: class {
    
}

class Currency {
    
    public static let sharedCurr = Currency()
    
    public var storedHome: String = "";
    public var storedGuest: String = "";
    
    public var changed: Bool = false;
    public var isHome :Bool = true;
    public var currHomeCode: String = "USD";
    public var currGuestCode: String = "CNY";
    
    func updateCurrCode(isH: Bool, currC: String, currGC: String) {
        isHome = isH;
        currHomeCode = currC;
        currGuestCode = currGC;
    }
    
    
    var rates: Rate? // [<Currency Code> : <1 USD Value>]
    var names: [String: String] {
        get {
            return [
                "AUD": "Australian Dollar",
                "BGN": "Bulgarian Lev",
                "BRL": "Brazilian Real",
                "CAD": "Canadian Dollar",
                "CHF": "Swiss Franc",
                "CNY": "Chinese Yuan",
                "CZK": "Czech Koruna",
                "DKK": "Danish Krone",
                "EUR": "European Union Euro",
                "GBP": "British Pound Sterling",
                "HKD": "Hong Kong Dollar",
                "HRK": "Croatian Kuna",
                "HUF": "Hungarian Forint",
                "IDR": "Indonesian Rupiah",
                "ILS": "Israeli Shekel",
                "INR": "Indian Rupee",
                "ISK": "Icelandic Krona",
                "JPY": "Japanese Yen",
                "KRW": "South Korean Won",
                "MXN": "Mexican Peso",
                "MYR": "Malaysian Ringgit",
                "NOK": "Norwegian Krone",
                "NZD": "New Zealand Dollar",
                "PHP": "Philippine Piso",
                "PLN": "Polish Zloty",
                "RON": "Romanian Leu",
                "RUB": "Russian Rouble",
                "SEK": "Swedish Krona",
                "SGD": "Singapore Dollar",
                "THB": "Thai Baht",
                "TRY": "Turkish Lira",
                "USD": "United States Dollar",
                "ZAR": "South African Rand"
            ]
        }
    }
    private var updateDate: Date?
    private var lastCurrencies: [String]?
    
    weak var delegate: CurrencyDelegate?
    
    init() {
        load()
        if rates != nil {
            //delegate?.setRefreshDateText()
        } else {
            update()
        }
    }
    
    func convert(from: String, to: String, value: Double) -> Double {
        let fromValue = rates![from]!
        let toValue = rates![to]!
        let ratio = toValue / fromValue
        return ratio * value
    }
    
    func update() {
        let haveSavedRates = rates != nil
        getRates()
        if rates != nil {
            updateDate = Date()
            save()
        } else {
            if haveSavedRates {
                load() // error retrieving data, load old data if exists
            }
        }
        if lastCurrencies == nil {
            lastCurrencies = ["USD", "EUR"]
        }
    }
    
    func getRates() {
        //delegate?.startActivityIndicator()
        DispatchQueue.global().async {
            print("Started")
            let url = URL(string: "https://api.exchangeratesapi.io/latest?base=USD")!
            guard let json = try? String(contentsOf: url, encoding: .utf8) else { return }
            guard let data = json.data(using: .utf8, allowLossyConversion: false) else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            guard let result = jsonObject as? [String: Any] else { return }
            print(result)
            self.rates = (result["rates"] as! Rate)
            self.rates?["USD"] = 1.0
            //            print(self.rates ?? "Failed")
            //            DispatchQueue.main.async {
            //                self.delegate?.stopActivityIndicator()
            //            }
        }
    }
    
    func load() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = directory[0].appendingPathComponent("CurrencyConverter.plist")
        if let data = try? Data(contentsOf: filePath) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            rates = (unarchiver.decodeObject(forKey: "rates") as! Rate)
            updateDate = (unarchiver.decodeObject(forKey: "updateDate") as! Date)
            lastCurrencies = (unarchiver.decodeObject(forKey: "lastCurrencies") as! [String])
            unarchiver.finishDecoding()
        }
    }
    
    func save() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = directory[0].appendingPathComponent("CurrencyConverter.plist")
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(rates, forKey: "rates")
        archiver.encode(updateDate, forKey: "updateDate")
        archiver.encode(lastCurrencies, forKey: "lastCurrencies")
        archiver.finishEncoding()
        data.write(to: filePath, atomically: true)
    }
    
}
