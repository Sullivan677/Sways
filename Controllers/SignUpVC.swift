import UIKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import AVKit
import AVFoundation

class SignUpVC: UIViewController {
    
    let videoLayer = UIView()
    let titleText = UILabel()
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .whiteOutline)
    let db = Firestore.firestore()
    let players = AVPlayer()
        
    override func loadView() {
        super.loadView()
        setupVideoBck()
        setupAppleButton()
        setupTitle()
        playVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.players.pause()
        print("*** Video paused.")
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "sways_Intro", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        player.isMuted = true
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            player.seek(to: CMTime.zero)
            player.play()
        }
        videoLayer.bringSubviewToFront(appleButton)
    }
    
    func setupVideoBck() {
        view.addSubview(videoLayer)
        videoLayer.translatesAutoresizingMaskIntoConstraints = false
        videoLayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        videoLayer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        videoLayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        videoLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupTitle() {
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.textAlignment = .center
        titleText.text = NSLocalizedString("Unlimited Yoga & Fitness Classes - Sign up to discover", comment: "")
        titleText.font = .systemFont(ofSize: 24, weight: .bold)
        titleText.textColor = .white
        titleText.layer.shadowColor = UIColor.darkGray.cgColor
        titleText.layer.shadowRadius = 2.0
        titleText.layer.shadowOpacity = 1.0
        titleText.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        titleText.layer.masksToBounds = false
        titleText.numberOfLines = 0;
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleText.bottomAnchor.constraint(equalTo: appleButton.topAnchor, constant: -15).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }

    func setupAppleButton() {
        view.addSubview(appleButton)
        appleButton.cornerRadius = 18
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
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
