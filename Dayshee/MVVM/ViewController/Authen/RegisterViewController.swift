//
//  RegisterViewController.swift
//  Knowitall
//
//  Created by thanhnguyen on 4/1/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: IBOUTLETS
    
   
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfCryptoAccount: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfFullName: UITextField!
    @IBOutlet weak var imgHiddenView: UIImageView!
    var viewModel = AuthenViewModel()
    //MARK: OTHER VARIABLES
    
    
    //MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupVar()
        setupUI()
        callAPI()
    }
    
    //MARK: - SETUP UI & VAR
    func setupVar() {
        
    }
    
    func setupUI() {
        
    }
    
    //MARK - CALL API
    func callAPI() {
        
        fillData()
    }
    
    
    func regis() {
        self.view.endEditing(true)
//        viewModel.name = tfFullName.text ?? ""
//        viewModel.email = tfEmail.text ?? ""
//        viewModel.password = tfPassword.text ?? ""
//        viewModel.crypto_account = tfCryptoAccount.text ?? ""
//        viewModel.register { (success, data, message) in
//            HelperAlert.showAlerWithTitle("", message: message, cancelTitle: "OK", { () -> (Void) in
//                //
//                if success {
//                    self.navigationController?.popViewController()
//                }
//            }, self)
//        }
    }
    
    //MARK: - FILL DATA
    func fillData() {
        
    }
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func hiddenPassword(_ sender: Any) {
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        imgHiddenView.image = #imageLiteral(resourceName: "Eye")
    }
    @IBAction func btnRegister(_ sender: Any) {
        
        self.regis()
    }
    
}


