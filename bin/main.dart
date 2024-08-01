import 'dart:async';

import 'package:dart_assincronismo/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

StreamController<String> streamController = StreamController<String>();

void main() {
  StreamSubscription streamSubscription = streamController.stream.listen(
    (String info) {
      print(info);
    },
  );

  requestData();
  requestDataAsync();
  sendDataAsync({
    "id": "NEW001",
    "name": "Flutter",
    "lastName": "Dart",
    "balance": 5000,
  });
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/ricarthlima/a0eb198cb7a70696c4031e7e577de0cd/raw/356ce2c39dfd58d3d2e948d1ad87ea828544f1db/accounts.json";
  Future<Response> futureResponse = get(Uri.parse(url));
  futureResponse.then(
    (Response response) {
      streamController
          .add("${DateTime.now()} | Requisição de leitura (usando then).");
    },
  );
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/ricarthlima/a0eb198cb7a70696c4031e7e577de0cd/raw/356ce2c39dfd58d3d2e948d1ad87ea828544f1db/accounts.json";
  Response response = await get(Uri.parse(url));
  streamController.add("${DateTime.now()} | Requisição de leitura.");
  return json.decode(response.body);
}

sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestDataAsync();
  listAccounts.add(mapAccount);
  String content = json.encode(listAccounts);

  String url = "https://api.github.com/gists/413c0aefe6c6abc464581c29029c8ace";

  Response response = await post(
    Uri.parse(url),
    headers: {"Authorization": "Bearer $githubApiKey"},
    body: json.encode({
      "description": "account.json",
      "public": true,
      "files": {
        "accounts.json": {
          "content": content,
        }
      }
    }),
  );

  if (response.statusCode.toString()[0] == "2") {
    streamController.add(
        "${DateTime.now()} | Requisição adição bem sucedida (${mapAccount["name"]}).");
  } else {
    streamController
        .add("${DateTime.now()} | Requisição falhou (${mapAccount["name"]}).");
  }
}
