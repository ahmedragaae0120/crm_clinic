import 'dart:developer';

import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/auth/create_admin_email_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CreateAdminEmailDatasource)
class CreateAdminEmailDatasourceImpl implements CreateAdminEmailDatasource {
  @factoryMethod
  CreateAdminEmailDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> createDefaultAdminIfNotExists() async {
    try {
      await _firebaseManager.createDefaultAdminIfNotExists();
      return Success<void>(null);
    } on FirebaseAuthException catch (e) {
      return Error(Exception(e));
    } on FirebaseException catch (e) {
      return Error(Exception(e));
    } catch (e) {
      log("in data source impl error: $e");
      return Error(Exception(e));
    }
  }
}
