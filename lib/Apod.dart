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
        title: json['title'] ?? null,
        author: json['copyright'] ?? null,
        date: json['date'] ?? null,
        explanation: json['explanation'] ?? null,
        url: json['url'] ?? 'No url',
        mediaType: json['mediaType'] ?? null);
  }
}
