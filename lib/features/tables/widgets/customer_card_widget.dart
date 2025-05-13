import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../customers/entities/customer_entity.dart';
import '../../customers/stores/customers_store.dart';
import '../../customers/widgets/edit_customer_modal.widget.dart';

class CustomerCardWidget extends StatefulWidget {
  const CustomerCardWidget({
    super.key,
    required this.customer,
    required this.removeTableCustomer,
    required this.setCustomerAtIndex,
    required this.index,
  });

  final CustomerEntity customer;
  final void Function() removeTableCustomer;
  final void Function(CustomerEntity customer, int index) setCustomerAtIndex;
  final int index;

  @override
  State<CustomerCardWidget> createState() => _CustomerCardWidgetState();
}

class _CustomerCardWidgetState extends State<CustomerCardWidget> {
  final CustomersStore customersStore = GetIt.I<CustomersStore>();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.person_outline),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customer.id == 0 ? 'Cliente ${widget.index + 1}' : widget.customer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.customer.id == 0 ? 'Não informado' : widget.customer.phone,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  widget.customer.id == 0
                      ? PopupMenuButton(
                          tooltip: 'Procurar cliente',
                          elevation: 3,
                          surfaceTintColor: Colors.transparent,
                          itemBuilder: (ctx) {
                            return [
                              PopupMenuItem(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const EditCustomerModal(),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_1_outlined,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Novo cliente',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...customersStore.customers
                                  .map((customer) => PopupMenuItem(
                                        onTap: () {
                                          widget.setCustomerAtIndex(customer, widget.index);
                                          customersStore.removeCustomer(customer);
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_2_outlined,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  customer.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  customer.phone,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()
                            ];
                          },
                          child: const Icon(Icons.search),
                        )
                      : IconButton(
                          icon: const Icon(Icons.link_off),
                          onPressed: widget.removeTableCustomer,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
