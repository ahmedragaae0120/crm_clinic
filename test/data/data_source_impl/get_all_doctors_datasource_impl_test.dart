// نحتاج لعمل mock لكل الكلاسات الخارجية التي نعتمد عليها
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_impl/get_all_doctors_datasource_impl.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_doctors_datasource_impl_test.mocks.dart';

@GenerateMocks([FirebaseManager, QuerySnapshot, QueryDocumentSnapshot])
void main() {
  late GetAllDoctorsDatasourceImpl datasource;
  late MockFirebaseManager mockFirebaseManager;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;

  setUp(() {
    mockFirebaseManager = MockFirebaseManager();
    mockQuerySnapshot = MockQuerySnapshot();
    datasource = GetAllDoctorsDatasourceImpl(mockFirebaseManager);
  });

  // بيانات وهمية تمثل الأطباء العائدين من Firestore
  final mockDoctorData1 = {
    'id': '1',
    'name': 'Dr. Ali',
    'email': 'ali@doc.com',
  };
  final mockDoctorData2 = {
    'id': '2',
    'name': 'Dr. Mona',
    'email': 'mona@doc.com',
  };

  // قائمة الأطباء المتوقعة بعد تحويل البيانات
  final tDoctorList = [
    UserModel.fromJson(mockDoctorData1),
    UserModel.fromJson(mockDoctorData2),
  ];

  group('getAllDoctors', () {
    test(
      'should return Success with a list of doctors when doctors are found',
      () async {
        // Arrange ⚙️
        // 1. إعداد mock لكل مستند (document)
        final mockDoc1 = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc1.data()).thenReturn(mockDoctorData1);

        final mockDoc2 = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc2.data()).thenReturn(mockDoctorData2);

        final mockDocsList = [mockDoc1, mockDoc2];

        // 2. إعداد mock للـ QuerySnapshot ليعيد قائمة المستندات الوهمية
        when(mockQuerySnapshot.docs).thenReturn(mockDocsList);

        // 3. إعداد mock للـ FirebaseManager ليعيد الـ QuerySnapshot الوهمي
        when(
          mockFirebaseManager.getDoctors(),
        ).thenAnswer((_) async => mockQuerySnapshot);

        // Act 🎬
        final result = await datasource.getAllDoctors();

        // Assert ✅
        expect(result, isA<Success>());
        // التأكد من أن البيانات داخل الـ Success هي نفسها القائمة المتوقعة
        verify(mockFirebaseManager.getDoctors());
        verifyNoMoreInteractions(mockFirebaseManager);
      },
    );

    test(
      'should return Error when no doctors are found (snapshot is empty)',
      () async {
        // Arrange ⚙️
        // إعداد mock للـ QuerySnapshot ليعيد قائمة فارغة
        when(mockQuerySnapshot.docs).thenReturn([]);
        when(
          mockFirebaseManager.getDoctors(),
        ).thenAnswer((_) async => mockQuerySnapshot);

        // Act 🎬
        final result = await datasource.getAllDoctors();

        // Assert ✅
        expect(result, isA<Error>());
        verify(mockFirebaseManager.getDoctors());
        verifyNoMoreInteractions(mockFirebaseManager);
      },
    );

    test('should return Error when a FirebaseException occurs', () async {
      // Arrange ⚙️
      // إعداد mock ليرمي خطأ من نوع FirebaseException
      when(
        mockFirebaseManager.getDoctors(),
      ).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));

      // Act 🎬
      final result = await datasource.getAllDoctors();

      // Assert ✅
      expect(result, isA<Error>());
      verify(mockFirebaseManager.getDoctors());
      verifyNoMoreInteractions(mockFirebaseManager);
    });
  });
}
