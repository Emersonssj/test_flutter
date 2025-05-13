import 'package:mobx/mobx.dart';

import '../../customers/entities/customer_entity.dart';
part 'table_store.g.dart';

class TableStore = _TableStoreBase with _$TableStore;

abstract class _TableStoreBase with Store {
  @observable
  String identification = '';

  @observable
  ObservableList<CustomerEntity> customers = ObservableList<CustomerEntity>();

  @action
  void setIdentification(String newIdentification) => identification = newIdentification;

  @action
  void addCustomer(CustomerEntity customer) {
    customers.add(customer);
  }

  @action
  void removeTableCustomer(CustomerEntity customer) {
    customers.remove(customer);
  }

  @action
  void removeLastCustomer() => customers.removeLast();

  @action
  void updateCustomerAtIndex(CustomerEntity customer, int index) {
    customers[index] = customer;
  }
}
