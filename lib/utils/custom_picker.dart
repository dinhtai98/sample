import 'package:custom_cupertino_picker/custom_cupertino_picker.dart'
    as lib_custom_cupertino;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/utils/string.dart';

import 'color_utils.dart';
import 'dimen_mixin.dart';
import 'localization_utils.dart';
import 'res.dart';
import 'text_style_utils.dart';
import 'display.dart';
import 'value_listenable_builder2.dart';

class CustomCupertinoPicker<T> extends StatefulWidget {
  final double height;
  final double width;
  final List<T> children;

  /// Value mean index of item in list children
  final Function(int) onSelectedItemChanged;
  final int initialValue;
  final String? symbol;

  const CustomCupertinoPicker({
    super.key,
    required this.height,
    required this.width,
    required this.children,
    required this.onSelectedItemChanged,
    this.initialValue = 0,
    this.symbol,
  });

  @override
  State<CustomCupertinoPicker> createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
  late FixedExtentScrollController controller;

  /// Value mean index of item in list children
  late ValueNotifier<int> selectedValue;

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: widget.initialValue);
    selectedValue = ValueNotifier<int>(widget.children[widget.initialValue]);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    selectedValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 72.5,
          child: Container(
            width: 132,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Dimen.buttonRadius),
              color: ColorUtils.gray200,
            ),
          ),
        ),
        SizedBox(
          height: 189,
          width: 132,
          child: ValueListenableBuilder(
            valueListenable: selectedValue,
            builder: (context, selected, _) {
              return lib_custom_cupertino.CustomCupertinoPicker(
                scrollController: controller,
                highlighterBorder: const Border(),
                itemExtent: 44,
                onSelectedItemChanged: (v) {
                  selectedValue.value = widget.children[v];
                  widget.onSelectedItemChanged.call(v);
                },
                children: [
                  for (var i = 0; i < widget.children.length; i++)
                    Builder(
                      builder: (context) {
                        var isSelected = selected == widget.children[i];

                        return Center(
                          child: Text(
                            _getText(widget.children[i], widget.symbol),
                            style: isSelected
                                ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _getText(dynamic item, String? symbol) {
    var text = item.toString();
    if (item is int) {
      text = text.padLeft(2, '0');
    }
    if (symbol.isNullOrEmpty) return text;
    return text += symbol!;
  }
}

class CustomCupertinoPickerTimeData extends StatefulWidget {
  final DateTime initialValue;
  final Function(int value)? onSelectedHourChanged;
  final Function(int value)? onSelectedMinuteChanged;
  final Function(String value)? onSelectedAmOrPmChanged;

  const CustomCupertinoPickerTimeData({
    super.key,
    required this.initialValue,
    this.onSelectedHourChanged,
    this.onSelectedMinuteChanged,
    this.onSelectedAmOrPmChanged,
  });

  @override
  State<CustomCupertinoPickerTimeData> createState() =>
      _CustomCupertinoPickerTimeDataState();
}

class _CustomCupertinoPickerTimeDataState
    extends State<CustomCupertinoPickerTimeData> {
  late FixedExtentScrollController hourController,
      minuteController,
      amOrPmController;

  /// Value mean index of item in list children
  late ValueNotifier<int> hourValue, minuteValue;
  late ValueNotifier<String> amOrPMValue;
  var minuteList = Res.getMinuteChild();
  var amOrPm = ['AM', 'PM'];
  var aMHour = Res.getAMHourChild();
  var pMHour = Res.getPMHourChild();

  @override
  void initState() {
    var initHour = widget.initialValue.hour;
    var initAmOrPm = 0;
    if (initHour > 11) {
      initAmOrPm = 1;
      initHour -= 13;
    }
    var initMinute = widget.initialValue.minute;
    hourController = FixedExtentScrollController(initialItem: initHour);
    minuteController = FixedExtentScrollController(initialItem: initMinute);
    amOrPmController = FixedExtentScrollController(initialItem: initAmOrPm);
    hourValue = ValueNotifier<int>(initHour);
    minuteValue = ValueNotifier<int>(initMinute);
    amOrPMValue = ValueNotifier<String>(amOrPm[initAmOrPm]);
    super.initState();
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    amOrPmController.dispose();
    hourValue.dispose();
    minuteValue.dispose();
    amOrPMValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Dimen.buttonRadius),
            color: ColorUtils.gray200,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 100,
              child: ValueListenableBuilder(
                valueListenable: amOrPMValue,
                builder: (context, selected, _) {
                  return lib_custom_cupertino.CustomCupertinoPicker(
                    scrollController: amOrPmController,
                    highlighterBorder: const Border(),
                    itemExtent: 44,
                    onSelectedItemChanged: (v) {
                      amOrPMValue.value = amOrPm[v];
                      if (v == 1 && hourValue.value == 11) {
                        hourValue.value = 10;
                      }
                      widget.onSelectedAmOrPmChanged?.call(amOrPm[v]);
                    },
                    children: [
                      for (var i = 0; i < amOrPm.length; i++)
                        Builder(
                          builder: (context) {
                            var isSelected = selected == amOrPm[i];
                            return Center(
                              child: Text(
                                amOrPm[i],
                                style: isSelected
                                    ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                    : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 200,
              width: 100,
              child: ValueListenableBuilder2(
                first: hourValue,
                second: amOrPMValue,
                builder: (context, selected, amOrPmData, _) {
                  var hourList = amOrPmData == 'AM' ? aMHour : pMHour;
                  widget.onSelectedHourChanged?.call(hourList[hourValue.value]);
                  return lib_custom_cupertino.CustomCupertinoPicker(
                    scrollController: hourController,
                    highlighterBorder: const Border(),
                    itemExtent: 44,
                    onSelectedItemChanged: (v) {
                      hourValue.value = v;
                    },
                    children: [
                      for (var i = 0; i < hourList.length; i++)
                        Builder(
                          builder: (context) {
                            var isSelected = selected == i;
                            return Center(
                              child: Text(
                                hourList[i].toString(),
                                style: isSelected
                                    ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                    : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 200,
              width: 100,
              child: ValueListenableBuilder(
                valueListenable: minuteValue,
                builder: (context, selected, _) {
                  return lib_custom_cupertino.CustomCupertinoPicker(
                    scrollController: minuteController,
                    highlighterBorder: const Border(),
                    itemExtent: 44,
                    onSelectedItemChanged: (v) {
                      minuteValue.value = v;
                      widget.onSelectedMinuteChanged?.call(minuteList[v]);
                    },
                    children: [
                      for (var i = 0; i < minuteList.length; i++)
                        Builder(
                          builder: (context) {
                            var isSelected = selected == i;
                            return Center(
                              child: Text(
                                minuteList[i].toString().padLeft(2, '0'),
                                style: isSelected
                                    ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                    : TextStyleUtils.pickerHint(color: ColorUtils.gray400)
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CustomCupertinoPickerMultiData<T> extends StatefulWidget {
  final List<T> children1;
  final List<T> children2;

  /// Value mean index of item in list children
  final Function(int value) onSelectedItemChanged1;
  final Function(int value) onSelectedItemChanged2;
  final int initialValue1;
  final int initialValue2;
  final String? symbol;

  const CustomCupertinoPickerMultiData({
    super.key,
    required this.children1,
    required this.children2,
    required this.onSelectedItemChanged1,
    required this.onSelectedItemChanged2,
    this.initialValue1 = 0,
    this.initialValue2 = 0,
    this.symbol,
  });

  @override
  State<CustomCupertinoPickerMultiData> createState() =>
      _CustomCupertinoPickerMultiDataState();
}

class _CustomCupertinoPickerMultiDataState
    extends State<CustomCupertinoPickerMultiData> {
  late FixedExtentScrollController controller1, controller2;

  /// Value mean index of item in list children
  late ValueNotifier<String> selectedValue1, selectedValue2;

  @override
  void initState() {
    controller1 =
        FixedExtentScrollController(initialItem: widget.initialValue1);
    controller2 =
        FixedExtentScrollController(initialItem: widget.initialValue2);
    selectedValue1 =
        ValueNotifier<String>(widget.children1[widget.initialValue1]);
    selectedValue2 =
        ValueNotifier<String>(widget.children2[widget.initialValue2]);
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    selectedValue1.dispose();
    selectedValue2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 217,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Dimen.buttonRadius),
            color: ColorUtils.gray200,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 100,
              child: ValueListenableBuilder(
                valueListenable: selectedValue1,
                builder: (context, selected, _) {
                  return lib_custom_cupertino.CustomCupertinoPicker(
                    scrollController: controller1,
                    highlighterBorder: const Border(),
                    itemExtent: 44,
                    onSelectedItemChanged: (v) {
                      selectedValue1.value = widget.children1[v];
                      widget.onSelectedItemChanged1.call(v);
                    },
                    children: [
                      for (var i = 0; i < widget.children1.length; i++)
                        Builder(
                          builder: (context) {
                            var isSelected = selected == widget.children1[i];
                            return Center(
                              child: Text(
                                _getText(widget.children1[i], widget.symbol),
                                style: isSelected
                                    ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                    : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 200,
              width: 100,
              child: ValueListenableBuilder(
                valueListenable: selectedValue2,
                builder: (context, selected, _) {
                  return lib_custom_cupertino.CustomCupertinoPicker(
                    scrollController: controller2,
                    highlighterBorder: const Border(),
                    itemExtent: 44,
                    onSelectedItemChanged: (v) {
                      selectedValue2.value = widget.children2[v];
                      widget.onSelectedItemChanged2.call(v);
                    },
                    children: [
                      for (var i = 0; i < widget.children2.length; i++)
                        Builder(
                          builder: (context) {
                            var isSelected = selected == widget.children2[i];
                            return Center(
                              child: Text(
                                _getText(widget.children2[i], widget.symbol),
                                style: isSelected
                                    ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                    : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getText(dynamic item, String? symbol) {
    var text = item.toString();
    if (item is int) {
      text = text.padLeft(2, '0');
    }
    if (symbol.isNullOrEmpty) return text;
    return text += symbol!;
  }
}

class CustomPickDate extends StatefulWidget {
  final DateTime? initialDate;

  const CustomPickDate({super.key, this.initialDate});

  @override
  State<CustomPickDate> createState() => _CustomPickDateState();
}

class _CustomPickDateState extends State<CustomPickDate> {
  late ValueNotifier<int> selectedYear;
  late ValueNotifier<int> selectedMonth;
  late ValueNotifier<int> selectedDay;
  late ValueNotifier<int> maxMonthCanSelect;
  late ValueNotifier<int> maxDateCanSelect;
  var now = DateTime.now();
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dateController;

  late PickDateCubit pickDateCubit;

  late int initialYear;
  late int initialMonth;
  late int initialDay;
  late List<int> years;
  late List<int> months;
  late List<int> dates;

  @override
  void initState() {
    pickDateCubit = PickDateCubit();
    years = Res.getYearChild();
    months = Res.getListItemEndWith(12);
    initialYear = widget.initialDate?.year ?? 1999;
    initialMonth = widget.initialDate?.month ?? 1;
    initialDay = widget.initialDate?.day ?? 1;
    var maxDay = DateUtils.getDaysInMonth(initialYear, initialMonth);
    maxDateCanSelect = ValueNotifier<int>(maxDay);
    maxMonthCanSelect = ValueNotifier<int>(12);
    if (initialYear == now.year) {
      maxMonthCanSelect = ValueNotifier<int>(now.month);
    }
    if (initialYear == now.year && initialMonth == now.month) {
      maxDateCanSelect.value = now.day;
    }
    dates = Res.getListItemEndWith(maxDateCanSelect.value);
    pickDateCubit.pickedDate(DateTime(initialYear, initialMonth, initialDay));
    selectedYear = ValueNotifier<int>(initialYear);
    selectedMonth = ValueNotifier<int>(initialMonth);
    selectedDay = ValueNotifier<int>(initialDay);

    yearController =
        FixedExtentScrollController(initialItem: years.indexOf(initialYear));
    monthController =
        FixedExtentScrollController(initialItem: months.indexOf(initialMonth));
    dateController =
        FixedExtentScrollController(initialItem: dates.indexOf(initialDay));

    selectedYear.addListener(yearListener);
    selectedMonth.addListener(monthListener);
    super.initState();
  }

  void yearListener() {
    if (selectedYear.value == now.year) {
      maxMonthCanSelect.value = now.month;
      months = Res.getListItemEndWith(now.month);
      if (selectedMonth.value > now.month) {
        monthController.jumpToItem(now.month - 1);
        return;
      }
      if (selectedMonth.value == now.month) {
        maxDateCanSelect.value = now.day;
        dates = Res.getListItemEndWith(now.day);
        if (selectedDay.value >= now.day) {
          dateController.jumpToItem(now.day - 1);
        }
      }
    } else {
      maxDateCanSelect.value =
          DateUtils.getDaysInMonth(selectedYear.value, selectedMonth.value);
      dates = Res.getListItemEndWith(maxDateCanSelect.value);
      months = Res.getListItemEndWith(12);
      maxMonthCanSelect.value = 12;
    }
  }

  void monthListener() {
    if (selectedYear.value == now.year && selectedMonth.value == now.month) {
      maxDateCanSelect.value = now.day;
      dates = Res.getListItemEndWith(now.day);
      dateController.jumpToItem(now.day - 1);
      return;
    }

    maxDateCanSelect.value =
        DateUtils.getDaysInMonth(selectedYear.value, selectedMonth.value);
    if (selectedDay.value > maxDateCanSelect.value) {
      dateController.jumpToItem(maxDateCanSelect.value - 1);
    }
    dates = Res.getListItemEndWith(maxDateCanSelect.value);
  }

  @override
  void dispose() {
    selectedYear.removeListener(yearListener);
    selectedMonth.removeListener(yearListener);
    yearController.dispose();
    monthController.dispose();
    dateController.dispose();
    selectedYear.dispose();
    selectedMonth.dispose();
    selectedDay.dispose();
    pickDateCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = context.width <= 320;
    var screenWidthAbove670 = context.width > 650;
    return Stack(
      children: [
        Positioned.fill(
          top: 92.5,
          bottom: 92.5,
          child: Container(
            height: 44,
            width: context.width - (screenWidth ? 40 : (screenWidthAbove670 ? 73 : 50)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Dimen.buttonRadius),
              color: ColorUtils.gray200,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimen.margin),
          child: Container(
            color: ColorUtils.transparent,
            height: 229,
            child: Row(
              children: [
                Expanded(
                  flex: screenWidthAbove670 ? 1 : 11,
                  child: ValueListenableBuilder(
                    valueListenable: selectedYear,
                    builder: (context, selected, _) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimen.marginD4),
                        child: SizedBox(
                          height: 223,
                          child: lib_custom_cupertino.CustomCupertinoPicker(
                            onSelectedItemChanged: (v) {
                              selectedYear.value = years[v];
                              pickDateCubit.changeYear(years[v]);
                            },
                            scrollController: yearController,
                            itemExtent: 44,
                            highlighterBorder: const Border(),
                            children: [
                              ...years.map((e) {
                                var isSelected = selected == e;
                                return Center(
                                  child: Text(
                                    getNamePicker(e, LocalizationUtils.text?.text_year),
                                    style: isSelected
                                        ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                        : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: screenWidthAbove670 ? 1 : 8,
                  child: ValueListenableBuilder2(
                    first: maxMonthCanSelect,
                    second: selectedMonth,
                    builder: (context, month, selected, _) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimen.marginD4),
                        child: SizedBox(
                          width: 89,
                          height: 223,
                          child: lib_custom_cupertino.CustomCupertinoPicker(
                            onSelectedItemChanged: (v) {
                              selectedMonth.value = months[v];
                              pickDateCubit.changeMonth(months[v]);
                            },
                            scrollController: monthController,
                            itemExtent: 44,
                            highlighterBorder: const Border(),
                            children: [
                              ...months.map(
                                (e) {
                                  var isSelected = selected == e;
                                  return Center(
                                    child: Text(
                                      getNamePicker(e, LocalizationUtils.text?.text_month),
                                      style: isSelected
                                          ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                          : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: screenWidthAbove670 ? 1 : 8,
                  child: ValueListenableBuilder2(
                    first: maxDateCanSelect,
                    second: selectedDay,
                    builder: (context, date, selected, _) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimen.marginD4),
                        child: SizedBox(
                          width: 85,
                          height: 223,
                          child: lib_custom_cupertino.CustomCupertinoPicker(
                            onSelectedItemChanged: (v) {
                              selectedDay.value = dates[v];
                              pickDateCubit.changeDay(dates[v]);
                            },
                            scrollController: dateController,
                            itemExtent: 44,
                            highlighterBorder: const Border(),
                            children: [
                              ...dates.map(
                                (e) {
                                  var isSelected = selected == e;
                                  return Center(
                                    child: Text(
                                      getNamePicker(e, LocalizationUtils.text?.text_day),
                                      style: isSelected
                                          ? TextStyleUtils.picker(color: ColorUtils.primary3)
                                          : TextStyleUtils.pickerHint(color: ColorUtils.gray400),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String getNamePicker(int value, String? text) {
    return '$value${text ?? ''}';
  }
}

class PickDateCubit extends Cubit<PickDateState> {
  PickDateCubit() : super(const PickDateState());

  void pickedDate(DateTime value) {
    emit(PickDateState(date: value));
  }

  void changeYear(int year) {
    var newDate = DateTime(year, state.date?.month ?? 1, state.date?.day ?? 1);
    emit(PickDateState(date: newDate));
  }

  void changeMonth(int month) {
    var newDate =
        DateTime(state.date?.year ?? 2000, month, state.date?.day ?? 1);
    emit(PickDateState(date: newDate));
  }

  void changeDay(int day) {
    var newDate =
        DateTime(state.date?.year ?? 2000, state.date?.month ?? 1, day);
    emit(PickDateState(date: newDate));
  }
}

class PickDateState extends Equatable {
  final DateTime? date;

  const PickDateState({this.date});

  @override
  List<Object?> get props => [date];
}
