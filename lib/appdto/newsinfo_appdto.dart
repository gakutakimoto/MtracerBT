@deprecated
class NewsInfoAppDto {
  late String newsId;
  late bool isRead;
  late String category;
  late String title;
  late String news;
  late String userNewsId;
  late DateTime startAt;
  late DateTime endAt;

  NewsInfoAppDto() {
    newsId = "";
    isRead = false;
    category = "";
    title = "";
    news = "";
    userNewsId = "";
    startAt = DateTime.now();
    endAt = DateTime.now();
  }
}
