import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSectionTitle('Our Story'),
              const SizedBox(height: 16.0),
              _buildSectionContent(
                'assets/images/craftful.jpeg', // Replace with your image asset
                'Our journey began in 2000, with a small shop in the heart of New York. With a passion for handicrafts and a dedication to preserving traditional craft methods, we quickly gained a reputation for our unique, high-quality products.',
              ),
              const SizedBox(height: 32.0),
              _buildSectionTitle('Our Mission'),
              const SizedBox(height: 16.0),
              _buildSectionContent(
                'assets/images/matt-noble-BpTMNN9JSmQ-unsplash.jpg', // Replace with your image asset
                'Our mission is to promote and preserve the traditional crafts of our region, providing our customers with unique, handmade products and supporting local artisans.',
              ),
              const SizedBox(height: 32.0),
              _buildSectionTitle('Our Team'),
              const SizedBox(height: 16.0),
              _buildSectionContent(
                'assets/images/annie-spratt-sggw4-qDD54-unsplash.jpg', // Replace with your image asset
                'Our team is made up of passionate individuals who share a love for craftsmanship. We work closely with local artisans, ensuring that every product we sell tells a story.',
              ),
              const SizedBox(height: 32.0),
              _buildSectionTitle('Contact Us'),
              const SizedBox(height: 8.0),
              _buildContactInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.teal[700],
      ),
    );
  }

  Widget _buildSectionContent(String imagePath, String content) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(imagePath),
        ),
        const SizedBox(height: 16.0),
        Text(
          content,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        Row(
          children: <Widget>[
            const Icon(Icons.email, color: Colors.teal),
            const SizedBox(width: 8.0),
            Text(
              'shikhmohamad59@gmail.com',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            const Icon(Icons.phone, color: Colors.teal),
            const SizedBox(width: 8.0),
            Text(
              '+961 81 190 632',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
