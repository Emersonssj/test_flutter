import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../customers/entities/customer_entity.dart';
import '../../customers/stores/customers_store.dart';
import '../../customers/widgets/edit_customer_modal.widget.dart';

class CustomerSearchFieldWidget extends StatefulWidget {
  const CustomerSearchFieldWidget({
    super.key,
    required this.addCustomer,
  });
  final void Function(CustomerEntity customer) addCustomer;

  @override
  State<CustomerSearchFieldWidget> createState() => _CustomerSearchFieldWidgetState();
}

class _CustomerSearchFieldWidgetState extends State<CustomerSearchFieldWidget> {
  final CustomersStore customersStore = GetIt.I<CustomersStore>();
  final TextEditingController searchController = TextEditingController();

  void clearInputs() {
    customersStore.setSearchInputValue('');
    setState(() {
      searchController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                    widget.addCustomer(customersStore.filteredCustomers[index]);
                                    customersStore.removeCustomer(customersStore.filteredCustomers[index]);
                                    customersStore.setSearchInputValue('');
                                    setState(() {
                                      searchController.text = '';
                                    });
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
