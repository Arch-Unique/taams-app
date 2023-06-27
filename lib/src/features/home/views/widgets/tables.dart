import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/home/views/course_screen.dart';
import 'package:unn_attendance/src/features/home/views/date_screen.dart';
import 'package:unn_attendance/src/features/home/views/search_screen.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/controller/attendance_controller.dart';
import 'package:unn_attendance/src/global/controller/loading_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../../src_barrel.dart';

final loadCont = Get.find<LoadingController>();

class AllUserDataTable extends StatefulWidget {
  final Map<String, List<Attendance>> priAtts; //usually course attends reg
  final Map<String, List<Attendance>> secAtts; //usually date attends cour
  final bool isCourse;
  const AllUserDataTable(this.priAtts, this.secAtts, this.isCourse,
      {super.key});

  @override
  State<AllUserDataTable> createState() => _AllUserDataTableState();
}

class _AllUserDataTableState extends State<AllUserDataTable> {
  List<String> priKeys = [], secKeys = [];
  List<TableEntry> te = [];
  List<bool> sorts = [true, true];

  @override
  void initState() {
    priKeys = widget.priAtts.keys.toList();
    secKeys = widget.secAtts.keys.toList();
    initTableEntries();
    super.initState();
  }

  initTableEntries() {
    sorts.addAll(List.generate(secKeys.length, (index) => true));
    te = List.generate(priKeys.length, (index) {
      List<int> lastText = [];
      List<List<Attendance>> gatts = [];
      final s = widget.priAtts[priKeys[index]]!;

      final gd = widget.isCourse
          ? AttendanceController.getGroupedListByDate(s)
          : AttendanceController.getGroupedListByCourse(s);
      final g = gd.map((key, value) => MapEntry(key, value.length));

      for (final ele in secKeys) {
        if (g.keys.contains(ele)) {
          gatts.add(gd[ele]!);
          lastText.add(g[ele]!);
        } else {
          gatts.add([]);
          lastText.add(0);
        }
      }

      return TableEntry(
          sn: index + 1,
          middle: priKeys[index],
          name: s[0].fullname!,
          lastlist: lastText,
          onTap: () {},
          eachTapAtts: gatts);
    });
  }

  @override
  void didUpdateWidget(covariant AllUserDataTable oldWidget) {
    // TODO: implement didUpdateWidget
    if (oldWidget.priAtts != widget.priAtts) {
      priKeys = widget.priAtts.keys.toList();
      secKeys = widget.secAtts.keys.toList();
      initTableEntries();
    }
    super.didUpdateWidget(oldWidget);
  }

  onSortColum(int columnIndex, bool ascending) {
    int k = widget.isCourse ? 2 : 3;
    if (columnIndex == 0) {
      if (ascending) {
        te.sort((a, b) => a.sn!.compareTo(b.sn!));
      } else {
        te.sort((a, b) => b.sn!.compareTo(a.sn!));
      }
    } else if (columnIndex == 1 && widget.isCourse) {
      if (ascending) {
        te.sort((a, b) => a.middle!.compareTo(b.middle!));
      } else {
        te.sort((a, b) => b.middle!.compareTo(a.middle!));
      }
    } else if (columnIndex == 1 && !widget.isCourse) {
      if (ascending) {
        te.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        te.sort((a, b) => b.name!.compareTo(a.name!));
      }
    } else if (columnIndex == 2 && !widget.isCourse) {
      if (ascending) {
        te.sort((a, b) => a.middle!.compareTo(b.middle!));
      } else {
        te.sort((a, b) => b.middle!.compareTo(a.middle!));
      }
    } else {
      if (ascending) {
        te.sort((a, b) =>
            a.lastlist[columnIndex - k].compareTo(b.lastlist[columnIndex - k]));
      } else {
        te.sort((a, b) =>
            b.lastlist[columnIndex - k].compareTo(a.lastlist[columnIndex - k]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columnSpacing: widget.isCourse ? 24 : 4,
        columns: [
          DataColumn(
              label: AppText.bold("S/N"),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sorts[columnIndex] = !sorts[columnIndex];
                });
                onSortColum(columnIndex, ascending);
              }),
          if (!widget.isCourse)
            DataColumn(
                label: AppText.bold("Name"),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sorts[columnIndex] = !sorts[columnIndex];
                  });
                  onSortColum(columnIndex, ascending);
                }),
          DataColumn(
              label: AppText.bold(widget.isCourse ? "Course" : "Reg No"),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sorts[columnIndex] = !sorts[columnIndex];
                });
                onSortColum(columnIndex, ascending);
              }),
          ...List.generate(
            secKeys.length,
            (index) => DataColumn(
                label: AppText.bold(secKeys[index]),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sorts[columnIndex] = !sorts[columnIndex];
                  });
                  onSortColum(columnIndex, ascending);
                }),
          )
        ],
        rows: te.map((e) {
          return DataRow(cells: [
            DataCell(AppText.thin14(e.snText)),
            if (!widget.isCourse) DataCell(AppText.thin14(e.fullname)),
            DataCell(AppText.thin14(e.middle!), onTap: () {
              final controller = Get.find<AppController>();
              if (widget.isCourse) {
                controller.attendanceController.setModList(controller
                    .attendanceController
                    .getUserAttendanceByCourse(e.middle!));
                controller.setHomeState(1);
              } else {
                controller.attendanceController.setModList(controller
                    .attendanceController
                    .getUserAttendance(e.middle!));
                controller.setHomeState(0);
                controller.fullname.value = e.fullname;
              }
              controller.setTitle(e.middle!);
              controller.attendanceController.changeAttState(true);

              // Get.to(HomeScreen());
              // final mp = widget.atts.entries.toList()[index];
              // Get.to(widget.isCourse ? CourseScreen(mp) : DateScreen(mp));
            }),
            ...List.generate(e.lastlist.length, (i) {
              return DataCell(
                AppText.thin14(e.lastlistText[i]),
                onTap: () {
                  final mp = MapEntry(e.middle!, e.eachTapAtts[i]);
                  if (mp.value.isEmpty) {
                    Ui.showSnackBar("Empty");
                    return;
                  }
                  Get.to(
                      widget.isCourse ? AdminDateScreen(mp) : CourseScreen(mp));
                },
              );
            })
          ]);
        }).toList());
  }
}

