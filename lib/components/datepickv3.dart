import 'package:axata_absensi/components/datepickv2.dart';
import 'package:axata_absensi/utils/datehelper.dart';
import 'package:axata_absensi/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DatePickV3 extends StatefulWidget {
  const DatePickV3({
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
  State<DatePickV3> createState() => _DatePickV3State();
}

class _DatePickV3State extends State<DatePickV3> {
  int _selectedValue = 0;
  String selectedDate = 'Hari Ini';
  List<String> listDateFilter = [
    'Hari Ini',
    '30 Hari Terakhir',
    '90 Hari Terakhir',
    'Pilih Tanggal',
    'Pilih Bulan',
    'Pilih Tahun',
  ];

  String dateFromText = '';
  String dateToText = '';
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();

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
              void handleDateFrom({String format = 'dd-MM-yyyy'}) {
                void updateDate(DateTime newDate, String newDateText) {
                  myState(() {
                    dateFrom = newDate;
                    dateFromText = newDateText;
                  });
                }

                DateHelper.listDatePickerV2(
                  context,
                  format,
                  dateFrom,
                  dateFromText,
                  updateDate,
                );
              }

              handleDateTo({String format = 'dd-MM-yyyy'}) {
                void updateDate(DateTime newDate, String newDateText) {
                  myState(() {
                    dateTo = newDate;
                    dateToText = newDateText;
                  });
                }

                DateHelper.listDatePickerV2(
                  context,
                  format,
                  dateTo,
                  dateToText,
                  updateDate,
                );
              }

              pilihanTanggal() {
                if (_selectedValue == 3) {
                  dateFrom =
                      DateTime(dateFrom.year, dateFrom.month, dateFrom.day);
                  dateTo = DateTime(dateTo.year, dateTo.month, dateTo.day);

                  dateFromText =
                      DateFormat('dd MMM yyyy', 'id_ID').format(dateFrom);
                  dateToText =
                      DateFormat('dd MMM yyyy', 'id_ID').format(dateTo);
                  return DatePickV2(
                    dateFromText: dateFromText,
                    dateToText: dateToText,
                    funcDateFrom: handleDateFrom,
                    funcDateTo: handleDateTo,
                  );
                } else if (_selectedValue == 4) {
                  dateFrom = DateTime(dateFrom.year, dateFrom.month, 1);
                  if (dateTo.month % 2 == 1) {
                    if (dateTo.day < 5) {
                      // dateTo = dateTo.subtract(const Duration(days: 4));
                    }
                  }
                  DateTime lastPlusOne = (dateTo.month < 12)
                      ? DateTime(dateTo.year, dateTo.month + 1, 1)
                      : DateTime(dateTo.year + 1, 1, 1);
                  dateTo = lastPlusOne.subtract(const Duration(days: 1));

                  dateFromText =
                      DateFormat('MMM yyyy', 'id_ID').format(dateFrom);
                  dateToText = DateFormat('MMM yyyy', 'id_ID').format(dateTo);
                  return DatePickV2(
                    dateFromText: dateFromText,
                    dateToText: dateToText,
                    funcDateFrom: () => handleDateFrom(format: 'MMMM-yyyy'),
                    funcDateTo: () => handleDateTo(format: 'MMMM-yyyy'),
                  );
                } else if (_selectedValue == 5) {
                  dateFrom = DateTime(dateFrom.year, 1, 1);
                  dateTo = DateTime(dateTo.year, 12, 31);
                  dateFromText = DateFormat('yyyy', 'id_ID').format(dateFrom);
                  dateToText = DateFormat('yyyy', 'id_ID').format(dateTo);
                  return DatePickV2(
                    dateFromText: dateFromText,
                    dateToText: dateToText,
                    funcDateFrom: () => handleDateFrom(format: 'yyyy'),
                    funcDateTo: () => handleDateTo(format: 'yyyy'),
                  );
                } else {
                  return Container();
                }
              }

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
                      dateFrom = DateTime.now();
                    });
                    break;
                  case 1:
                    myState(() {
                      dateFrom =
                          DateTime.now().subtract(const Duration(days: 30));
                    });
                    break;
                  case 2:
                    myState(() {
                      dateFrom =
                          DateTime.now().subtract(const Duration(days: 90));
                    });
                    break;
                  default:
                }
                setState(() {
                  // dateFromText =
                  //     DateFormat('dd MMMM yyyy', 'id_ID').format(dateFrom);
                  // dateToText =
                  //     DateFormat('dd MMMM yyyy', 'id_ID').format(dateTo);
                  if (_selectedValue >= 3) {
                    selectedDate = '$dateFromText - $dateToText';
                  } else {
                    selectedDate = listDateFilter[_selectedValue];
                    dateTo = DateTime.now();
                  }
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
                    pilihanTanggal(),
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
