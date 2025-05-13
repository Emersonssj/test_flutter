import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/customers/widgets/edit_customer_modal.widget.dart';

class CustomerSearchField extends StatelessWidget {
  const CustomerSearchField({
    super.key,
    required this.addCustomer,
  });

  final void Function(CustomerEntity customer) addCustomer;

  @override
  Widget build(BuildContext context) {
    final CustomersStore customersStore = GetIt.I<CustomersStore>();
    final TextEditingController searchController = TextEditingController();

    return Observer(
      builder: (context) {
        return Stack(
          children: [
            TextFormField(
              controller: searchController,
              onChanged: (newValue) => customersStore.setSearchInputValue(newValue),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                suffixIcon: Icon(Icons.search),
                hintText: 'Pesquise por nome ou telefone',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 35),
              height: 200,
              child: customersStore.searchInput != ''
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const EditCustomerModal(),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_add_alt_1_outlined,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Novo cliente',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        customersStore.searchInput,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: customersStore.filteredCustomers.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    addCustomer(customersStore.filteredCustomers[index]);
                                    customersStore.removeCustomer(customersStore.filteredCustomers[index]);
                                    searchController.clear();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.person_add_alt_1_outlined,
                                        ),
                                        const SizedBox(width: 6),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customersStore.filteredCustomers[index].name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              customersStore.filteredCustomers[index].phone,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
