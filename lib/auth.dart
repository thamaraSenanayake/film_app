import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';


class Authservice{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Stream<FirebaseUser> user;
  Stream<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  Authservice(){
    user = _firebaseAuth.onAuthStateChanged;
    profile = user.switchMap((FirebaseUser u){
      if( u != null){
        return _db.collection('user').document(u.uid).snapshots().map((event) => event.data);
      }else{
        return Stream.empty();
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async{
    loading.add(true);
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthResult authResult= await _firebaseAuth.signInWithCredential(
      GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken)
    );
    FirebaseUser user = authResult.user;
    updateuserData(user);
    loading.add(false);
    return user;
  }

  updateuserData(FirebaseUser user) async{
    DocumentReference reference = _db.collection('user').document(user.uid);

    return reference.setData({
      'uid':user.uid,
      'email':user.email,
      'photoUrl':user.photoUrl,
      'displayName':user.displayName,
      'lastSeen':DateTime.now()
    },merge:  true);
  }

  singOut(){
    _firebaseAuth.signOut();
  }

}

final Authservice authservice = Authservice();