class UserDataTable extends StatefulWidget {
  final Map<String, List<Attendance>> atts;
  final bool isCourse;
  const UserDataTable(this.atts, this.isCourse, {super.key});

  @override
  State<UserDataTable> createState() => _UserDataTableState();
}

class _UserDataTableState extends State<UserDataTable> {
  List<String> keys = [];
  List<TableEntry> te = [];
  List<bool> sorts = [true, true, true];

  @override
  void initState() {
    // TODO: implement initState
    keys = widget.atts.keys.toList();
    initTableEntries();

    super.initState();
  }

  initTableEntries() {
    te = List.generate(keys.length, (index) {
      int lastText = 0;
      if (widget.isCourse) {
        lastText = widget.atts[keys[index]]!.length;
      } else {
        lastText =
            widget.atts[keys[index]]!.map((e) => e.course!).toList().length;

        // lastText = s.join(",");
      }
      return TableEntry(
        sn: index + 1,
        middle: keys[index],
        last: lastText,
        onTap: () {
          final mp = widget.atts.entries.toList()[index];
          Get.to(widget.isCourse ? CourseScreen(mp) : DateScreen(mp));
        },
      );
    });
  }

  @override
  void didUpdateWidget(covariant UserDataTable oldWidget) {
    // TODO: implement didUpdateWidget
    if (oldWidget.atts != widget.atts) {
      keys = widget.atts.keys.toList();
      initTableEntries();
    }
    super.didUpdateWidget(oldWidget);
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        te.sort((a, b) => a.sn!.compareTo(b.sn!));
      } else {
        te.sort((a, b) => b.sn!.compareTo(a.sn!));
      }
    } else if (columnIndex == 1) {
      if (ascending) {
        te.sort((a, b) => a.middle!.compareTo(b.middle!));
      } else {
        te.sort((a, b) => b.middle!.compareTo(a.middle!));
      }
    } else {
      if (ascending) {
        te.sort((a, b) => a.last!.compareTo(b.last!));
      } else {
        te.sort((a, b) => b.last!.compareTo(a.last!));
      }
    }
  }

  onSortTap(int i, bool j) {
    setState(() {
      sorts[i] = !sorts[i];
    });
    onSortColum(i, sorts[i]);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(
            label: AppText.bold("S/N"),
            onSort: onSortTap,
          ),
          DataColumn(
              label: AppText.bold(widget.isCourse ? "Course" : "Date"),
              onSort: onSortTap),
          DataColumn(label: AppText.bold("No"), onSort: onSortTap),
        ],
        rows: te.map((e) {
          return DataRow(cells: [
            DataCell(AppText.thin14(e.snText)),
            DataCell(AppText.thin14(e.middle ?? ""), onTap: e.onTap),
            DataCell(AppText.thin14(e.lastText)),
          ]);
        }).toList());
  }
}

class CourseDataTable extends StatefulWidget {
  final Map<String, List<Attendance>> atts;
  final bool isDate;
  const CourseDataTable(this.atts, this.isDate, {super.key});

  @override
  State<CourseDataTable> createState() => _CourseDataTableState();
}

class _CourseDataTableState extends State<CourseDataTable> {
  List<TableEntry> te = [];
  List<bool> sorts = [true, true, true, true];

