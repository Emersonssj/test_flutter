import 'package:mobx/mobx.dart';

import 'table_store.dart';
part 'tables_store.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  @observable
  String searchInput = '';

  @observable
  ObservableList<TableStore> tables = ObservableList<TableStore>();

  @action
  void addTable(TableStore newTable) => tables.add(newTable);

  @action
  void onChangeSearchInput(newValue) => searchInput = newValue;

  @action
  void updateTable(TableStore newTable, String oldIdentification) {
    final index = tables.indexWhere((element) => element.identification == oldIdentification);
    tables[index] = newTable;
  }

  @computed
  List<TableStore> get filteredTables {
    if (searchInput == '') {
      return tables;
    } else {
      return tables.where((table) => table.identification.toUpperCase().contains(searchInput.toUpperCase())).toList();
    }
  }

  @computed
  int get customersOnTableQuantity {
    if (tables.isEmpty) {
      return 0;
    } else {
      return tables.fold(0, (soma, table) => soma + table.customers.length);
    }
  }
}
