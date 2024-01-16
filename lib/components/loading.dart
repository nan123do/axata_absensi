import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height / 3.5,
          ),
          Center(
            child: Column(
              children: [
                orientation == Orientation.portrait
                    ? Image.asset(
                        'assets/logo/axata_full.png',
                        height: 180,
                        width: 300,
                      )
                    : Container(),
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Sedang memuat data... ',
                  style: TextStyle(
                    color: AxataTheme.mainColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
