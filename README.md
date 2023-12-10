# <div align="center">☎️ Flutter Chat App ☎️</div>


## 🚀 Getting Started

- A full-fledged Flutter Chat App powered by Firebase. This app allows users to engage in real-time chat conversations, send messages, and connect with others seamlessly. The integration with Firebase provides a scalable backend for managing user authentication, real-time database, and cloud messaging.


## 🎲 Features

- **Firebase Authentication:** Secure user authentication using Firebase Authentication services.

- **Real-time Messaging:** Real-time chat functionality for instant communication between users.

- **Cloud Firestore Database:** Firebase Cloud Firestore for efficient and scalable data storage.

- **User Presence:** Track and display the online/offline status of users in real-time.

- **Image Sharing:** Share images seamlessly within the chat interface.


## ⚙️ Customization

- Customize the appearance and behavior of the clipboard according to your requirements:

**AuthService:**
```dart
class AuthService extends ChangeNotifier {
  // MARK: - Instances.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // MARK: - Sign In Method.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // MARK: - Create new document for the user in user collection.
      _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("SignIn Error:$e");
      throw Exception(e.code);
    }
  }

  // MARK: - Sign Up Method.
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // MARK: - Create new document for the user in user collection.
      _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("SignUp Error:$e");
      throw Exception(e.code);
    }
  }

  // MARK: - Sign Out Method.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
```

## 📱 UI

https://github.com/Shalaby-VBS/Flutter_Chat_App/assets/149938388/9ebc67c7-72a9-4fe7-9519-7f80dff59618

## 🛠 Dependencies

```yaml
  cupertino_icons: ^1.0.2
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  provider: ^6.1.1
  cloud_firestore: ^4.13.3
```

## 🫴 Contributing

- Contributions are welcome 💜
- If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## 💳 License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/Shalaby-VBS/Flutter_Chat_App)
- This package is distributed under the MIT License. Feel free to use and modify it according to your project requirements.

## 🤝 Contact With Me

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ahmed-shalaby-21196521b/) 
[![Gmail](https://img.shields.io/badge/Gmail-333333?style=for-the-badge&logo=gmail&logoColor=red)](https://www.shalaby.vbs@gmail.com)
[![Facebook](https://img.shields.io/badge/Facebook-0077B5?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/profile.php?id=100093012790432&mibextid=hIlR13)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/sh4l4by/)

</div>

## 💖 Support

- If you find this tutorial useful or learned something from this code, consider show some ❤️ by starring this repo.
