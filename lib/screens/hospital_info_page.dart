import 'package:flutter/material.dart';
import 'package:lead_app/models/hospitals.dart';
import 'package:lead_app/global/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class HospitalInfoPage extends StatefulWidget {
  const HospitalInfoPage({super.key});

  @override
  State<HospitalInfoPage> createState() => _HospitalInfoPageState();
}

class _HospitalInfoPageState extends State<HospitalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      turkishHospitals[globals.hospitalIndex].imageUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Text(turkishHospitals[globals.hospitalIndex].phoneNumber ?? ''),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 10),
                Text(turkishHospitals[globals.hospitalIndex].location ??
                    '' ', City'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.link),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    String url =
                        turkishHospitals[globals.hospitalIndex].website ?? '';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    turkishHospitals[globals.hospitalIndex].website ??
                        '' ', City',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                turkishHospitals[globals.hospitalIndex].description ?? '',
                strutStyle: const StrutStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Services:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                turkishHospitals[globals.hospitalIndex].services ?? '',
                strutStyle: const StrutStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Historical Background:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                turkishHospitals[globals.hospitalIndex].historicalBackground ??
                    '',
                strutStyle: const StrutStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
