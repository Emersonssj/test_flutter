import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_flutter/features/tables/stores/table_store.dart';
import 'package:teste_flutter/features/tables/widgets/customers_counter.widget.dart';
import 'package:teste_flutter/features/tables/widgets/table_modal_widget.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';

const double _innerPadding = 1.0;
const double _topPadding = 5.0;

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.table,
  });

  final TableStore table;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(_innerPadding, _topPadding, _innerPadding, _innerPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.appColors.lightGreen,
          ),
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text((table.identification).toUpperCase(),
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: context.appColors.green, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: _innerPadding),
              Card(
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => TableModalWidget(oldTableStore: table),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      CustomersCounter(
                        label: '${table.customers.length}',
                        iconWidth: 16,
                        color: context.appColors.darkGrey,
                        textStyle: context.textTheme.bodySmall?.copyWith(color: context.appColors.darkGrey),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
