import 'package:baha_platform/Features/ContentFeature/Domain/ContentTime.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentTimeWidget extends ConsumerWidget {
  final ContentTime contentTime;

  const ContentTimeWidget({super.key, required this.contentTime});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: DataTable2(
          columnSpacing: 0,
          dataRowHeight: 30,
          headingRowHeight: 40,
          headingTextStyle: Theme.of(context).textTheme.titleMedium,
          headingRowColor:
              WidgetStateProperty.all(ColorManager.secondaryContainer),
          border: const TableBorder(
            horizontalInside:
                BorderSide(color: ColorManager.secondaryContainer),
          ),
          columns: [
            DataColumn2(
              label: Center(child: Text(context.strings.day)),
              size: ColumnSize.S,
              headingRowAlignment: MainAxisAlignment.center,
            ),
            DataColumn2(
              label: Center(child: Text(context.strings.opening)),
              size: ColumnSize.L,
              headingRowAlignment: MainAxisAlignment.center,
            ),
            DataColumn2(
              label: Center(child: Text(context.strings.closing)),
              size: ColumnSize.M,
              headingRowAlignment: MainAxisAlignment.center,
            ),
          ],
          rows: [
            buildDataRow(contentTime.sunday, context.strings.sunday, context),
            buildDataRow(contentTime.monday, context.strings.monday, context),
            buildDataRow(contentTime.tuesday, context.strings.tuesday, context),
            buildDataRow(
                contentTime.wednesday, context.strings.wednesday, context),
            buildDataRow(
                contentTime.thursday, context.strings.thursday, context),
            buildDataRow(contentTime.friday, context.strings.friday, context),
          ],
        ),
      ),
    );
  }

  DataRow buildDataRow(
          ContentDayTime? dayTime, String day, BuildContext context) =>
      DataRow2(cells: [
        DataCell(Center(child: Text(day))),
        DataCell(Center(
          child: Text(dayTime != null
              ? dayTime.open.format(context)
              : context.strings.closed),
        )),
        DataCell(Center(
          child: Text(dayTime != null
              ? dayTime.close.format(context)
              : context.strings.closed),
        )),
      ]);
}
