import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:teste_flutter/features/tables/stores/table.store.dart';
import 'package:teste_flutter/features/tables/stores/tables.store.dart';
import 'package:teste_flutter/features/tables/widgets/customer_card_widget.dart';
import 'package:teste_flutter/features/tables/widgets/customer_search_field.dart';
import 'package:teste_flutter/shared/widgets/modal.widget.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';

import '../../customers/entities/customer.entity.dart';

class TableModalWidget extends StatefulWidget {
  const TableModalWidget({
    super.key,
    this.oldTableStore,
  });

  final TableStore? oldTableStore;

  @override
  State<TableModalWidget> createState() => _TableModalWidgetState();
}

class _TableModalWidgetState extends State<TableModalWidget> {
  final TablesStore tablesStore = GetIt.I<TablesStore>();
  final CustomersStore customersStore = GetIt.I<CustomersStore>();
  final TableStore newTableStore = TableStore();
  final TextEditingController identificationController = TextEditingController();
  final TextEditingController cardQuantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.oldTableStore != null) {
      newTableStore.setIdentification(widget.oldTableStore!.identification);
      for (var element in widget.oldTableStore!.customers) {
        newTableStore.addCustomer(element);
      }
    }
    identificationController.text = newTableStore.identification;
    cardQuantityController.text = newTableStore.customers.length.toString();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.oldTableStore == null) {
        tablesStore.addTable(newTableStore);
      } else {
        tablesStore.updateTable(
          newTableStore,
          widget.oldTableStore!.identification,
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle greyTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );

    return Observer(
      builder: (context) {
        return Form(
          key: _formKey,
          child: Modal(
            width: 340,
            title:
                widget.oldTableStore == null ? 'Criar mesa' : 'Editar informações da ${newTableStore.identification}',
            content: [
              SizedBox(
                height: 700,
                child: SingleChildScrollView(
                  child: Observer(
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Identificação da mesa',
                            ),
                            controller: identificationController,
                            onChanged: newTableStore.setIdentification,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Informação temporaria para ajudar na identificação do cliente.',
                            style: greyTextStyle,
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          const Text(
                            'Clientes nesta conta',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Associe os clientes aos pedidos para salvar o pedido no histórico do cliente, pontuar no fidelidade e fazer pagamento no fiado.',
                            style: greyTextStyle,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantidade de pessoas',
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  controller: cardQuantityController,
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: const Icon(Icons.remove),
                                    onTap: () {
                                      newTableStore.removeLastCustomer();
                                      setState(() {
                                        cardQuantityController.text = newTableStore.customers.length.toString();
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: const Icon(Icons.add),
                                    onTap: () {
                                      newTableStore.addCustomer(
                                        CustomerEntity(
                                          id: 0,
                                          name: '',
                                          phone: '',
                                        ),
                                      );
                                      setState(() {
                                        cardQuantityController.text = newTableStore.customers.length.toString();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: newTableStore.customers.length,
                            itemBuilder: (context, index) {
                              return CustomerCardWidget(
                                customer: newTableStore.customers[index],
                                removeTableCustomer: () {
                                  customersStore.addCustomer(newTableStore.customers[index]);
                                  newTableStore.removeTableCustomer(newTableStore.customers[index]);
                                  setState(() {
                                    cardQuantityController.text = newTableStore.customers.length.toString();
                                  });
                                },
                                index: index,
                                setCustomerAtIndex: newTableStore.updateCustomerAtIndex,
                              );
                            },
                          ),
                          CustomerSearchField(
                            addCustomer: newTableStore.addCustomer,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(onPressed: () => Navigator.of(context).pop(), text: 'Cancelar'),
                  const SizedBox(width: 12),
                  PrimaryButton(onPressed: () => _submitForm(), text: 'Salvar'),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
