import 'package:flutter/material.dart';

class PoliticaPrivacidad extends StatefulWidget{


  @override
  State createState(){
    return _PoliticaPrivacidadState();
  }
}

class _PoliticaPrivacidadState extends State<PoliticaPrivacidad>{
  
  @override
  void initState() {
    super.initState();

  }

///Almacenamiento de todos los Build y diseño de la interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Politica de Privacidad"),
      ),
      body: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Bienvenido  lee nuestra Política de Privacidad :  ",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 24,
              fontFamily: 'Poppins',fontWeight: FontWeight.w700,height: 0),),
          ),
        ],
      ),
      )
    );
  }
}








