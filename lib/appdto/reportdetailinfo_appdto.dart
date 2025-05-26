class ReportDetailInfoAppDto {
  late double improvementRate;
  late double minusOneSigma;
  late double plusOneSigma;
  late double score;

  ReportDetailInfoAppDto() {
    improvementRate = 0.0;
    minusOneSigma = 0.0;
    plusOneSigma = 0.0;
    score = 0.0;
  }

  ReportDetailInfoAppDto.init(
    this.improvementRate,
    this.minusOneSigma,
    this.plusOneSigma,
    this.score,
  );
}
