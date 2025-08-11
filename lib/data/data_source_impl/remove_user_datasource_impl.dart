import 'dart:convert';
import 'dart:developer';

import 'package:crm_clinic/core/constant.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/data/data_source_contract/remove_user_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(as: RemoveUserDatasource)
class RemoveUserDatasourceImpl implements RemoveUserDatasource {
  @override
  Future<Result<void>> removeUser(String userId) async {
    final response = await http.delete(Uri.parse(Constant.removeUserEndPoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "collection": Collections.users,
          "docId": userId,
        }));

    if (response.statusCode == 200) {
      log("Success");
      return Success(null);
    } else {
      log("Error: ${response.body}");
      return Error(Exception("Error: ${response.body}"));
    }
  }
}
