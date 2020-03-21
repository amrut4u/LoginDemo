//
//  LoginViewController.swift
//  LoginDemo
//
//  Created by Apple on 21/03/20.
//  Copyright © 2020 Amrut Waghmare. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtFieldId:UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnLogin:UIButton!
    var token:String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "Token")
        }
        get {
            UserDefaults.standard.value(forKey: "Token") as? String
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if token != nil && token != "" {
            self.navigateToDashboard()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtonUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - @IBACtions
    @IBAction func actionLogin(_ sender: Any) {
        self.validateLogin(email: txtFieldId.text ?? "", password: txtFieldPassword.text ?? "")
    }
    
    func setupButtonUI(){
        btnLogin.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnLogin.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnLogin.layer.shadowOpacity = 1.0
        btnLogin.layer.shadowRadius = 0.0
        btnLogin.layer.masksToBounds = false
        btnLogin.layer.cornerRadius = 4.0
    }
    func navigateToDashboard(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- API Calling Function
    
    func validateLogin(email:String, password:String){
        self.activityIndicator.startAnimating()
        let url = URL(string: "https://reqres.in/api/login")!
        var request = URLRequest(url: url)
        request.setValue("X-Requested-With", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let data = data else { print(error?.localizedDescription)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? Dictionary<String,AnyObject> {
                    print(json)
                    if let token = json["token"] as? String {
                        self.token = token
                        DispatchQueue.main.async {
                            self.navigateToDashboard()
                        }
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

