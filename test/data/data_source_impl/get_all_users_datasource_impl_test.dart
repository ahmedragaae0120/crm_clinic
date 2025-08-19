import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_impl/get_all_users_datasource_impl.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_users_datasource_impl_test.mocks.dart';

@GenerateMocks([FirebaseManager, QuerySnapshot, QueryDocumentSnapshot])
void main() {
  late GetAllUsersDatasourceImpl datasource;
  late MockFirebaseManager mockFirebaseManager;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockDoc;

  final mockUserJson = {'id': '1', 'name': 'Ahmed', 'email': 'ahmed@test.com'};

  setUp(() {
    mockFirebaseManager = MockFirebaseManager();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();

    datasource = GetAllUsersDatasourceImpl(mockFirebaseManager);
  });

  group('GetAllUsersDatasourceImpl Tests', () {
    test('returns Success when users found', () async {
      // Arrange
      when(mockDoc.data()).thenReturn(mockUserJson);
      when(mockQuerySnapshot.docs).thenReturn([mockDoc]);

      when(
        mockFirebaseManager.getAllDocsInCollection(Collections.users),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));

      // Act
      final resultStream = datasource.getAllUsers();

      // Assert
      await expectLater(
        resultStream,
        emits(
          predicate<Result<List<UserModel>>>(
            (result) => result is Success<List<UserModel>>,
          ),
        ),
      );
    });

    test('returns Error when no users found', () async {
      // Arrange
      when(mockQuerySnapshot.docs).thenReturn([]);

      when(
        mockFirebaseManager.getAllDocsInCollection(Collections.users),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));

      // Act
      final resultStream = datasource.getAllUsers();

      // Assert
      await expectLater(
        resultStream,
        emits(
          predicate<Result<List<UserModel>>>(
            (result) => result is Error<List<UserModel>>,
          ),
        ),
      );
    });

    test('returns Error when FirebaseException thrown', () async {
      // Arrange
      when(
        mockFirebaseManager.getAllDocsInCollection(Collections.users),
      ).thenThrow(FirebaseException(plugin: 'firestore'));

      // Act
      final resultStream = datasource.getAllUsers();

      // Assert
      await expectLater(
        resultStream,
        emits(
          predicate<Result<List<UserModel>>>(
            (result) => result is Error<List<UserModel>>,
          ),
        ),
      );
    });
  });
}
