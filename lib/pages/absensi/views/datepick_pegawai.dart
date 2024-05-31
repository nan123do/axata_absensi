import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DatePickPegawai extends StatefulWidget {
  const DatePickPegawai({
    Key? key,
    required this.selectedDate,
    required this.dateFrom,
    required this.dateTo,
    required this.onDateChanged,
  }) : super(key: key);

  final String selectedDate;
  final DateTime dateFrom;
  final DateTime dateTo;
  final Function(DateTime, DateTime, String) onDateChanged;

  @override
  State<DatePickPegawai> createState() => _DatePickPegawaiState();
}

class _DatePickPegawaiState extends State<DatePickPegawai> {
  int _selectedValue = 0;
  String selectedDate = 'Bulan Ini';
  List<String> listDateFilter = [
    'Bulan Ini',
    'Bulan Kemarin',
  ];

  String dateFromText = '';
  String dateToText = '';
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  DateTime now = DateTime.now();

  @override
  void initState() {
    getDate();
    super.initState();
  }

  String filterSelectedDate(String selectedDate) {
    // Pengecekan format dd MMM yyyy
    if (RegExp(r'^\d{2} [A-Za-z]+ \d{4} - \d{2} [A-Za-z]+ \d{4}$')
        .hasMatch(selectedDate)) {
      return 'dd MMM yyyy';
    }

    // Pengecekan format MMM yyyy
    if (RegExp(r'^[A-Za-z]+ \d{4} - [A-Za-z]+ \d{4}$').hasMatch(selectedDate)) {
      return 'MMM yyyy';
    }

    // Pengecekan format yyyy
    if (RegExp(r'^\d{4} - \d{4}$').hasMatch(selectedDate)) {
      return 'yyyy';
    }
    return 'tidak ada format';
  }

  getDate() {
    dateFrom = widget.dateFrom;
    dateTo = widget.dateTo;
    dateFromText = DateFormat('dd MMMM yyyy', 'id_ID').format(dateFrom);
    dateToText = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTo);
    selectedDate = widget.selectedDate;
    _selectedValue = listDateFilter.indexOf(selectedDate);

    if (_selectedValue == -1) {
      String format = filterSelectedDate(selectedDate);
      if (format == 'dd MMM yyyy') {
        _selectedValue = 3;
      } else if (format == 'MMM yyyy') {
        _selectedValue = 4;
      } else if (format == 'yyyy') {
        _selectedValue = 5;
      } else {
        _selectedValue = 3;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void openModalFilterDate(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, myState) {
              List<Widget> radioListTiles =
                  List.generate(listDateFilter.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20.h,
                  ),
                  child: Row(
                    children: [
                      Text(
                        listDateFilter[index],
                        style: AxataTheme.oneBold,
                      ),
                      const Spacer(),
                      Radio(
                        value: index,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          myState(() {
                            _selectedValue = value as int;
                          });
                        },
                      ),
                    ],
                  ),
                );
              });

              handleSubmitDate() {
                switch (_selectedValue) {
                  case 0:
                    myState(() {
                      dateFrom = DateTime(now.year, now.month, 1);
                      dateTo = DateTime(now.year, now.month + 1, 0);
                    });
                    break;
                  case 1:
                    myState(() {
                      int year = now.month == 1 ? now.year - 1 : now.year;
                      int month = now.month == 1 ? 12 : now.month - 1;

                      dateFrom = DateTime(year, month, 1);

                      dateTo = DateTime(year, month + 1, 0);
                    });
                    break;
                  default:
                }
                setState(() {
                  selectedDate = listDateFilter[_selectedValue];
                });
              }

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                  vertical: 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...radioListTiles,
                    SizedBox(
                      height: 50.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        handleSubmitDate();
                        widget.onDateChanged(
                          dateFrom,
                          dateTo,
                          selectedDate,
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 20.h,
                        ),
                        alignment: Alignment.center,
                        decoration: AxataTheme.styleGradientUD,
                        child: Text(
                          'Terapkan',
                          style: AxataTheme.oneBold
                              .copyWith(color: AxataTheme.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => openModalFilterDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40.w,
          vertical: 20.h,
        ),
        decoration: AxataTheme.styleUnselectBoxFilter,
        child: Row(
          children: [
            Text(
              selectedDate,
              style: AxataTheme.oneSmall.copyWith(color: AxataTheme.mainColor),
            ),
            SizedBox(
              width: 20.w,
            ),
            FaIcon(
              FontAwesomeIcons.caretDown,
              color: AxataTheme.mainColor,
              size: 30.r,
            ),
          ],
        ),
      ),
    );
  }
}
