class Apod {
  String date;
  String explanation;
  String author;
  String title;
  String url;
  String mediaType;

  Apod(
      {this.title,
      this.author,
      this.date,
      this.explanation,
      this.url,
      this.mediaType});

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
        title: json['title'] ?? 'No title',
        author: json['copyright'] ?? 'No author',
        date: json['date'] ?? 'No date',
        explanation: json['explanation'] ?? 'No explanation',
        url: json['url'] ?? 'No url',
        mediaType: json['mediaType'] ?? 'No type');
  }
}
