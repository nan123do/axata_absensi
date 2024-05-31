import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterSingleMapPage extends StatefulWidget {
  const FilterSingleMapPage({
    Key? key,
    required this.title,
    required this.selected,
    required this.data,
    required this.onDataChanged,
  }) : super(key: key);

  final String title;
  final String selected;
  final List<String> data;
  final Function(String) onDataChanged;
  @override
  State<FilterSingleMapPage> createState() => _FilterSingleMapPageState();
}

class _FilterSingleMapPageState extends State<FilterSingleMapPage> {
  String selectedFilter = "";
  List<String> listMap = [];

  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() {
    listMap = widget.data;
    selectedFilter = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetLaporan = List.generate(listMap.length, (index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = listMap[index];
          });
          widget.onDataChanged(selectedFilter);
        },
        child: WidgetFilter(
          namafilter: listMap[index],
          selected: selectedFilter,
        ),
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AxataTheme.oneBold,
        ),
        Wrap(
          children: [
            ...widgetLaporan,
          ],
        ),
      ],
    );
  }
}

class WidgetFilter extends StatelessWidget {
  const WidgetFilter({
    Key? key,
    required this.namafilter,
    required this.selected,
  }) : super(key: key);
  final String namafilter;
  final String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 24.h,
        bottom: 24.h,
        right: 24.w,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 39.w,
        vertical: 24.h,
      ),
      decoration: selected == namafilter
          ? AxataTheme.styleBoxFilter
          : AxataTheme.styleUnselectBoxFilter,
      child: Text(
        namafilter,
        style: AxataTheme.oneBold.copyWith(
          color:
              selected == namafilter ? AxataTheme.mainColor : AxataTheme.black,
        ),
      ),
    );
  }
}
