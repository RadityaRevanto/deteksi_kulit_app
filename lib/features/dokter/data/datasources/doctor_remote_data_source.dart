import '../../domain/entities/doctor.dart';

class DoctorRemoteDataSource {
  static const List<Doctor> dummyDoctors = [
    Doctor(
      id: 'doc_1',
      name: 'dr. Sarah Amalia, Sp.D.V.E.',
      specialist: 'Spesialis Dermatologi & Venereologi',
      hospital: 'Klinik Dermacare Utama',
      rating: 4.9,
      reviewCount: 156,
      experienceYears: 8,
      consultationFee: 50000,
      isOnline: true,
      avatarUrl: '',
    ),
    Doctor(
      id: 'doc_2',
      name: 'dr. Budi Santoso, Sp.KK',
      specialist: 'Spesialis Kulit & Kelamin',
      hospital: 'RS Medika Dermacare',
      rating: 4.8,
      reviewCount: 98,
      experienceYears: 12,
      consultationFee: 65000,
      isOnline: true,
      avatarUrl: '',
    ),
    Doctor(
      id: 'doc_3',
      name: 'dr. Amanda Putri, Sp.D.V.E.',
      specialist: 'Spesialis Jerawat & Estetika',
      hospital: 'Skin Health Center',
      rating: 4.95,
      reviewCount: 210,
      experienceYears: 6,
      consultationFee: 45000,
      isOnline: false,
      avatarUrl: '',
    ),
    Doctor(
      id: 'doc_4',
      name: 'dr. Reza Pratama, Sp.KK',
      specialist: 'Spesialis Dermatologi Akut',
      hospital: 'Klinik Spesialis Kulit',
      rating: 4.7,
      reviewCount: 84,
      experienceYears: 10,
      consultationFee: 55000,
      isOnline: true,
      avatarUrl: '',
    ),
  ];
}
