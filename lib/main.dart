import 'package:flutter/material.dart';
import 'package:lists/pod_bloc.dart';

import 'Apod.dart';

//apikey xQJLQZKFJSOeloe5y7Y8COxYaEuZvkBz5CDkFeCQ
// ex: https://api.nasa.gov/planetary/apod?api_key=xQJLQZKFJSOeloe5y7Y8COxYaEuZvkBz5CDkFeCQ

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PodBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PodBloc();
    _bloc.apodEventSink.add(GetApods());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Apod>>(
        stream: _bloc.apodViewStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildScrollable(context, snapshot);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(0, 0, 50, 1),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bloc.apodEventSink.add(GetApods());
        },
        child: const Icon(Icons.refresh),
        backgroundColor: Color.fromRGBO(0, 0, 80, 1),
      ),
    );
  }

  Widget _buildScrollable(BuildContext context, AsyncSnapshot snapshot) {
    return CustomScrollView(slivers: [
      SliverAppBar(
          title: Text(
            'Astronomy Picture\n Of the Day',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          pinned: true,
          expandedHeight: 150,
          flexibleSpace: Image.network(
            snapshot.data[9].url,
            height: 350,
            fit: BoxFit.cover,
            color: Color.fromRGBO(0, 0, 50, 1),
            colorBlendMode: BlendMode.color,
          ),
          backgroundColor: Color.fromRGBO(0, 0, 50, 1)),
      SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return ApodContainer(data: snapshot.data[index]);
        }, childCount: 10),
        itemExtent: 400,
      ),
      SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              child: Image.network(
                snapshot.data[index].url,
                height: 150,
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: 10,
        ),
      )
    ]);
  }
}

class ApodContainer extends StatelessWidget {
  final dynamic data;
  ApodContainer({@required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        child: Column(
          children: [
            Text(
              data.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Image.network(
              data.url,
              height: 350,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(0, 0, 50, 1),
                      );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    data.date,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ));
  }
}
