


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heartratemonitor/screens/dashboard.dart';
import 'package:heartratemonitor/screens/login_screen.dart';
import 'package:heartratemonitor/services/auth_services.dart';
import 'package:heartratemonitor/utills/appvalidator.dart';

import '../firebase_options.dart';

Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(new MaterialApp(
    home: new  SignUpView(),



  ));




}
/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Text("Tutor joes")






    );
  }
}*/
class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  /*@override
  State<MyForm> createState() => _MyAppState();
}

class _MyAppState extends State<MyForm> {*/
final GlobalKey<FormState> _formkey=GlobalKey<FormState>();

final _usernamecontroller=TextEditingController();

  final _emailcontroller=TextEditingController();

  final _phonecontroller=TextEditingController();

  final _passwordcontroller=TextEditingController();

var isLoader=false;

var authservice=AuthService();

Future<void> _submitform() async{

if(_formkey.currentState!.validate()) {
setState(() {
isLoader=true;


});





  var data={
"username":_usernamecontroller.text,
  "email":_emailcontroller.text,
  "password":_passwordcontroller.text,
  "phone":_phonecontroller.text,
};
await authservice.createuser(data,context);
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginView(),));


setState(() {
  isLoader=false;


});

  ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
const SnackBar(content: Text('Form Submitted Successfully')),

);



}


}

var appvalidator=AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFF252634),

      body: Padding(padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(


                    children: [
                     SizedBox(height: 50.0,),
                      SizedBox(width: 250,
child:Text('Create new Account',textAlign: TextAlign.center,
style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)
)
                        ,),


                     SizedBox(height: 50.0,),
                      TextFormField(
                          controller: _usernamecontroller,
                          style: TextStyle(color: Colors.white),cursorColor: Colors.blue,

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _buildInputdecoration('Username', Icons.person),

                          validator: appvalidator.validateusername


                      ),


                      SizedBox(height: 16.0,),

                      TextFormField(
                          controller: _emailcontroller,
                          style: TextStyle(color: Colors.white),cursorColor: Colors.blue,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _buildInputdecoration('Email', Icons.email),

                          validator: appvalidator.validateEmail


                      ),


                      SizedBox(height: 16.0,),

                      TextFormField(
                          controller: _phonecontroller,

                          style: TextStyle(color: Colors.white),cursorColor: Colors.blue,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _buildInputdecoration('Mobile number', Icons.call),
                          validator: appvalidator.validatemobile),

                      SizedBox(height: 16.0,),


                      TextFormField(
                          controller: _passwordcontroller,

                          style: TextStyle(color: Colors.white),cursorColor: Colors.blue,
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _buildInputdecoration('Password', Icons.lock),

                          validator: appvalidator.validatepassword


                      ),


SizedBox(height: 40.0,),

                      SizedBox(height: 50.0,
                      width: double.infinity,

                  child: ElevatedButton(
                    onPressed:(){
isLoader ? print("Loading") : _submitform();

                    },


                    child:
                  isLoader ? Center(child: CircularProgressIndicator()):
                  Text('Create',style: TextStyle(fontSize: 20),),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color.fromARGB(255, 245, 89, 0), // Background color
                      onPrimary: Colors.white, // Text color
                      elevation: 4, // Elevation (shadow)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Border radius
                      ),
                    ),
                  ),



                      ),

                      SizedBox(height: 30.0,),

TextButton(






onPressed: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginView(),));


},
child:Text('Login', style: TextStyle(color: Color.fromARGB(255, 245, 89, 0),fontSize: 25),),



),



                    ],


                  )
              ))

      ),

    );
  }

  InputDecoration _buildInputdecoration(String label,IconData suffixIcon ) {
return InputDecoration(
fillColor: Color(0xAA494A59),
filled: true,
enabledBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(color: Color(0x35949494)),


),



labelStyle: TextStyle(color: Color(0xFF949494)),
    labelText:label,
suffixIcon:Icon(suffixIcon),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
          color: Colors.white),));



  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}









