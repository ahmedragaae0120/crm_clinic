import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_doctors_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/use_cases/get_all_doctors_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// This tells mockito to generate a mock class for our datasource
@GenerateMocks([GetAllDoctorsDatasource])
import 'get_all_doctors_usecase_test.mocks.dart'; // This file will be generated

void main() {
  late GetAllDoctorsUsecase usecase;
  late MockGetAllDoctorsDatasource mockGetAllDoctorsDatasource;

  // This function runs before each test, ensuring a clean state
  setUp(() {
    mockGetAllDoctorsDatasource = MockGetAllDoctorsDatasource();
    usecase = GetAllDoctorsUsecase(mockGetAllDoctorsDatasource);
  });

  // Create some fake data to use in the test
  final tDoctorList = <UserModel>[
    const UserModel(uid: '1', fullName: 'Dr. Hassan', email: 'hassan@doc.com'),
    const UserModel(uid: '2', fullName: 'Dr. Fatima', email: 'fatima@doc.com'),
  ];
  final tSuccessResult = Success(tDoctorList);

  test('should get a list of doctors from the datasource', () async {
    // Arrange ⚙️
    // Set up the mock datasource. When `getAllDoctors` is called,
    // tell it to return our fake success result.
    provideDummy<Result<List<UserModel>>>(tSuccessResult);
    when(
      mockGetAllDoctorsDatasource.getAllDoctors(),
    ).thenAnswer((_) async => tSuccessResult);

    // Act 🎬
    // Execute the use case's `call` method.
    final result = await usecase();

    // Assert ✅
    // 1. Check if the result from the use case is the exact same one we defined.
    expect(result, tSuccessResult);
    // 2. Verify that the `getAllDoctors` method on our mock was called exactly once.
    verify(mockGetAllDoctorsDatasource.getAllDoctors());
    // 3. Verify that no other methods were called on the mock.
    verifyNoMoreInteractions(mockGetAllDoctorsDatasource);
  });
}
