//
//  ChangeCurrenciesViewController.swift
//  
//
//  Created by Joey on 1/12/19.
//

import UIKit

class ChangeCurrenciesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // update whenever shows
    override func viewDidAppear(_ animated: Bool) {
        let shared = Currency.sharedCurr;
//        if(shared.currCode == "Default") {
//            self.homePicLayout.setImage(UIImage(named: "USD"), for: .normal)
//            self.homeLabel.text = "USD";
//            self.guestPicLayout.setImage(UIImage(named: "CNY"), for: .normal)
//            self.guestLabel.text = "CNY"
//        }
//        else


                self.homePicLayout.setImage(UIImage(named: shared.currHomeCode), for: .normal)
                self.homeLabel.text = shared.currHomeCode;
                

                // edit second pic
                self.guestPicLayout.setImage(UIImage(named: shared.currGuestCode), for: .normal)
                self.guestLabel.text = shared.currGuestCode

            

        
    }
    
    @IBOutlet weak var homePicLayout: UIButton!
    @IBOutlet weak var guestPicLayout: UIButton!
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var guestLabel: UILabel!
    @IBAction func test(_ sender: UIButton) {
        let vc : ChooseCurrenciesViewController! = storyboard?.instantiateViewController(withIdentifier: "editCurrencySBI") as? ChooseCurrenciesViewController
        
        // TODO: set group object here for data pass in
        //        do {
        vc.isHome = true;
        
        //        present(vc, animated: true, completion: nil);
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func guestFlag(_ sender: UIButton) {
        
        let vc : ChooseCurrenciesViewController! = storyboard?.instantiateViewController(withIdentifier: "editCurrencySBI") as? ChooseCurrenciesViewController
        
        // TODO: set group object here for data pass in
        //        do {
        vc.isHome = false;
        
        //        present(vc, animated: true, completion: nil);
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "DoneChooseCurrencySI", let createGroupVC = segue.destination as? ChooseCurrenciesViewController {
//
////            createGroupVC.completionHandler = { currCode, isHome  in
////
////                print("passing currCode back to the choose page")
////                // UI update, flag image, country name
////                if(isHome) {
////                    // edit first pic
////                    self.homePicLayout.setImage(UIImage(named: currCode!), for: .normal)
////                    self.homeLabel.text = currCode;
////
////                } else {
////                    // edit second pic
////                    self.guestPicLayout.setImage(UIImage(named: currCode!), for: .normal)
////                    self.guestLabel.text = currCode
////                }
////
////                // dismiss that stuff idk
////                self.dismiss(animated: true, completion: nil)
////            }
//
//        }
//    }

}
