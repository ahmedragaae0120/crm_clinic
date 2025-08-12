import 'dart:convert';
import 'package:crm_clinic/core/constant.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/data/data_source_impl/remove_user_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_user_datasource_impl_test.mocks.dart';

// سيقوم هذا السطر بإنشاء ملف الـ mock
@GenerateMocks([http.Client])
void main() {
  late RemoveUserDatasourceImpl datasource;
  late MockClient mockHttpClient;

  // يتم تهيئة المتغيرات قبل كل اختبار لضمان عدم تداخل الحالات
  setUp(() {
    mockHttpClient = MockClient();
    datasource = RemoveUserDatasourceImpl(mockHttpClient);
  });

  group('removeUser', () {
    // تعريف المتغيرات المستخدمة في الاختبارات لتقليل التكرار
    const tUserId = 'some_user_id';
    final tUri = Uri.parse(Constant.removeUserEndPoint);
    final tHeaders = {'Content-Type': 'application/json'};
    final tBody = jsonEncode({
      "collection": Collections.users,
      "docId": tUserId,
    });

    test(
      'should return Success when the http call completes successfully (status code 200)',
      () async {
        // Arrange ⚙️
        // تهيئة الـ mock لإرجاع استجابة ناجحة عند استدعاء دالة delete
        when(mockHttpClient.delete(tUri, headers: tHeaders, body: tBody))
            .thenAnswer((_) async => http.Response('User removed', 200));

        // Act 🎬
        // تنفيذ الدالة المراد اختبارها
        final result = await datasource.removeUser(tUserId);

        // Assert ✅
        // التأكد من أن النتيجة من النوع Success
        expect(result, isA<Success>());
        // التأكد من أن دالة delete تم استدعاؤها مرة واحدة بالبيانات الصحيحة
        verify(mockHttpClient.delete(tUri, headers: tHeaders, body: tBody))
            .called(1);
        // التأكد من عدم حدوث أي استدعاءات أخرى للـ mock
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return Error when the http call returns a non-200 status code',
      () async {
        // Arrange ⚙️
        // تهيئة الـ mock لإرجاع استجابة خاطئة (e.g. 404 Not Found)
        when(mockHttpClient.delete(tUri, headers: tHeaders, body: tBody))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Act 🎬
        // تنفيذ الدالة المراد اختبارها
        final result = await datasource.removeUser(tUserId);

        // Assert ✅
        // التأكد من أن النتيجة من النوع Error
        expect(result, isA<Error>());
        // التأكد من أن دالة delete تم استدعاؤها مرة واحدة بالبيانات الصحيحة
        verify(mockHttpClient.delete(tUri, headers: tHeaders, body: tBody))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
}
