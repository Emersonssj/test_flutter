import 'package:get_it/get_it.dart';

import 'features/customers/stores/customers_store.dart';
import 'features/tables/stores/tables_store.dart';

final sl = GetIt.I;

void slStores() {
  sl.registerLazySingleton<CustomersStore>(() => CustomersStore());
  sl.registerLazySingleton<TablesStore>(() => TablesStore());
}

void init() {
  slStores();
}
