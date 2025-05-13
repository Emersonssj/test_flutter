import 'package:mobx/mobx.dart';
import '../entities/customer.entity.dart';

part 'customers.store.g.dart';

class CustomersStore = _CustomersStoreBase with _$CustomersStore;

abstract class _CustomersStoreBase with Store {
  @observable
  ObservableList<CustomerEntity> customers = ObservableList<CustomerEntity>();

  @observable
  String searchInput = '';

  @computed
  List<CustomerEntity> get filteredCustomers {
    if (searchInput == '') {
      return customers;
    } else {
      return customers.where((customer) => customer.name.toUpperCase().contains(searchInput.toUpperCase())).toList();
    }
  }

  @action
  void setSearchInputValue(String newValue) => searchInput = newValue;

  @action
  void addCustomer(CustomerEntity customer) {
    customers.add(customer);
  }

  @action
  void removeCustomer(CustomerEntity customer) {
    customers.remove(customer);
  }

  @action
  void updateCustomer(CustomerEntity customer) {
    final index = customers.indexWhere((element) => element.id == customer.id);
    customers[index] = customer;
  }
}