  @override
  void initState() {
    // TODO: implement initState
    initTableEntries();

    super.initState();
  }

  initTableEntries() {
    var keys = widget.atts.keys.toList();
    te = List.generate(keys.length, (index) {
      int lastText = widget.atts[keys[index]]!.length;
      return TableEntry(
        sn: index + 1,
        middle: keys[index],
        name: widget.atts[keys[index]]![0].fullname,
        last: lastText,
        onTap: () {
          final mp = widget.atts.entries.toList()[index];
          Get.to(widget.isDate ? AdminDateScreen(mp) : CourseScreen(mp));
        },
      );
    });
  }

  @override
  void didUpdateWidget(covariant CourseDataTable oldWidget) {
    // TODO: implement didUpdateWidget
    if (oldWidget.atts != widget.atts) {
      initTableEntries();
    }
    super.didUpdateWidget(oldWidget);
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        te.sort((a, b) => a.sn!.compareTo(b.sn!));
      } else {
        te.sort((a, b) => b.sn!.compareTo(a.sn!));
      }
    } else if (columnIndex == 1 && widget.isDate) {
      if (ascending) {
        te.sort((a, b) => a.middle!.compareTo(b.middle!));
      } else {
        te.sort((a, b) => b.middle!.compareTo(a.middle!));
      }
    } else if (columnIndex == 1 && !widget.isDate) {
      if (ascending) {
        te.sort((a, b) => a.name!.compareTo(b.name!));
      } else {
        te.sort((a, b) => b.name!.compareTo(a.name!));
      }
    } else if (columnIndex == 2 && !widget.isDate) {
      if (ascending) {
        te.sort((a, b) => a.middle!.compareTo(b.middle!));
      } else {
        te.sort((a, b) => b.middle!.compareTo(a.middle!));
      }
    } else {
      if (ascending) {
        te.sort((a, b) => a.last!.compareTo(b.last!));
      } else {
        te.sort((a, b) => b.last!.compareTo(a.last!));
      }
    }
  }

  onSortTap(int i, bool j) {
    setState(() {
      sorts[i] = !sorts[i];
    });
    onSortColum(i, sorts[i]);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columnSpacing: widget.isDate ? 48 : 4,
        columns: [
          DataColumn(label: AppText.bold("S/N"), onSort: onSortTap),
          if (!widget.isDate)
            DataColumn(label: AppText.bold("Full Name"), onSort: onSortTap),
          DataColumn(
              label: AppText.bold(widget.isDate ? "Date" : "Reg No"),
              onSort: onSortTap),
          DataColumn(
              label: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: AppText.bold("No"),
              ),
              onSort: onSortTap),
        ],
        rows: te.map((e) {
          return DataRow(cells: [
            DataCell(AppText.thin14(e.snText)),
            if (!widget.isDate) DataCell(AppText.thin14(e.fullname)),
            DataCell(AppText.thin14(e.middle ?? ""), onTap: e.onTap),
            DataCell(Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: AppText.thin14(e.lastText),
            )),
          ]);
        }).toList());
  }
}

