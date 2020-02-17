
import 'clients.dart';

class ClientsGroup {
  final List<Client> clients;

  ClientsGroup({this.clients});

  factory ClientsGroup.fromJson(Map<String, dynamic> json) {

    var clientsDynamic = json['customers'] as List;
    var clientsParsed = clientsDynamic.map((i) => Client.fromJson(i)).toList();

    return ClientsGroup(clients: clientsParsed);
  }
}
