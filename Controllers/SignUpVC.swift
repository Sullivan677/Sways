import UIKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

class SignUpVC: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "yoga-facedown"))
    let bottomView = UIView()
    let titleText = UILabel()
    let subtitleText = UILabel()
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    let db = Firestore.firestore()
    
    override func loadView() {
        super.loadView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(dismissView))
        navigationItem.title = "Sign Up"
        setupImage()
        setupView()
        setupTitle()
        setupSubtitle()
        setupAppleButton()
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupImage() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
    }
    
    func setupView() {
        view.addSubview(bottomView)
        bottomView.backgroundColor = .systemBackground
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupTitle() {
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.textAlignment = .center
        titleText.text = "Livestream Workouts"
        titleText.font = .systemFont(ofSize: 26, weight: .bold)
        titleText.numberOfLines = 0;
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    func setupSubtitle() {
        view.addSubview(subtitleText)
        subtitleText.translatesAutoresizingMaskIntoConstraints = false
        subtitleText.textAlignment = .center
        subtitleText.font = .systemFont(ofSize: 20, weight: .regular)
        subtitleText.textColor = .lightGray
        subtitleText.numberOfLines = 0;
        subtitleText.text = "Join sports classes, led by the best trainers"
        subtitleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 5).isActive = true
        subtitleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subtitleText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    func setupAppleButton() {
        view.addSubview(appleButton)
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 224).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.topAnchor.constraint(equalTo: subtitleText.bottomAnchor, constant: 15).isActive = true
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    fileprivate var currentNonce: String?
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.dismiss(animated: true, completion: nil)
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                db.collection("User").document(uid).setData([
                    "email": email,
                    "displayName": displayName,
                    "uid": uid
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("the user has sign up or is logged in")
                         print("\(Auth.auth().currentUser)")
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension SignUpVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