class UserTable extends StatefulWidget {
  final List<Attendance> atts;
  const UserTable(this.atts, {super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  List<String> sortTypes = ["Course", "Date"];
  int sortState = 0;
  Map<String, List<Attendance>> atts = {}, satts = {};
  TextEditingController cont = TextEditingController();

  @override
  void initState() {
    atts = AttendanceController.getGroupedListByCourse(widget.atts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DemoTable(
      chipLabel: sortTypes[sortState],
      childTable: UserDataTable(satts.isEmpty ? atts : satts, sortState == 0),
      cont: cont,
      hint: sortState == 0 ? "Search Course" : "Search Date",
      onChanged: (s) {
        setState(() {
          for (var element in atts.keys) {
            if (s.contains(element)) {
              satts[element] = atts[element]!;
            }
          }
          if (s.isEmpty) {
            satts = {};
          }
        });
      },
      onTap: () async {
        loadCont.showOverlay();
        await Future.sync(
          () {
            if (sortState == 0) {
              sortState = 1;
              atts = AttendanceController.getGroupedListByDate(widget.atts);
            } else {
              sortState = 0;
              atts = AttendanceController.getGroupedListByCourse(widget.atts);
            }
          },
        );
        setState(() {});
        loadCont.closeOverlay();
      },
    );
  }
}

class CourseTable extends StatefulWidget {
  final List<Attendance> atts;
  const CourseTable(this.atts, {super.key});

  @override
  State<CourseTable> createState() => _CourseTableState();
}

class _CourseTableState extends State<CourseTable> {
  List<String> sortTypes = ["Date", "RegNo"];
  int sortState = 0;
  Map<String, List<Attendance>> atts = {}, satts = {};
  TextEditingController cont = TextEditingController();

  @override
  void initState() {
    atts = AttendanceController.getGroupedListByDate(widget.atts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DemoTable(
        chipLabel: sortTypes[sortState],
        childTable:
            CourseDataTable(satts.isEmpty ? atts : satts, sortState == 0),
        cont: cont,
        hint: sortState == 0 ? "Search Date" : "Search Reg No",
        onChanged: (s) {
          setState(() {
            atts.forEach((key, value) {
              if (s == key) {
                satts.addEntries([MapEntry(key, value)]);
              }
            });
            if (satts.isEmpty) {
              satts = atts;
            }
          });
        },
        onTap: () {
          loadCont.showOverlay();
          setState(() {
            if (sortState == 0) {
              sortState = 1;
              atts = AttendanceController.getGroupedListByRegNo(widget.atts);
            } else {
              sortState = 0;
              atts = AttendanceController.getGroupedListByDate(widget.atts);
            }
          });
          loadCont.closeOverlay();
        });
  }
}

class AllDataTable extends StatefulWidget {
  final List<Attendance> atts;
  const AllDataTable(this.atts, {super.key});

  @override
  State<AllDataTable> createState() => _AllDataTableState();
}

class _AllDataTableState extends State<AllDataTable> {
  List<String> sortTypes = ["Course", "Reg No"];
  int sortState = 0;
  Map<String, List<Attendance>> priAtts = {}, satts = {};
  Map<String, List<Attendance>> secAtts = {};
  TextEditingController cont = TextEditingController();

  @override
  void initState() {
    priAtts = AttendanceController.getGroupedListByCourse(widget.atts);
    secAtts = AttendanceController.getGroupedListByDate(widget.atts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DemoTable(
        chipLabel: sortTypes[sortState],
        childTable: AllUserDataTable(
            satts.isEmpty ? priAtts : satts, secAtts, sortState == 0),
        cont: cont,
        hint: sortState == 0 ? "Search Course" : "Search Reg No",
        onChanged: (s) {
          priAtts.forEach((key, value) {
            if (s == key) {
              satts.addEntries([MapEntry(key, value)]);
            }
          });
          if (satts.isEmpty) {
            satts = priAtts;
          }
        },
        onTap: () {
          setState(() {
            if (sortState == 0) {
              sortState = 1;
              priAtts = AttendanceController.getGroupedListByRegNo(widget.atts);
              secAtts =
                  AttendanceController.getGroupedListByCourse(widget.atts);
            } else {
              sortState = 0;
              priAtts =
                  AttendanceController.getGroupedListByCourse(widget.atts);
              secAtts = AttendanceController.getGroupedListByDate(widget.atts);
            }
          });
        });
  }
}

class DemoTable extends StatelessWidget {
  final String? chipLabel, hint;
  final Widget? childTable;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextEditingController? cont;
  const DemoTable(
      {this.chipLabel,
      this.childTable,
      this.hint,
      this.cont,
      this.onChanged,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ui.boxHeight(16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (cont != null)
            //   SizedBox(
            //     width: Get.width / 2,
            //     child: CustomTextField(
            //       hint ?? "",
            //       "",
            //       cont!,
            //       isLabel: false,
            //       customOnChanged: onChanged,
            //       suffix: Icons.search_rounded,
            //       suffixColor: AppColors.white,
            //     ),
            //   ),
            IconButton(
                onPressed: () {
                  Get.to(SearchScreen());
                },
                icon: Icon(
                  Icons.search,
                  color: AppColors.white,
                )),
            const Spacer(),
            AppText.thin("Sort :   ", fontSize: 15, color: AppColors.white40),
            StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                  onTap: onTap,
                  child: Chip(
                    label: AppText.thin(chipLabel ?? "", fontSize: 15),
                    elevation: 4,
                    backgroundColor: AppColors.accentColor,
                    labelPadding: EdgeInsets.symmetric(horizontal: 16),
                  ));
            }),
          ],
        ),
        Ui.boxHeight(16),
        Expanded(
            child: SizedBox.expand(
                child: Ui.scrollbBar(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Ui.scrollbBar(
                  child: SingleChildScrollView(child: childTable))),
        )))
      ],
    );
  }
}

class TableEntry {
  final int? sn, last;
  final String? middle, name;
  final List<int> lastlist;
  final VoidCallback? onTap;
  final List<List<Attendance>> eachTapAtts;

  TableEntry({
    this.sn,
    this.last,
    this.name,
    this.middle,
    this.onTap,
    this.lastlist = const [],
    this.eachTapAtts = const [],
  });

  String get lastText => last.toString();
  String get snText => sn.toString();
  String get fullname => name!;
  List<String> get lastlistText => lastlist.map((e) => e.toString()).toList();
}
