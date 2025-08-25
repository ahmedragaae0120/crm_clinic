import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';

abstract interface class GetAllDoctorsDatasource {
  Future<Result<List<UserModel>>> getAllDoctors();
}
