import 'package:flutter_test/flutter_test.dart';
import 'package:lists/Apod.dart';
import 'package:lists/pod_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pod_bloc_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('PodBloc tests', () {
    test('initializes an empty list of Apods when created', () async {
      var podBloc = PodBloc();
      var apodsList = [];
      expect(podBloc.apods, apodsList);
    });
    test('emits null', () async {
      PodBloc podBloc = PodBloc();
      expect(podBloc.apods, []);
    });
    test('returns apods', () async {
      PodBloc podBloc = PodBloc();
      podBloc.apodEventSink.add(GetApods());
      await podBloc.apodViewStateStream.first.then((firstItem) {
        expect(firstItem[0], isNotNull);
        expect(firstItem[0].title, isNotNull);
      });
    });
  });
  group('fetchApods tests', () {
    test('returns a list of Apods if the http call completes successfully',
        () async {
      final client = MockClient();
      when(client.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?count=12&api_key=xQJLQZKFJSOeloe5y7Y8COxYaEuZvkBz5CDkFeCQ',
      ))).thenAnswer((_) async => http.Response("""[{
      "copyright": "Leuven University",
      "date": "2011-04-08",
      "explanation": "Ace.",
      "hdurl": "https://apod.nasa.gov/apod/image/1104/redGinterior_beck.jpg",
      "media_type": "image",
      "service_version": "v1",
      "title": "Echoes from the Depths of a Red Giant Star",
      "url": "https://apod.nasa.gov/apod/image/1104/redGinterior_beck.jpg"
      }]""", 200));
      var fetchOutput = await fetchApods(client);
      print(fetchOutput[0].title);
      expect(fetchOutput, isA<List<Apod>>());
    });
    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'https://api.nasa.gov/planetary/apod?count=12&api_key=xQJLQZKFJSOeloe5y7Y8COxYaEuZvkBz5CDkFeCQ')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      expect(fetchApods(client), throwsException);
    });
  });
}
