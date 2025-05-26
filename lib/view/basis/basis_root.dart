import "package:flutter/material.dart";
import 'package:mtracersdkexample/view/basis/basis_view_mobileportrait.dart';

class BasisRoot extends StatefulWidget {
  const BasisRoot({Key? key}) : super(key: key);

  @override
  _BasisRootState createState() => _BasisRootState();
}

class _BasisRootState extends State<BasisRoot> {
  @override
  Widget build(BuildContext context) {
    return const BasisViewMobilePortrait();
  }
}
