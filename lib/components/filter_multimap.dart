import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterMapPage extends StatefulWidget {
  const FilterMapPage({
    Key? key,
    required this.title,
    required this.data,
    required this.onDataChanged,
  }) : super(key: key);

  final String title;
  final List<Map> data;
  final Function(List<Map>) onDataChanged;
  @override
  State<FilterMapPage> createState() => _FilterMapPageState();
}

class _FilterMapPageState extends State<FilterMapPage> {
  int sisaFilter = 0;
  List<Map> listMap = [];

  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() {
    listMap = widget.data;
  }

  List<Widget> _listWidget(List<Map> data) {
    return List.generate(data.length < 6 ? data.length : 6, (index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            data[index]['checked'] = !data[index]['checked'];
          });
          widget.onDataChanged(data);
        },
        child: _widgetKategori(data[index]),
      );
    });
  }

  Widget _widgetKategori(Map filter) {
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
      decoration: filter['checked'] == true
          ? AxataTheme.styleBoxFilter
          : AxataTheme.styleUnselectBoxFilter,
      child: Text(
        filter['name'],
        style: AxataTheme.oneSmall.copyWith(
          color: filter['checked'] == true
              ? AxataTheme.mainColor
              : AxataTheme.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: AxataTheme.oneSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _openModalLihatSemua(
                context,
                listMap,
                (List<Map> data) {
                  setState(() {
                    listMap = data;
                    listMap.sort((a, b) {
                      if (b['checked']) {
                        return 1;
                      }
                      return -1;
                    });
                    int sisa = data
                        .where((item) => item['checked'] == true)
                        .fold(0, (sum, item) => sum + 1);

                    if (sisa > 6) {
                      sisaFilter = sisa - 6;
                    } else {
                      sisaFilter = 0;
                    }
                  });
                  widget.onDataChanged(data);
                },
              ),
              child: Text(
                'lihat Semua',
                style: AxataTheme.oneBold.copyWith(color: AxataTheme.mainColor),
              ),
            ),
          ],
        ),
        _wrapSisa(_listWidget(listMap), sisaFilter),
      ],
    );
  }

  Container _widgetSisa(int sisa) {
    return sisa > 0
        ? Container(
            margin: EdgeInsets.only(
              top: 24.h,
              bottom: 24.h,
              right: 24.w,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 24.h,
            ),
            child: Text(
              '+ $sisa Lagi',
              style: AxataTheme.oneSmall.copyWith(
                color: AxataTheme.mainColor,
              ),
            ),
          )
        : Container();
  }

  Wrap _wrapSisa(List<Widget> widget, int sisa) {
    return Wrap(
      children: [
        ...widget,
        _widgetSisa(sisa),
      ],
    );
  }

  void _openModalLihatSemua(
      BuildContext context, List<Map> list, Function(List<Map>) update) {
    List multipleSelected = [];
    List<Map> data = list;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, myState) {
            List<Widget> radioListTiles = List.generate(data.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      data[index]["name"],
                      style: AxataTheme.oneBold,
                    ),
                    value: data[index]["checked"],
                    onChanged: (value) {
                      myState(() {
                        data[index]["checked"] = value;
                        if (multipleSelected.contains(data[index])) {
                          multipleSelected.remove(data[index]);
                        } else {
                          multipleSelected.add(data[index]);
                        }
                      });
                    },
                  ),
                  const Divider(),
                ],
              );
            });

            return Container(
              constraints: BoxConstraints(maxHeight: 0.5.sh),
              padding: EdgeInsets.symmetric(
                horizontal: 40.w,
                vertical: 20.h,
              ),
              // height: 0.5.sh,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [...radioListTiles],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      update(data);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 20.h,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AxataTheme.mainColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Terapkan',
                        style: AxataTheme.oneBold
                            .copyWith(color: AxataTheme.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
