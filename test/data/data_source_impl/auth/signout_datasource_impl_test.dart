import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart'; // تأكد من المسار الصحيح
import 'package:crm_clinic/data/data_source_impl/auth/signout_datasource_impl.dart'; // تأكد من المسار الصحيح
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// تعريف الكلاس الذي سيتم عمل mock له
@GenerateMocks([FirebaseManager])
import 'signout_datasource_impl_test.mocks.dart'; // الملف الذي سيتم إنشاؤه

void main() {
  late SignoutDatasourceImpl datasource;
  late MockFirebaseManager mockFirebaseManager;

  // الإعداد قبل كل اختبار
  setUp(() {
    mockFirebaseManager = MockFirebaseManager();
    datasource = SignoutDatasourceImpl(mockFirebaseManager);
  });

  group('signOut', () {
    test('should return Success<void> when signOut from firebase is successful',
        () async {
      // Arrange ⚙️
      // إعداد الـ mock ليعيد إجابة ناجحة (Future مكتمل) عند استدعاء signOut
      when(mockFirebaseManager.signOut())
          .thenAnswer((_) async => Future.value());

      // Act 🎬
      // تنفيذ الدالة المراد اختبارها
      final result = await datasource.signOut();

      // Assert ✅
      // التأكد من أن النتيجة من النوع Success
      expect(result, isA<Success>());
      // التأكد من أن دالة signOut قد تم استدعاؤها مرة واحدة
      verify(mockFirebaseManager.signOut());
      // التأكد من عدم وجود أي تفاعلات أخرى مع الـ mock
      verifyNoMoreInteractions(mockFirebaseManager);
    });

    test(
        'should return Error when signOut from firebase throws a FirebaseAuthException',
        () async {
      // Arrange ⚙️
      // إعداد الـ mock ليقوم برمي خطأ من نوع FirebaseAuthException
      final tException =
          FirebaseAuthException(code: 'ERROR', message: 'Some error');
      when(mockFirebaseManager.signOut()).thenThrow(tException);

      // Act 🎬
      final result = await datasource.signOut();

      // Assert ✅
      // التأكد من أن النتيجة من النوع Error
      expect(result, isA<Error>());
      // التأكد من أن دالة signOut قد تم استدعاؤها مرة واحدة
      verify(mockFirebaseManager.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseManager);
    });

    test(
        'should return Error when signOut from firebase throws a generic Exception',
        () async {
      // Arrange ⚙️
      // إعداد الـ mock ليقوم برمي خطأ عام
      final tException = Exception('A generic error occurred');
      when(mockFirebaseManager.signOut()).thenThrow(tException);

      // Act 🎬
      final result = await datasource.signOut();

      // Assert ✅
      // التأكد من أن النتيجة من النوع Error
      expect(result, isA<Error>());
      verify(mockFirebaseManager.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseManager);
    });
  });
}
