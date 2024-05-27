// Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   height:
//                       400, // Set a specific height for the RadialAnimatedMenu
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       AnimatedPositioned(
//                         duration: const Duration(milliseconds: 400),
//                         top: controller.status == AnimationStatus.dismissed
//                             ? 80
//                             : 200, // Adjust this value to animate the text
//                         child: Visibility(
//                           visible:
//                               controller.status == AnimationStatus.dismissed,
//                           child: Text(
//                             "Menu",
//                             style: TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: RadialAnimatedMenu(controller: controller),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            