import 'package:lead_app/models/json.dart';
import 'package:lead_app/theme/colors.dart';
import 'package:lead_app/widgets/avatar_image.dart';
import 'package:lead_app/widgets/contact_box.dart';
import 'package:lead_app/widgets/doctor_info_box.dart';
import 'package:lead_app/widgets/mybutton.dart';
import 'package:lead_app/global/globals.dart' as globals;
import 'package:flutter/material.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Doctor's Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: getBody(),
      floatingActionButton: SizedBox(
        height: 60, // specify the height
        width: 60, // specify the width
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.chat,
            size: 30,
          ), // increase the size of the icon as well
        ),
      ),
    );
  }

  getBody() {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(doctors[globals.currentIndex]['Available'].toString(),
              style: const TextStyle(fontSize: 20, color: Colors.green)),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctors[globals.currentIndex]["name"].toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    doctors[globals.currentIndex]['skill'].toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                child: AvatarImage(
                  doctors[globals.currentIndex]['image'].toString(),
                  radius: 10,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 24,
                color: doctors[globals.currentIndex]['color1'] as Color,
              ),
              Icon(
                Icons.star,
                size: 24,
                color: doctors[globals.currentIndex]['color2'] as Color,
              ),
              Icon(
                Icons.star,
                size: 24,
                color: doctors[globals.currentIndex]['color3'] as Color,
              ),
              Icon(
                Icons.star,
                size: 24,
                color: doctors[globals.currentIndex]['color4'] as Color,
              ),
              Icon(
                Icons.star,
                size: 24,
                color: doctors[globals.currentIndex]['color5'] as Color,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(doctors[globals.currentIndex]['starNB'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 3,
          ),
          Text(
            "${doctors[globals.currentIndex]['review']} reviews",
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContactBox(
                icon: Icons.videocam_rounded,
                color: Colors.blue,
              ),
              ContactBox(
                icon: Icons.call_end,
                color: Colors.green,
              ),
              ContactBox(
                icon: Icons.chat_rounded,
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DoctorInfoBox(
                value: doctors[globals.currentIndex]['Patients'] as String,
                info: "Successful Patients",
                icon: Icons.groups_rounded,
                color: Colors.green,
              ),
              DoctorInfoBox(
                value: doctors[globals.currentIndex]['Experince'] as String,
                info: "Experience",
                icon: Icons.medical_services_rounded,
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DoctorInfoBox(
                value: doctors[globals.currentIndex]['OT'] as String,
                info: "Successful OT",
                icon: Icons.bloodtype_rounded,
                color: Colors.blue,
              ),
              DoctorInfoBox(
                value: "8+",
                info: "Certificates Achieved",
                icon: Icons.card_membership_rounded,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DoctorInfoBox(
                value: doctors[globals.currentIndex]['specialty'].toString(),
                info: "Specialty",
                icon: Icons.medication_liquid_rounded,
                color: const Color.fromARGB(255, 237, 157, 29),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          MyButton(
              disableButton: false,
              bgColor: primary,
              title: "Request For Appointment",
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ServicePage(
                //             doctorName: doctors[globals.currentIndex]['name']
                //                 .toString())));
              }),
          const SizedBox(
            height: 25,
          )
        ]));
  }
}
