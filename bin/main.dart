import 'package:http/http.dart';
import 'dart:convert';

void main() {
  // print("Olá, mundo!");
  //requestData();
  requestDataAsync();
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/ricarthlima/a0eb198cb7a70696c4031e7e577de0cd/raw/356ce2c39dfd58d3d2e948d1ad87ea828544f1db/accounts.json";
  Future<Response> futureResponse = get(Uri.parse(url));
  print(futureResponse);
  futureResponse.then(
    (Response response) {
      print(response);
      print(response.body);
      List<dynamic> listAccounts = json.decode(response.body);
      Map<String, dynamic> mapCarla = listAccounts.firstWhere(
        (element) => element["name"] == "Carla",
      );
      print(mapCarla["balance"]);
    },
  );

  print("Última coisa a acontecer na função.");
}

requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/ricarthlima/a0eb198cb7a70696c4031e7e577de0cd/raw/356ce2c39dfd58d3d2e948d1ad87ea828544f1db/accounts.json";
  Response response = await get(Uri.parse(url));
  print(json.decode(response.body)[0]);
  print("De fato, a última coisa a acontecer na função.");
}
