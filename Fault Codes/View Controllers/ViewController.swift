//
//  ViewController.swift
//  Fault Codes
//
//  Created by Andrei Costin on 6/19/19.
//  Copyright © 2019 Andrei Costin. All rights reserved.
//

import UIKit

var moCo = [String]()

var selectedController = ""
var row = 0
var faultName = ""
var faultCause = ""
var isFull = false
var isRun = false
var faultCode = "";

struct mc: Decodable {
    let NAME:String
}


struct faults: Decodable {
    let NAME: String
    let FAULT_CODE: String
    let FAULT: String
    let CAUSE: String
    let LINK: String
    let PIN: String
}
class ViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var mcPicker: UIPickerView! // Motor Controller picker
    //PickerView Initializers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moCo.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return moCo[row]
    }
    
    
    @IBOutlet weak var FCin: UITextField! //Text field for fault code input
    
    //Submit button
    @IBAction func submit(_ sender: Any) {
        row = self.mcPicker.selectedRow(inComponent: 0)
        selectedController = moCo[row]
        faultCode = FCin.text!
        getData()
    }
    
    // View Did Load
    override func viewDidLoad() {
        
        //Keyboard scroll
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //super
        super.viewDidLoad()
        //hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        let width = (self.view.frame.size.width) //some width
        let height = self.view.frame.size.height + 100
        scroll.contentSize = CGSize(width: width, height: height)

        if(!isRun){
            //Get motor controllers from API to fill pickerView
            getDropDownData();
            isRun = true
        }
        
        
        //populate picker if data exists
        if(mcPicker != nil)
        {
            mcPicker.delegate = self
            mcPicker.dataSource = self

        }
        
        mcPicker.selectRow(row, inComponent: 0, animated:false)
    }
    
    
    /*
     * Function:  getDropDownData
     * --------------------
     * Gets data from API to populate the picker with motor controller data
     */

    func getDropDownData() {

        //API address
        let jsonUrlString = "https://faultcodes.curtisinstruments.com/dropDownAPI.php"
        //URL def
        guard let url = URL(string: jsonUrlString) else { return }
        
        //start URL session
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            //get DATA
            do {
                var i = 0; //counter
                let motCons = try decoder.decode([mc].self, from: data)
                let x = motCons.count
                //Fill array with output from API
                while(i < x){
                    if(isFull)
                    {
                        moCo[i] = motCons[i].NAME
                    }
                    else{
                        moCo.insert(motCons[i].NAME, at: i);
                    }
                    i+=1
                }
                isFull = true;
                //Reload picker
                DispatchQueue.main.async {
                    self.mcPicker?.reloadAllComponents()
                }
                //catch error
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()

    }
    
    /*
     * Function:  getData
     * --------------------
     * Gets data from API to for selected motor controller and fault code
     */
    
    func getData() {
        
        if(selectedController != "" && faultCode != "")
        {
        //defines API URL with varibales
        let jsonUrlString = "https://faultcodes.curtisinstruments.com/service.php?mc=" + selectedController + "&fc=" + faultCode
       
        guard let url = URL(string: jsonUrlString) else { return }
        
        //start URL session
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            //gets data
            do {
                let fault = try decoder.decode([faults].self, from: data)
                
                //populates struct with data recieved
                if(fault.count > 0){
                    selectedController = fault[0].NAME
                    faultName = (fault[0].FAULT)
                    faultCause = (fault[0].CAUSE)
                    
                    faultName = faultName.replacingOccurrences(of: "<br/>", with: "\n") //replaces HTML line breaks with swift line breaks
                    faultCause = faultCause.replacingOccurrences(of: "<br/>", with: "\n") //replaces HTML line breaks with swift line breaks
                }
                else{
                    //if No data, fill with nil
                    selectedController = ""
                    faultCode = ""
                    faultName = ""
                    faultCause = ""
                }
                //after data is populated, change viewController in thread 1
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "showFault", sender: nil)
                }

            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
        }
        else {
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "showFault", sender: nil)
            }
        }

    }
    
    
    
    
    
    
    /*
     * Function:  keyboard
     * --------------------
     * keyboard helper methods to scroll window when keyboard opens
     */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= ((keyboardSize.height)/1.5)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

