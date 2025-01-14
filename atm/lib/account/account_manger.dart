import 'dart:convert';
import 'package:atm/helpers/const.dart';
import 'package:atm/user/user_manager.dart';
import 'package:http/http.dart' as http;

import 'package:atm/account/account.dart';
import 'package:atm/helpers/api_response.dart';
import 'package:flutter/widgets.dart';

class AccountManager extends ChangeNotifier {
  Account account = Account();
  AccountManager() {
    getAccount();
  }

  bool _isLoading = false;

  bool get loading => _isLoading;
  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<ApiResponse<Account>> getAccount({int userId}) async {
    try {
      var url = '$BASE_URL/account/client/$userId';

      UserManager user = await UserManager();

      Map<String, String> headers = {
        "Content-type": "application/json",
        "x-access-token": "${user.user.token}"
      };

      print(headers);

      var response = await http.get(url, headers: headers);

      Map mapRensponse = json.decode(response.body);

      if (response.statusCode == 200) {
        account = Account.fromJson(mapRensponse);

        notifyListeners();
        return ApiResponse.ok(account);
      }
      notifyListeners();
      return ApiResponse.error(mapRensponse["message"]);
    } catch (e, ex) {
      print(
        "Erro no login $e => $ex",
      );
      throw e;
    }
  }

  Future<ApiResponse<Account>> sendMoney({
    @required int currentAccount,
    @required sendAccount,
    @required num balance,
  }) async {
    try {
      loading = true;
      var url = '$BASE_URL/account/client/transfer/$currentAccount';
      UserManager user = await UserManager();

      Map<String, String> headers = {
        "Content-type": "application/json",
        "x-access-token": "${user.user.token}"
      };

      Map<String, dynamic> params = {"id": sendAccount, "balance": balance};

      String values = json.encode(params);
      await Future.delayed(Duration(seconds: 2));
      var response = await http.patch(url, body: values, headers: headers);

      Map mapRensponse = json.decode(response.body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        final account = Account.fromJson(mapRensponse);
        loading = false;
        getAccount(userId: account.clientId);
        return ApiResponse.ok(account);
      }

      loading = false;

      return ApiResponse.error(mapRensponse["message"]);
    } catch (e, exception) {
      print(
        "Erro no login $e -> $exception",
      );
      return ApiResponse.error("$e");
    }
  }

  Future<ApiResponse<Account>> deponsit({
    @required int currentAccount,
    @required num balance,
  }) async {
    try {
      loading = true;
      var url = '$BASE_URL/account/deposit/$currentAccount';
      Map<String, String> headers = {"Content-type": "application/json"};

      Map<String, dynamic> params = {"balance": balance};

      String values = json.encode(params);
      await Future.delayed(Duration(seconds: 2));
      var response = await http.patch(url, body: values, headers: headers);

      Map mapRensponse = json.decode(response.body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        final account = Account.fromJson(mapRensponse);
        loading = false;
        getAccount(userId: account.clientId);
        return ApiResponse.ok(account);
      }

      loading = false;

      return ApiResponse.error(mapRensponse["message"]);
    } catch (e, exception) {
      print(
        "Erro no login $e -> $exception",
      );
      return ApiResponse.error("$e");
    }
  }

  Future<ApiResponse<Account>> raise({
    @required int currentAccount,
    @required num balance,
  }) async {
    try {
      loading = true;
      var url = '$BASE_URL/account/client/raise/$currentAccount';
      UserManager user = await UserManager();

      Map<String, String> headers = {
        "Content-type": "application/json",
        "x-access-token": "${user.user.token}"
      };

      Map<String, dynamic> params = {"balance": balance};

      String values = json.encode(params);
      await Future.delayed(Duration(seconds: 2));
      var response = await http.patch(url, body: values, headers: headers);

      Map mapRensponse = json.decode(response.body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        final account = Account.fromJson(mapRensponse);
        loading = false;
        getAccount(userId: account.clientId);
        return ApiResponse.ok(account);
      }

      loading = false;

      return ApiResponse.error(mapRensponse["message"]);
    } catch (e, exception) {
      print(
        "Erro no login $e -> $exception",
      );
      return ApiResponse.error("$e");
    }
  }
}
