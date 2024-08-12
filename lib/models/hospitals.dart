class Hospital {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? description;
  final String? location;
  final String? phoneNumber;
  final String? website;
  final String? rating;
  final String? services;
  final String? historicalBackground;

  Hospital({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.location,
    required this.phoneNumber,
    required this.website,
    required this.rating,
    required this.services,
    required this.historicalBackground,
  });
}

List<Hospital> turkishHospitals = [
  Hospital(
    id: 1,
    name: "Acıbadem Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Acıbadem Hospital is one of the leading private hospitals in Turkey, offering advanced medical services.",
    location: "Istanbul",
    phoneNumber: "+90 212 304 00 00",
    website: "https://www.acibadem.com.tr/",
    rating: "4.8",
    services: "Cardiology, Oncology, Neurology, Pediatrics",
    historicalBackground:
        "Acıbadem Hospital was founded in 1991 and has since become one of the most prominent healthcare institutions in Turkey, providing cutting-edge medical care to patients from around the world.",
  ),
  Hospital(
    id: 2,
    name: "Memorial Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Memorial Hospital is known for its state-of-the-art facilities and specialized medical care.",
    location: "Ankara",
    phoneNumber: "+90 312 555 55 55",
    website: "https://www.memorial.com.tr/",
    rating: "4.6",
    services: "Orthopedics, Dermatology, Urology, Gynecology",
    historicalBackground:
        "Memorial Hospital was established in 2000 and has quickly become one of the most trusted names in healthcare in Turkey. It is renowned for its commitment to providing personalized and compassionate medical services.",
  ),
  Hospital(
    id: 3,
    name: "Medicana Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Medicana Hospital provides high-quality healthcare services with a focus on patient satisfaction.",
    location: "Izmir",
    phoneNumber: "+90 232 444 44 44",
    website: "https://www.medicana.com.tr/",
    rating: "4.7",
    services: "General Surgery, Radiology, Ophthalmology, Cardiac Surgery",
    historicalBackground:
        "Medicana Hospital has been serving patients since 1992 and has earned a reputation for excellence in healthcare. With a focus on continuous improvement and innovation, it continues to provide top-notch medical services to its patients.",
  ),
  Hospital(
    id: 4,
    name: "Florence Nightingale Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Florence Nightingale Hospital offers comprehensive medical care with a team of experienced doctors.",
    location: "Istanbul",
    phoneNumber: "+90 212 259 67 00",
    website: "https://www.fnh.com.tr/",
    rating: "4.5",
    services: 'Internal Medicine, ENT, Plastic Surgery, Endocrinology.',
    historicalBackground:
        "Florence Nightingale Hospital, founded in 2010, is named after the famous English nurse and pioneer of modern nursing. The hospital is committed to upholding her legacy by providing compassionate and high-quality medical care to all patients.",
  ),
  Hospital(
    id: 5,
    name: "Liv Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Liv Hospital is a modern healthcare facility equipped with cutting-edge medical technology.",
    location: "Ankara",
    phoneNumber: "+90 312 242 00 00",
    website: "https://www.liv.com.tr/",
    rating: "4.7",
    services: "Pulmonology, Nephrology, Gastroenterology, Neurosurgery",
    historicalBackground:
        "Liv Hospital, established in 2013, is known for its state-of-the-art facilities and commitment to providing exceptional healthcare services. It has quickly become a trusted name in the Turkish healthcare industry.",
  ),
  Hospital(
    id: 6,
    name: "Medical Park Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Medical Park Hospital offers a wide range of medical specialties with personalized care.",
    location: "Antalya",
    phoneNumber: "+90 242 444 44 44",
    website: "https://www.medicalpark.com.tr/",
    rating: "4.6",
    services: "Obstetrics, Psychiatry, Vascular Surgery, Hematology",
    historicalBackground:
        "Medical Park Hospital, established in 1993, is one of the largest hospital chains in Turkey. With a focus on patient-centered care and continuous improvement, it has earned the trust of patients and healthcare professionals alike.",
  ),
  Hospital(
    id: 7,
    name: "American Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "American Hospital provides healthcare services according to international standards.",
    location: "Istanbul",
    phoneNumber: "+90 212 444 03 03",
    website: "https://www.amerikanhastanesi.org/",
    rating: "4.8",
    services: "Pediatric Surgery, Rheumatology, Allergy and Immunology",
    historicalBackground:
        "American Hospital, established in 1920, is one of the oldest and most prestigious hospitals in Turkey. It has a long history of providing high-quality healthcare services to both local and international patients.",
  ),
  Hospital(
    id: 8,
    name: "Hisar Intercontinental Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Hisar Intercontinental Hospital offers advanced medical treatments with a focus on patient well-being.",
    location: "Istanbul",
    phoneNumber: "+90 212 444 55 00",
    website: "https://www.hisarhospital.com/",
    rating: "4.6",
    services: "Gynecologic Oncology, Infectious Diseases, Pain Management",
    historicalBackground:
        "Hisar Intercontinental Hospital, established in 2006, is known for its commitment to providing compassionate and personalized care to patients. It is equipped with state-of-the-art medical technology and has a team of highly skilled healthcare professionals.",
  ),
  Hospital(
    id: 9,
    name: "Anadolu Medical Center",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Anadolu Medical Center is a world-class healthcare facility providing comprehensive medical services.",
    location: "Istanbul",
    phoneNumber: "+90 262 654 11 11",
    website: "https://www.anadolumedicalcenter.com/",
    rating: "4.7",
    services: "Hematology-Oncology, Neonatology, Thoracic Surgery",
    historicalBackground:
        "Anadolu Medical Center, founded in 2005, is recognized as one of the leading healthcare institutions in Turkey and the region. It is affiliated with Johns Hopkins Medicine and is committed to providing high-quality, patient-centered care.",
  ),
  Hospital(
    id: 10,
    name: "Göztepe Şafak Hospital",
    imageUrl: "assets/images/hhhh.jpg",
    description:
        "Göztepe Şafak Hospital offers specialized medical care with a focus on patient comfort and safety.",
    location: "Istanbul",
    phoneNumber: "+90 216 566 66 66",
    website: "https://www.safakhastanesi.com.tr/",
    rating: "4.5",
    services:
        "Orthopedic Surgery, Dermatologic Surgery, Plastic and Reconstructive Surgery",
    historicalBackground:
        "Göztepe Şafak Hospital, established in 1998, has a long-standing reputation for excellence in healthcare. It is known for its state-of-the-art facilities and commitment to providing the highest standards of medical care to its patients.",
  ),
];
