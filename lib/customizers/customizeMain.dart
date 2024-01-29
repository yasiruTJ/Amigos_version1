import 'package:amigos_ver1/customizers/customizeOne.dart';
import 'package:amigos_ver1/customizers/customizeThree.dart';
import 'package:amigos_ver1/customizers/customizeTwo.dart';
import 'package:amigos_ver1/dashboardMain/menuPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomizeMain extends StatefulWidget {
  const CustomizeMain({super.key});

  @override
  State<CustomizeMain> createState() => _CustomizeMainState();
}

class _CustomizeMainState extends State<CustomizeMain> {

  //controller to keep track on which page we are on
  final PageController _controller = PageController();

  //keeping track on whether the user reached the last page
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index){
                setState(() {
                  isLastPage = (index == 2);
                });
              },
              children: const [
                CustomizePg1(),
                CustomizePg2(),
                CustomizePg3()
              ],
            ),
            Container(
                alignment: Alignment(0,0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        _controller.jumpToPage(2);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )
                      ),
                      child: const Text(
                        "SKIP",
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    SmoothPageIndicator(controller: _controller, count: 3),
                    isLastPage?
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context,
                        CupertinoPageRoute(builder: (context)=> const Menu()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )
                      ),
                      child: const Text(
                        "DONE",
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ) :
                    ElevatedButton(
                      onPressed: (){
                        _controller.nextPage(duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )
                      ),
                      child: const Text(
                        "NEXT",
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    )
                  ],
                ))
          ],
        )
    );
  }
}
