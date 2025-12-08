import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_users_repo.dart';
import 'package:crm_clinic/domain/use_cases/get_all_users_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// استبدل 'GetAllUsersRepo' بالكلاس الذي تريد عمل mock له
@GenerateMocks([GetAllUsersRepo])
import 'get_all_users_usecase_test.mocks.dart'; // الملف الذي سيتم إنشاؤه

void main() {
  late GetAllUsersUsecase usecase;
  late MockGetAllUsersRepo mockGetAllUsersRepo;

  // يتم تنفيذ هذا الكود قبل كل اختبار
  setUp(() {
    mockGetAllUsersRepo = MockGetAllUsersRepo();
    usecase = GetAllUsersUsecase(mockGetAllUsersRepo);
  });

  // بيانات وهمية للاستخدام في الاختبار
  final tUsersList = <UserModel>[
    UserModel(
      uid: '1',
      fullName: 'Ahmed',
      email: 'ahmed@example.com',
      joined: DateTime.now(),
      permission: 'Admin',
    ),
    UserModel(
      uid: '2',
      fullName: 'Fatma',
      email: 'fatma@example.com',
      joined: DateTime.now(),
      permission: 'Doctor',
    ),
  ];
  final tResultStream = Stream.value(Success(tUsersList));

  test('should get stream of users from the repository', () async {
    // Arrange ⚙️
    // تهيئة الـ mock لإرجاع stream وهمي عند استدعاء دالة getAllUsers
    when(mockGetAllUsersRepo.getAllUsers()).thenAnswer((_) => tResultStream);

    // Act 🎬
    // تنفيذ الـ usecase
    final result = usecase();

    // Assert ✅
    // التأكد من أن النتيجة التي أرجعها الـ usecase هي نفسها التي أرجعها الـ mock
    expect(result, tResultStream);
    // التأكد من أن دالة getAllUsers قد تم استدعاؤها مرة واحدة بالضبط
    verify(mockGetAllUsersRepo.getAllUsers()).called(1);
    // التأكد من عدم حدوث أي استدعاءات أخرى للـ mock
    verifyNoMoreInteractions(mockGetAllUsersRepo);
  });
}
