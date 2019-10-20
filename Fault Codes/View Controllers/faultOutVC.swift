//
//  faultOutVC.swift
//  Fault Codes
//
//  Created by Andrei Costin on 6/20/19.
//  Copyright © 2019 Andrei Costin. All rights reserved.
//

import Foundation
import UIKit
var textToShare = ""
var subjectToShare = ""


class faultOutVC: UIViewController {
    
    //View Controller elements definitions
    @IBOutlet var contOut: UILabel!
    @IBOutlet var fcOut: UILabel!
    @IBOutlet weak var faultNameOut: UITextView!
    @IBOutlet weak var faultCauseOut: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func share(_ sender: Any) {
        
        
        
            let objectsToShare = [textToShare] as [Any]
        let avc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        //Apps to be excluded sharing to
        avc.excludedActivityTypes = [
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.addToReadingList
        ]
        // Check if user is on iPad and present popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            if avc.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                avc.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
            }
        }
        // Present share activityView on regular iPhone
        avc.setValue(subjectToShare, forKey: "Subject")
        self.present(avc, animated: true, completion: nil)
    
        textToShare = ""
        }
    
    
    
    
    override func viewDidLoad() {
        printOut() //function to output data to iOS
        super.viewDidLoad()
        let blueBorder = UIColor.init(red:0.02, green:0.48, blue:0.74, alpha:1.0) //blue border color definition
        let greenBorder = UIColor.init(red:0.00, green:0.69, blue:0.58, alpha:1.0) //green border color definition
        //set border for green(Fault Name)
        self.faultNameOut.layer.borderColor = greenBorder.cgColor;
        self.faultNameOut.layer.borderWidth = 1.0;
        self.faultNameOut.layer.cornerRadius = 8;
        
        //set border for blue(Fault Cause)
        self.faultCauseOut.layer.borderColor = blueBorder.cgColor;
        self.faultCauseOut.layer.borderWidth = 1.0;
        self.faultCauseOut.layer.cornerRadius = 8;
        
        let width = (self.view.frame.size.width) //some width
        let height = self.view.frame.size.height + 100
        scrollView.contentSize = CGSize(width: width, height: height)
    }
    
    
    /*
     * Function:  printOut()
     * --------------------
     * Function to output desired data to iOS
     */
    func printOut() {
        //if textField isnt nil (to avoid thread error 1)
        if(contOut != nil)
        {
            //Check for data in faultName (if no data, invalid controller/faultCode entered)
            //if data, print out all data
            if(faultName != "")
            {
                self.contOut.text = "Controller: " + selectedController;
                self.fcOut.text = "Fault Code: " + faultCode
                self.faultNameOut.text = "Fault Name:\n " + faultName + "\n"
                self.faultCauseOut.text = "Fault Cause:" + faultCause + "\n"
                textToShare = "Controller: " + selectedController + "\nFault Code: " + faultCode + "\nFaultName: " +  faultName + "\nFault Cause: " + faultCause
                subjectToShare = "Fault Code: " + faultCode + " For Controller: " + selectedController
            }
            else {
                //else no data, print error, prompt to go back
                self.contOut.text = "Controller: " + selectedController
                self.fcOut.text = "Fault Code: " + faultCode
                self.faultNameOut.text = "PLEASE PRESS Done AND TRY AGAIN" + "\n"
                self.faultCauseOut.text = "ENTER A VALID FAULT CODE FOR SELECTED CONTROLLER" + "\n"
                textToShare = "Invalid Fault Code, Try Again"
                subjectToShare = "Invalud Fault Code, Try Again"
            }
            //if motor controller is there, but no fault code, error, try again
            if(faultCode == "")
            {
                self.contOut.text = "Controller: " + selectedController
                self.fcOut.text = "Fault Code: " + faultCode
                self.faultNameOut.text = "PLEASE PRESS Done AND TRY AGAIN" + "\n"
                self.faultCauseOut.text = "ENTER A VALID FAULT CODE FOR SELECTED CONTROLLER" + "\n"
                textToShare = "Invalid Fault Code, Try Again"
                subjectToShare = "Invalud Fault Code, Try Again"


            }
           
        }

    }
    
   
}




    



