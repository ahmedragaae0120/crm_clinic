import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_impl/auth/login_datasource_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_datasource_impl_test.mocks.dart';

@GenerateMocks([FirebaseManager, UserCredential])
void main() {
  late LoginDatasourceImpl loginDatasource;
  late MockFirebaseManager mockFirebaseManager;
  late MockUserCredential mockUserCredential;

  setUpAll(() {
    mockFirebaseManager = MockFirebaseManager();
    loginDatasource = LoginDatasourceImpl(mockFirebaseManager);
    mockUserCredential = MockUserCredential();
  });

  String email = "ahmed@gmail.com ";
  String password = "Ahmed@123";

  group('LoginDatasourceImpl', () {
    test(
      'should return Success<Usercredential> when login from firebase is successful',
      () {
        // Arrange
        when(
          mockFirebaseManager.loginService(email, password),
        ).thenAnswer((_) async => Future.value(mockUserCredential));
        final result = loginDatasource.login(email: email, password: password);
        // Assert
        expect(result, isA<Future<Result<UserCredential>>>());
        verify(mockFirebaseManager.loginService(email, password)).called(1);
      },
    );

    test(
      'should return Error when login fails with user-not-found error',
      () async {
        // Arrange
        when(
          mockFirebaseManager.loginService(email, password),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));
        Result<UserCredential> result = await loginDatasource.login(
          email: email,
          password: password,
        );
        // Assert
        expect(result, isA<Error>());
        expect(
          (result as Error).exception.toString(),
          contains('No user found for that email.'),
        );
      },
    );
  });
}
