import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_impl/add_patient_datasource_impl.dart'; // تأكد من المسار الصحيح
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// تعريف الكلاس الذي سيتم عمل mock له
@GenerateMocks([FirebaseManager])
import 'add_patient_datasource_impl_test.mocks.dart'; // الملف الذي سيتم إنشاؤه

void main() {
  late AddPatientDatasourceImpl datasource;
  late MockFirebaseManager mockFirebaseManager;

  // الإعداد قبل كل اختبار
  setUp(() {
    mockFirebaseManager = MockFirebaseManager();
    datasource = AddPatientDatasourceImpl(mockFirebaseManager);
  });

  // بيانات وهمية للاستخدام في الاختبار
  final tPatientModel = PatientModel(
    uid: '123',
    fullName: 'Mona Ahmed',
    phone: '01012345678',
    gender: 'female',
    birthDate: DateTime(2000, 1, 1).toString(),
    joined: DateTime.now(),
    // ...أكمل باقي البيانات الوهمية
  );

  group('addPatient', () {
    test(
        'should return Success<void> when adding a patient to firebase is successful',
        () async {
      // Arrange ⚙️
      // إعداد الـ mock ليعيد إجابة ناجحة عند استدعاء addPatient بالبيانات الصحيحة
      when(mockFirebaseManager.addPatient(tPatientModel))
          .thenAnswer((_) async => Future.value());

      // Act 🎬
      // تنفيذ الدالة المراد اختبارها
      final result = await datasource.addPatient(tPatientModel);

      // Assert ✅
      // التأكد من أن النتيجة من النوع Success
      expect(result, isA<Success>());
      // التأكد من أن دالة addPatient قد تم استدعاؤها مرة واحدة بالبيانات الصحيحة
      verify(mockFirebaseManager.addPatient(tPatientModel)).called(1);
      // التأكد من عدم وجود أي تفاعلات أخرى مع الـ mock
      verifyNoMoreInteractions(mockFirebaseManager);
    });

    test('should return Error when adding a patient throws a FirebaseException',
        () async {
      // Arrange ⚙️
      // إعداد الـ mock ليقوم برمي خطأ من نوع FirebaseException
      final tException =
          FirebaseException(plugin: 'firestore', code: 'unavailable');
      when(mockFirebaseManager.addPatient(tPatientModel)).thenThrow(tException);

      // Act 🎬
      final result = await datasource.addPatient(tPatientModel);

      // Assert ✅
      // التأكد من أن النتيجة من النوع Error
      expect(result, isA<Error>());
      verify(mockFirebaseManager.addPatient(tPatientModel));
      verifyNoMoreInteractions(mockFirebaseManager);
    });

    test('should return Error when adding a patient throws a generic Exception',
        () async {
      // Arrange ⚙️
      // إعداد الـ mock ليقوم برمي خطأ عام
      final tException = Exception('Something went wrong');
      when(mockFirebaseManager.addPatient(tPatientModel)).thenThrow(tException);

      // Act 🎬
      final result = await datasource.addPatient(tPatientModel);

      // Assert ✅
      // التأكد من أن النتيجة من النوع Error
      expect(result, isA<Error>());
      verify(mockFirebaseManager.addPatient(tPatientModel));
      verifyNoMoreInteractions(mockFirebaseManager);
    });
  });
}
