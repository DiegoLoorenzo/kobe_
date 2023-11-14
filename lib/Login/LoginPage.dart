import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kobe_flutter/CreateUserPage.dart';
import 'package:kobe_flutter/MyHomePage.dart';

class LoginPage extends StatefulWidget{

  @override
  State createState(){
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage>{
  late String email, password;
  final _formkey = GlobalKey<FormState>();
  String error='';

  @override
  void initState() {
    super.initState();
  }

///Almacenamiento de todos los Build y diseño de la interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Iniciar Sesión", style: TextStyle(color: Colors.black, fontSize: 24),),
          ),
          Offstage(
            offstage: error == '',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red, fontSize: 16),),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
            ),
            butonLogin(),
            nuevoAqui(),
            buildOrLine(),
            BotonGoogle(),
        ],
      ),
    );
  }


///// Boton de Entrar con Google
  Widget BotonGoogle(){
    return Column(
      children: [
        SignInButton(Buttons.Google, onPressed: ()async{
          await entrarConGoogle();
          if(FirebaseAuth.instance.currentUser != null){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage()),
                      (Route<dynamic> route) => false);
          }
        }),
      ],
      );
  }
///// Fin de Boton de Entrar con Google

///Accion del Future para logearnos con Google
  Future<UserCredential> entrarConGoogle() async {
    final GoogleSignInAccount? googleUser= await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? autentication = await googleUser?.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: autentication?.accessToken,
      idToken: autentication?.idToken
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }
///Fin de Accion del Future para logearnos con Google

///Boton de Linea
  Widget buildOrLine(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider()),
        Text("ó"),
        Expanded(child: Divider()),
      ],
    );
  }

//Boton de entrar a registrarse
  Widget nuevoAqui(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nuevo aqui"),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUserPage()));

        }, child: Text("Registrarse")),
      ],
    );
  }

///Boton de ir a formulario
  Widget formulario(){
    return Form(
      key: _formkey,
        child: Column(children: [
          buildEmail(),
          const Padding(padding: EdgeInsets.only(top: 12)),
          buildPassword()
    ],));
  }

//Campo de colocar email
  Widget buildEmail(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email" ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black)
        )
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
      email = value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

//Campo para Introducir Password
  Widget buildPassword(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black)
        )
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
      password = value!;
      },
    );
  }

//Boton para logearse
  Widget butonLogin(){
    return FractionallySizedBox(
      widthFactor: 0.6,
    child: ElevatedButton(
      onPressed: () async{

        if(_formkey.currentState!.validate()){
          _formkey.currentState!.save();
          UserCredential? credenciales = await login(email, password);
          if(credenciales !=null){
            if(credenciales.user != null){
              if(credenciales.user!.emailVerified){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) => false);
              }
              else{
                //todo mostrar que debe verificar su email
                setState(() {
                  error = "Debes verificar tu correo antes de acceder";
                });
              }
            }
          }
        }

        
      },
      child: Text("Login")
      ),
    );
  }

//Accion para conectar Firebase al Proyecto
  Future<UserCredential?> login(String email, String passwd) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
        password: password);
      return userCredential;
    } on FirebaseException catch(e){
      if(e.code == 'User-not-found'){
        //todo usuario no encontrado
        setState(() {
          error = "Usuario no encontrado";
        });
      }
      if(e.code == 'wrong-password'){
        //Toda contraseña incorrecta
        setState(() {
          error = "contraseña incorrecta";
        });
      }
    }
  }
}