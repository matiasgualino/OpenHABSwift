//
//  LoginViewController.swift
//  GLAD
//
//  Created by Matias Gualino on 29/8/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

	let LOGIN_URL = "http://200.58.105.50:3000/api/remote_address"
	
	@IBOutlet weak var btnLogin: UIButton!
	
	@IBOutlet weak var usernameTextField : UITextField!
	@IBOutlet weak var passwordTextField : UITextField!
	@IBOutlet weak var showHidePasswordButton : UIButton!
	
	init() {
		super.init(nibName: "LoginViewController", bundle: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		var titleImage : UIImageView = UIImageView(frame: CGRectMake((self.navigationController!.navigationBar.frame.size.width / 2)
			- (100 / 2), 0, 44, 30))
		titleImage.image = UIImage(named:"glad-bird")
		titleImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.navigationItem.titleView = titleImage
		
		self.btnLogin.layer.cornerRadius = 4
		self.btnLogin.setTitle("Ingresar", forState: UIControlState.Normal)
		
		self.usernameTextField.placeholder = "Nombre de usuario"
		self.passwordTextField.placeholder = "Password"
		self.passwordTextField.secureTextEntry = true
		
		showHidePasswordButton.hidden = false
		showHidePasswordButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12.0)
		showHidePasswordButton.setTitle("MOSTRAR", forState: UIControlState.Normal)
		showHidePasswordButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
		showHidePasswordButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
		showHidePasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
		showHidePasswordButton.addTarget(self, action: Selector("onShowHidePasswordButtonTouch:"), forControlEvents: UIControlEvents.TouchUpInside)
		
		let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 20, self.usernameTextField.frame.height))
		self.usernameTextField.leftView = paddingViewUsername
		self.usernameTextField.leftViewMode = UITextFieldViewMode.Always
		self.usernameTextField.autocorrectionType = UITextAutocorrectionType.No
		self.usernameTextField.autoresizingMask = UIViewAutoresizing.FlexibleWidth
		self.usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
		self.usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		
		let paddingViewPassword = UIView(frame: CGRectMake(0, 0, 20, self.passwordTextField.frame.height))
		self.passwordTextField.leftView = paddingViewPassword
		self.passwordTextField.leftViewMode = UITextFieldViewMode.Always
		self.passwordTextField.autocorrectionType = UITextAutocorrectionType.No
		self.passwordTextField.autoresizingMask = UIViewAutoresizing.FlexibleWidth
		self.passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		
		self.usernameTextField.becomeFirstResponder()
		
		self.btnLogin.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
    }

	func onShowHidePasswordButtonTouch(sender: AnyObject) {
		self.passwordTextField.resignFirstResponder()
		self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry
		self.passwordTextField.becomeFirstResponder()
		
		if let showHideButton = self.passwordTextField.rightView as? UIButton {
			showHideButton.setTitle(self.passwordTextField.secureTextEntry ? "MOSTRAR":"OCULTAR", forState: UIControlState.Normal)
		}
	}
	
	func login() {
		var canContinue = true
		var error : String? = nil
		
		if self.usernameTextField.text == nil || self.usernameTextField.text == "" {
			error = "Debes ingresat tu usuario."
		}
		
		if self.passwordTextField.text == nil || self.passwordTextField.text == "" {
			error = "Debes ingresar tu clave."
		}
		
		if error != nil {
			self.showErrorLoginAlert(error!)
		} else {
			var loginRequest : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: LOGIN_URL)!)
			loginRequest.HTTPMethod = "GET"
			loginRequest.setAuthCredentials(self.usernameTextField.text, password: self.passwordTextField.text)
			loginRequest.setValue("application/json", forHTTPHeaderField: "Accept")
			
			Alamofire.request(loginRequest)
				.responseJSON { _, _, JSON, error in
					if error != nil {
						self.showErrorLoginAlert("Ocurrió un problema en el login. Por favor intenta nuevamente.")
					} else {
						NSUserDefaults.standardUserDefaults().setValue(self.usernameTextField.text, forKey: "username")
						NSUserDefaults.standardUserDefaults().setValue(self.passwordTextField.text, forKey: "password")
						NSUserDefaults.standardUserDefaults().setValue("https://" + (JSON!["address"] as? String)! + ":8443", forKey: "localUrl")
						NSUserDefaults.standardUserDefaults().setValue("https://" + (JSON!["address"] as? String)! + ":8443", forKey: "remoteUrl")
						NSUserDefaults.standardUserDefaults().synchronize()
						self.navigationController?.pushViewController(OpenHABViewController(), animated: true)
					}
			}
		}
	}
	
	private func showErrorLoginAlert(message: String) {
		let alert = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
		alert.show()
	}

}
