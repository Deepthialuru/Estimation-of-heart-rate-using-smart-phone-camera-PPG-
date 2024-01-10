import 'package:flutter/material.dart';
import 'package:heartratemonitor/screens/sign_up.dart';
import 'package:heartratemonitor/utills/appvalidator.dart';



import '../services/auth_services.dart';

void main() {
  runApp(new MaterialApp(
    home: new  LoginView(),



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
class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /*@override
  State<MyForm> createState() => _MyAppState();
}

class _MyAppState extends State<MyForm> {*/
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  final _emailcontroller=TextEditingController();
  final _passwordcontroller=TextEditingController();
  var isLoader=false;
  var authservice=AuthService();
  Future<void> _submitform() async {
    if(_formkey.currentState!.validate()){
      setState(() {
        isLoader=true;


      });





      var data={

        "email":_emailcontroller.text,
        "password":_passwordcontroller.text,

      };
      await authservice.login(data,context);



      setState(() {
        isLoader=false;


      });






      ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Login  Successfully')),

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
                        child:Text('Login Account',textAlign: TextAlign.center,
                            style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)
                        )
                        ,),




                      SizedBox(height: 50.0,),

                      TextFormField(
                         controller:_emailcontroller,
                          style: TextStyle(color: Colors.white),cursorColor: Colors.blue,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _buildInputdecoration('Email', Icons.email),

                          validator: appvalidator.validateEmail


                      ),


                      SizedBox(height: 16.0,),




                      TextFormField(
                          controller:_passwordcontroller,
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
                          Text('Login',style: TextStyle(fontSize: 20),),

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






                        onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignUpView(),));  },
                        child:Text('Create new account', style: TextStyle(color: Color.fromARGB(255, 245, 89, 0),fontSize: 25),),



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
}









