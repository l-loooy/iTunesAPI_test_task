//
//  ViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

//Тестовое задание
//
//Позиция: iOS Developer
//Язык: Swift
//
//Разработать приложение, которое включает в себя:
//    •    Экран регистрации пользователя с валидацией полей.
//    •    Имя (только на английском)
//    •    Фамилия (только на английском)
//    •    Возраст (с возможностью выбора через календарь и не младше 18 лет)
//    •    Номер телефона (должен вводиться автоматически в формате + 7 (***) ***-**-**)
//    •    E-mail (проверка на корректность введенного email)
//    •    Пароль (не менее 6 символов, обязательно должны быть цифра, буква нижнего регистра, буква верхнего регистра)
//
//Все поля должны быть обязательны для заполнения и проверены на валидность.
//
//    •    Экран авторизации пользователя.
//    •    Поля e-mail и пароль;
//    •    Проверка на наличие пользователя в «базе»;
//    •    Переход на следующий экран только для авторизованного пользователя.
//
//    •    Экран поиска музыкальных альбомов + Данные пользователя с экрана регистрации.
//    •    search bar и табличное представление найденных альбомов;
//    •    альбомы должны быть отсортированы по алфавиту;
//    •    обязательно для отображения:
//    •    лого альбома
//    •    название альбома
//    •    название группы
//    •    количество песен;
//    •    по нажатию на альбом открывается экран альбома.
//    •    Искать можно и на русском и на английском.
//
//    •    Экран альбома.
//    •    Обязательно для отображения:
//    •    лого альбома
//    •    название альбома
//    •    название группы
//    •    год выхода альбома
//    •    список песен
//
//
//Требования:
//    •    Xcode 11+, Swift 5+, iOS 14+, не использовать SwiftUI;
//    •    Можно использовать любые сторонние библиотеки;
//    •    Дизайн должен соответствовать Human Interface Guidelines;
//    •    Результат можно прислать ссылкой на гитхаб или в архиве;
//    •    Проект должен устанавливаться без дополнительных действий, кроме установки зависимостей (pod install), и ошибок.
//    •    Данные пользователя не должны передаваться между экранами, а должны сохранятся в локальную базу данных устройства и извлекаться из нее.
//    •    Возможные ошибки должны быть обработаны.
//
//API: https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1



import UIKit

class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = findUserInUserDataStorage(email: email)
        
        if user == nil {
            showAlert()
        } else if user?.password == password {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let albumVC = storyboard.instantiateViewController(withIdentifier: "AlbumViewController")
            self.navigationController?.pushViewController(albumVC, animated: true)
            
            guard let activeUser = user else {
                return
            }
            UserDataStorage.shared.saveActiveUser(activeUser)
        } else {
            showAlert()
        }
    }
    
    //1.get user with specified email
    //2.check the password associated with the mail
    //3.compare the password from the database with the one entered in the textfield
    private func findUserInUserDataStorage(email: String) -> UserModel? {
        
        let usersDataStorage = UserDataStorage.shared.users
        for user in usersDataStorage {
            if user.email == email {
                return user
            }
        }
        return nil
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "User Not Found", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    
    private func setUpDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
}


