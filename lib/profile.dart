import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'constants.dart';
import 'user_prefs.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    final name = await UserPrefs.getUserName();
    final email = await UserPrefs.getUserEmail();
    setState(() {
      userName = name ?? '';
      userEmail = email ?? '';

    });
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
   return Scaffold(
     backgroundColor: Colors.blueGrey[100],
     appBar: AppBar(
       title: Text(
         'P R O F I L E ',
         style: TextStyle(
           color: Colors.black,
           fontWeight: FontWeight.bold,
           fontSize: height * 0.025,
         ),
       ),
       centerTitle: true,
       backgroundColor: Colors.white,
     ),
     body: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         //user details
         Container(
           height: height * 0.15,
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
           ),
           child: Padding(
             padding: EdgeInsets.only(top: height*0.02),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               mainAxisSize: MainAxisSize.max,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         decoration:BoxDecoration(
                           color: Colors.grey[300],
                           borderRadius: BorderRadius.circular(50),
                           image: DecorationImage(
                               image: AssetImage('images/profilepic.png'),
                             fit: BoxFit.cover,
                           )
                         ),
                         height: height * 0.11,
                         width: height*0.11,
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         children: [
                           Container(
                             decoration: BoxDecoration(
                               color: Colors.white,
                             ),
                             height: height*0.06,
                             width: width*0.4,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 Text(
                                   userName,
                                   style:TextStyle(
                                     color: Colors.black,
                                     fontSize: height*0.02,
                                     fontWeight: FontWeight.w400,
                                   ),
                                 ),
                                 Text(
                                   userEmail,
                                   style:TextStyle(
                                     color: Colors.grey,
                                     fontSize: height*0.02,
                                     fontWeight: FontWeight.w300,
                                   ),
                                 )
                               ],
                             ),

                           ),
                           Padding(
                             padding: EdgeInsets.only(top: height*0.02),
                             child: Container(
                               decoration: BoxDecoration(
                                 color: Colors.white,
                               ),
                               width: width*0.4,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   Text(
                                     'Handicap',
                                     style:TextStyle(
                                       color: Colors.blueAccent,
                                       fontSize: height*0.02,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),

                                 ],
                               ),

                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
                 IconButton(
                     onPressed: (){},
                     icon: Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height*0.02,
                     ),
                 ),

               ],
             ),
           ),

         ),
         SizedBox(height: height*0.04),
         //Player Performance
         Padding(
           padding:  EdgeInsets.only(left: width*0.05),
           child: Text(
             'Player Performance',
             style: TextStyle(
               color: Colors.black54,
               fontWeight: FontWeight.w500,
               fontSize: height*0.02,
             ),
           ),
         ),
         SizedBox(height: height*0.01),
         Container(
           //height: height*0.25,
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(20)),
           ),
           child:Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.h_plus_mobiledata,
                           color: Colors.black,
                           size: height*0.03,
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Handicap Details',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                 child: Container(
                   height: 1.1,
                   color: Colors.black26,
                 ),
               ),

               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.access_time,
                           color: Colors.black,
                           size: height*0.03,
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Recent Rounds',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                 child: Container(
                   height: 1.1,
                   color: Colors.black26,
                 ),
               ),

               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.score_sharp,
                           color: Colors.black,
                           size: height*0.03,
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Scoring History',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                 child: Container(
                   height: 1.1,
                   color: Colors.black26,
                 ),
               ),

               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.golf_course,
                           color: Colors.black,
                           size: height*0.03,
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Recent Courses',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),



             ],
           ),
         ),
         SizedBox(height: height*0.04),

         //Game Settings
         Padding(
           padding:  EdgeInsets.only(left: width*0.05),
           child: Text(
             'Game Settings',
             style: TextStyle(
               color: Colors.black54,
               fontWeight: FontWeight.w500,
               fontSize: height*0.02,
             ),
           ),
         ),
         SizedBox(height: height*0.01),
         Container(
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(20)),
           ),
           child:Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.grid_on_rounded,
                           color: Colors.black,
                           size: height*0.03,
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Scoring Display',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                 child: Container(
                   height: 1.1,
                   color: Colors.black26,
                 ),
               ),

               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Icon(
                           Icons.map_sharp,
                           color: Colors.black,
                           size: height*0.03,
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Maps Settings',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                 child: Container(
                   height: 1.1,
                   color: Colors.black26,
                 ),
               ),

               Padding(
                 padding: EdgeInsets.symmetric(
                   horizontal: width * 0.05,
                   vertical: height * 0.02,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         SvgPicture.asset(
                           'images/clubs.svg',
                           width: height * 0.03,
                           height: height * 0.03,
                           colorFilter: const ColorFilter.mode(
                             Colors.black,
                             BlendMode.srcIn,
                           ),
                         ),
                         SizedBox(width: width * 0.03),
                         Text(
                           'Clubs Settings',
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: height * 0.02,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Colors.blueAccent,
                       size: height * 0.02,
                     ),
                   ],
                 ),
               ),



             ],
           ),
         ),


       ],
     ),
   );
  }
}
