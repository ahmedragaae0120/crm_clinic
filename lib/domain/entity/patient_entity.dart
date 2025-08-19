class PatientEntity {
  final String uid;
  final String fullName;
  final String phone;
  final String birthDate;
  final String gender;
  final DateTime joined;

  PatientEntity({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.joined,
  });
}
