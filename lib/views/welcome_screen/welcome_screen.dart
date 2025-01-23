import 'package:flutter/material.dart';
import 'package:plo/views/home_screen/home_screen.dart';
import 'package:plo/views/log_in_screen/log_in_screen.dart';
import 'package:plo/views/sign_up_screen_view/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(fit: StackFit.expand, children: [
          Align(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 1.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/AdobeStock_513836255.jpeg",
                    ),
                    Column(
                      children: [
                        Image.asset('assets/images/pennstate_logo.png',
                            width: 100, height: 100),
                        const Text("People Link One",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 290,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: const Text("로그인",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 290,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text("회원가입",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          child: const Text(
                            "게스트로 로그인하기",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
