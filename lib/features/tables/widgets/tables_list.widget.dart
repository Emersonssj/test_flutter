import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../stores/tables_store.dart';
import 'table_card.widget.dart';

class TablesList extends StatelessWidget {
  TablesList({super.key});

  final TablesStore tablesStore = GetIt.I<TablesStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tablesStore.filteredTables
                  .map(
                    (table) => TableCard(table: table),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}
