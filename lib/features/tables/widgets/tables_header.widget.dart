import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../stores/tables_store.dart';
import 'customers_counter.widget.dart';
import 'table_modal_widget.dart';
import '../../../shared/widgets/search_input.widget.dart';
import '../../../utils/extension_methos/material_extensions_methods.dart';

class TablesHeader extends StatelessWidget {
  TablesHeader({super.key});

  final TablesStore tablesStore = GetIt.I<TablesStore>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Observer(
        builder: (context) {
          return Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  'Mesas',
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(width: 20),
                SearchInput(
                  onChanged: tablesStore.onChangeSearchInput,
                ),
                const SizedBox(width: 20),
                CustomersCounter(label: '${tablesStore.customersOnTableQuantity}'),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const TableModalWidget(),
                    );
                  },
                  tooltip: 'Criar nova mesa',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
