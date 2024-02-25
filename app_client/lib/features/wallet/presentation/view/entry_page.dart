import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:app_client/features/wallet/presentation/cubit/cubit.dart';

class EntryDetailPage extends StatelessWidget {
  const EntryDetailPage({
    super.key,
    required this.component,
  });

  final Component component;

  @override
  Widget build(BuildContext context) {
    final entryComponent = component as EntryComponent;
    return Scaffold(
      appBar: AppBar(title: Text(component.getName())),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is ComponentLoading) {
            return const Center(child: Text('Loading...'));
          }
          return Column(
            children: [
              Text(entryComponent.getName()),
              Text(entryComponent.entry.description),
              Text(entryComponent.entry.createdAt.toString()),
              Text(entryComponent.entry.amount.toString()),
              Text(entryComponent.entry.pocketId.toString()),
            ],
          );
        },
      ),
    );
  }
}

class EntryPage extends StatelessWidget {
  const EntryPage({
    super.key,
    required this.pocketId,
  });

  final int pocketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entries')),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is ComponentLoading) {
            return const Center(child: Text('Loading...'));
          }

          final components = context.read<ComponentCubit>().getAllEntries(pocketId);

          return Stack(
            children: [
              ListView.builder(
                itemCount: components.length,
                itemBuilder: (context, index) {
                  final entry = components[index] as EntryComponent;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryDetailPage(
                            component: entry,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(entry.getName()),
                      subtitle: Text(entry.entry.description),
                      leading: Text(
                        entry.entry.formattedAmount,
                        style: TextStyle(
                          color: entry.entry.type == EntryType.income ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: Text(entry.entry.dateFormatted),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Scaffold.of(context).showBottomSheet(
                      (context) => EntryForm(pocketId: pocketId),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class EntryForm extends StatefulWidget {
  const EntryForm({
    super.key,
    required this.pocketId,
  });

  final int pocketId;

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _typeController = ValueNotifier(EntryType.income);

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _formKey.currentState?.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            ValueListenableBuilder(
              valueListenable: _typeController,
              builder: (context, value, child) {
                return DropdownButtonFormField(
                  value: _typeController.value,
                  items: const [
                    DropdownMenuItem(
                      value: EntryType.income,
                      child: Text('Income'),
                    ),
                    DropdownMenuItem(
                      value: EntryType.expense,
                      child: Text('Expense'),
                    ),
                  ],
                  onChanged: (value) {
                    _typeController.value = value as EntryType;
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ComponentCubit>().createEntry(
                      Entry(
                        id: 0,
                        pocketId: widget.pocketId,
                        description: _descriptionController.text,
                        amount: double.parse(_amountController.text),
                        createdAt: DateTime.now(),
                        type: _typeController.value,
                      ),
                    );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
