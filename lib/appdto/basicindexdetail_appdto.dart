class BasicIndexDetailAppDto {
  late String title;
  late String referenceData;
  late String mainComment;
  late String subComment;
  late String? image1;
  late String? image2;

  BasicIndexDetailAppDto() {
    title = "";
    referenceData = "";
    mainComment = "";
    subComment = "";
    image1 = "";
    image2 = "";
  }

  BasicIndexDetailAppDto.init(this.title, this.referenceData, this.mainComment, this.subComment, this.image1, this.image2);
}
