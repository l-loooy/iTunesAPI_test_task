//
//  RegistrationViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//




import UIKit

private struct Constants {
    static var phoneCharsMaxCount = 18
}

final class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            allowsOnlyEnglishInput(nameTextField)
        }
    }
    
    @IBOutlet weak var secondNameTextField: UITextField! {
        didSet {
            allowsOnlyEnglishInput(secondNameTextField)
        }
    }
    
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            allowsOnlyEnglishInput(emailTextField)
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //имеют два состояния: required field и wrong input
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    private let datePicker = UIDatePicker()
    
    //textField text which should be validate
    private let nameValidType: String.ValidTypes = .name
    private let secondNameValidType: String.ValidTypes = .name
    private let emailValidType: String.ValidTypes = .email
    private let passwordValidType: String.ValidTypes = .password
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupPhoneTextField()
        setupDelegate()
    }
    
    private func setupPhoneTextField() {
        phoneTextField.keyboardType = .decimalPad
    }

    private func setTextField(textField: UITextField,
                              label: UILabel,
                              validType: String.ValidTypes,
                              validMessage: String,
                              errorMessage: String,
                              string: String,
                              range: NSRange) {
        let text = (textField.text ?? "") + string
        var result: String
        
        //when remove character
        if range.length == 1 {
            let startText = text.startIndex
            let endText = text.index(startText, offsetBy: text.count - 1)
            result = String(text[startText..<endText])
        } else {
            result = text
        }
        textField.text = result
        
        //check whole field, if want to check each characterIsValid, should check string parametr
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .systemGreen
        } else {
            label.text = errorMessage
            label.textColor = .systemRed
        }
    }
    
    private func setPhoneTextFieldMask(textField: UITextField,
                                       mask: String,
                                       string: String,
                                       range: NSRange) -> String {
        let text = textField.text ?? ""
        
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
            
            if result.count == Constants.phoneCharsMaxCount {
                phoneLabel.text = "Phone is valid"
                phoneLabel.textColor = .systemGreen
            } else {
                phoneLabel.text = "Pnone isn't valid "
                phoneLabel.textColor = .systemRed
            }
        }
        return result
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        //check all textFields, if valid, user can signUp
        
        let nameText = nameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let birthText = birthTextField.text ?? ""
        let phoneText = phoneTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        if nameText.isValid(validType: nameValidType)
            && secondNameText.isValid(validType: secondNameValidType)
            && !birthText.isEmpty
            && phoneText.count == Constants.phoneCharsMaxCount
            && emailText.isValid(validType: emailValidType)
            && passwordText.isValid(validType: passwordValidType) {
            
            UserDataStorage.shared.saveUserData(name: nameText,
                                                secondName: secondNameText,
                                                birth: datePicker.date,
                                                phone: phoneText,
                                                email: emailText,
                                                password: passwordText)
            showAlert(title: "Success registration",
                      message: "Now you can Sign In",
                      style: .alert,
                      formIsValid: true)
        } else {
            showAlert(title: "Error registration",
                      message: "All fields should be filled correctly",
                      style: .alert,
                      formIsValid: false)
        }
    }
}


//MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        birthTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        
        switch textField {
        case nameTextField:
            setTextField(textField: textField,
                         label: nameLabel,
                         validType: nameValidType,
                         validMessage: "Name is valid",
                         errorMessage: "Only A-Z character, minimum 1 character",
                         string: string,
                         range: range)
            
        case secondNameTextField:
            setTextField(textField: textField,
                         label: secondNameLabel,
                         validType: secondNameValidType,
                         validMessage: "Second name is valid",
                         errorMessage: "Only A-Z character, minimum 1 character",
                         string: string,
                         range: range)
            
        case phoneTextField:
            phoneTextField.text = setPhoneTextFieldMask(textField: phoneTextField,
                                                        mask: "+X (XXX) XXX-XX-XX",
                                                        string: string,
                                                        range: range)
            
        case emailTextField:
            setTextField(textField: textField,
                         label: emailLabel,
                         validType: emailValidType,
                         validMessage: "Email is valid",
                         errorMessage: "Wrong e-mail format",
                         string: string,
                         range: range)
            
        case passwordTextField:
            setTextField(textField: textField,
                         label: passwordLabel,
                         validType: passwordValidType,
                         validMessage: "Password is valid",
                         errorMessage: "a-zA-Z, minimum 1 digit",
                         string: string,
                         range: range)
        default:
            break
        }
        return false
    }
    
    private func setupDelegate() {
        nameTextField.delegate = self
        secondNameTextField.delegate = self
        birthTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func allowsOnlyEnglishInput(_ textField: UITextField) {
        textField.keyboardType = .asciiCapable
    }
}


//MARK: - DatePickerSettings
extension RegistrationViewController {
    private func setupDatePicker() {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        //set doneButton on the right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: self,
                                        action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        birthTextField.inputAccessoryView = toolbar
        birthTextField.inputView = datePicker
        setAgesLimits()
    }
    
    @objc func doneButtonPressed() {
        getDateFromPicker()
        self.view.endEditing(true)
        
        if birthTextField.text != "" {
            birthLabel.text = "Age is valid"
            birthLabel.textColor = .systemGreen
        } else {
            birthLabel.text = "Age isn't valid"
            birthLabel.textColor = .systemRed
        }
    }
    
    private func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        self.birthTextField.text = formatter.string(from: datePicker.date)
    }
    
    private func setAgesLimits() {
        //set age limits from 18...100
        let maxAge = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let minAge = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.maximumDate = maxAge
        datePicker.minimumDate = minAge
    }
}


//MARK: - AlertController
extension RegistrationViewController {
    private func showAlert(title: String,
                           message: String,
                           style: UIAlertController.Style,
                           formIsValid: Bool) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okActionButton = UIAlertAction(title: "Ok", style: .default) { action in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        if formIsValid == true {
            alertController.addAction(okActionButton)
        } else {
            alertController.addAction(cancelActionButton)
        }
        present(alertController, animated: true)
    }
}
