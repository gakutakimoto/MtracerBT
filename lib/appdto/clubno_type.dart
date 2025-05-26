enum ClubNoType {
  w1,
  w3,
  w5,
  w7,
  w9,
  w11,
  h2,
  h3,
  h4,
  h5,
  h6,
  i2,
  i3,
  i4,
  i5,
  i6,
  i7,
  i8,
  i9,
  pw,
  awuw,
  sw,
  lw,
  four6,
  four8,
  five0,
  five2,
  five4,
  five6,
  five8,
  six0,
  other,
}

extension AlignExtensions on ClubNoType {
  String get clubNo {
    switch (this) {
      case ClubNoType.w1:
        return "1W";
      case ClubNoType.w3:
        return "3W";
      case ClubNoType.w5:
        return "5W";
      case ClubNoType.w7:
        return "7W";
      case ClubNoType.w9:
        return "9W";
      case ClubNoType.w11:
        return "11W";
      case ClubNoType.h2:
        return "2H/2U";
      case ClubNoType.h3:
        return "3H/3U";
      case ClubNoType.h4:
        return "4H/4U";
      case ClubNoType.h5:
        return "5H/5U";
      case ClubNoType.h6:
        return "6H/6U";
      case ClubNoType.i2:
        return "2I";
      case ClubNoType.i3:
        return "3I";
      case ClubNoType.i4:
        return "4I";
      case ClubNoType.i5:
        return "5I";
      case ClubNoType.i6:
        return "6I";
      case ClubNoType.i7:
        return "7I";
      case ClubNoType.i8:
        return "8I";
      case ClubNoType.i9:
        return "9I";
      case ClubNoType.pw:
        return "PW";
      case ClubNoType.awuw:
        return "AW/UW";
      case ClubNoType.sw:
        return "SW";
      case ClubNoType.lw:
        return "LW";
      case ClubNoType.four6:
        return "46";
      case ClubNoType.four8:
        return "48";
      case ClubNoType.five0:
        return "50";
      case ClubNoType.five2:
        return "52";
      case ClubNoType.five4:
        return "54";
      case ClubNoType.five6:
        return "56";
      case ClubNoType.five8:
        return "58";
      case ClubNoType.six0:
        return "60";
      default:
        return "other";
    }
  }
}
