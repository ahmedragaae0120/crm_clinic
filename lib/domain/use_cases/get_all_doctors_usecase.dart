import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_doctors_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllDoctorsUsecase {
  @factoryMethod
  GetAllDoctorsUsecase(this._getAllDoctorsDatasource);
  final GetAllDoctorsDatasource _getAllDoctorsDatasource;

  Future<Result<List<UserModel>>> call() {
    return _getAllDoctorsDatasource.getAllDoctors();
  }
}
