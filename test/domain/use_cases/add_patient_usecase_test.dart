import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/add_patient_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/domain/use_cases/add_patient_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_patient_usecase_test.mocks.dart';

@GenerateMocks([AddPatientDatasource])
void main() {
  group('AddPatientUsecase', () {
    late AddPatientUsecase addPatientUsecase;
    late MockAddPatientDatasource mockAddPatientDatasource;
    setUpAll(() {
      mockAddPatientDatasource = MockAddPatientDatasource();
      addPatientUsecase = AddPatientUsecase(mockAddPatientDatasource);
    });

    // بيانات وهمية للاستخدام في الاختبار
    final tPatientModel = PatientModel(
      patientId: '123',
      fullName: 'Mona Ahmed',
      phone: '01012345678',
      gender: 'female',
      birthDate: DateTime(2000, 1, 1).toString(),
      joined: DateTime.now(),
      // ...أكمل باقي البيانات الوهمية
    );
    // نتيجة وهمية ناجحة
    final tSuccessResult = Success<void>(null);

    test(
      'should call addPatient on the datasource and return its result',
      () async {
        // Arrange ⚙️
        // إعداد الـ mock ليرجع نتيجة ناجحة عند استدعاء دالة addPatient
        provideDummy<Result<void>>(tSuccessResult);

        when(
          mockAddPatientDatasource.addPatient(tPatientModel),
        ).thenAnswer((_) async => tSuccessResult);
        // Act 🎬
        // تنفيذ الـ usecase مع تمرير بيانات المريض الوهمية
        final result = await addPatientUsecase.call(tPatientModel);

        // Assert ✅
        // التأكد من أن النتيجة التي أرجعها الـ usecase هي نفسها التي أرجعها الـ mock
        expect(result, tSuccessResult);
        // التأكد من أن دالة addPatient قد تم استدعاؤها مرة واحدة بالبيانات الصحيحة
        verify(mockAddPatientDatasource.addPatient(tPatientModel)).called(1);
        // التأكد من عدم وجود أي تفاعلات أخرى مع الـ mock
        verifyNoMoreInteractions(mockAddPatientDatasource);
      },
    );
  });
}
