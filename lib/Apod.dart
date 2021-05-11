class Apod {
  String date;
  String explanation;
  String author;
  String title;
  String url;

  Apod({this.title, this.author, this.date, this.explanation, this.url});

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
        title: json['title'] ?? 'No title',
        author: json['copyright'] ?? 'No author',
        date: json['date'] ?? 'No date',
        explanation: json['explanation'] ?? 'No explanation',
        url: json['url'] ?? 'No url');
  }
}
