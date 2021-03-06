import 'dart:async';
import 'Apod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<List<Apod>> fetchApods(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://api.nasa.gov/planetary/apod?count=12&api_key=xQJLQZKFJSOeloe5y7Y8COxYaEuZvkBz5CDkFeCQ'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print(response.body);
    Iterable data = convert.jsonDecode(response.body);
    List<Apod> apods = [];
    for (var item in data) {
      if (item['media_type'] == 'image') {
        apods.add(Apod.fromJson(item));
      }
    }
    return apods;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load apod');
  }
}

class PodBloc {
  List<Apod> apods = <Apod>[];

  //apods state: state in -> state out:
  final _apodsViewStreamController = StreamController<List<Apod>>();
  StreamSink<List<Apod>> get _apodViewStateSink =>
      _apodsViewStreamController.sink;
  Stream<List<Apod>> get apodViewStateStream =>
      _apodsViewStreamController.stream;

  //event controller: exposed sink for feeding events from the UI:
  final _apodsViewEventController = StreamController<ApodEvent>();
  Sink<ApodEvent> get apodEventSink => _apodsViewEventController.sink;

  PodBloc() {
    _apodsViewEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ApodEvent event) async {
    if (event is GetApods) {
      apods = await fetchApods(http.Client());
    }
    _apodViewStateSink.add(apods);
  }

  void dispose() {
    _apodsViewEventController.close();
    _apodsViewStreamController.close();
  }
}

abstract class ApodEvent {}

class GetApods extends ApodEvent {}
