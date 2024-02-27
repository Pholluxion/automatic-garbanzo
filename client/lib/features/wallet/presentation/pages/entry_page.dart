import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/cubit/cubit.dart';
import 'package:client/features/wallet/presentation/widgets/widgets.dart';

class EntryDetailPage extends StatelessWidget {
  const EntryDetailPage({
    super.key,
    required this.component,
  });

  final Component component;

  @override
  Widget build(BuildContext context) {
    final entryComponent = component as EntryComponent;
    Entry entry = entryComponent.entry.copyWith();
    return AppScaffold(
      title: component.getName(),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          return Form(
            child: Column(
              children: [
                TextFormField(
                  initialValue: entryComponent.entry.description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => entry = entry.copyWith(description: value),
                ),
                TextFormField(
                  initialValue: entryComponent.entry.amount.toString(),
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => entry = entry.copyWith(amount: double.parse(value)),
                ),
                DropdownButtonFormField(
                  value: entryComponent.entry.type,
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
                    entry = entry.copyWith(type: value as EntryType);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    log('entry: ${entry.toJson()}');
                    context.read<ComponentCubit>().updateEntry(entry);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
      persistentFooterButtons: const [],
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
    return AppScaffold(
      title: 'Entries',
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          final components = context.read<ComponentCubit>().getAllEntries(pocketId);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ComponentCubit>().getComponents();
            },
            child: CustomScrollView(
              slivers: [
                if (components.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No entries found'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      for (final component in components as List<EntryComponent>)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              context.read<ComponentCubit>().deleteEntry(component.entry.id);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child: const Icon(Icons.delete),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(component.getName()),
                                subtitle: Text(component.entry.description),
                                leading: CircleAvatar(
                                  child: Text(component.getName().substring(0, 1)),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  _createRoute(component),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => EntryForm(pocketId: pocketId),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add Entry'),
            ],
          ),
        ),
      ],
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
              keyboardType: TextInputType.number,
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

Route _createRoute(Component component) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EntryDetailPage(component: component),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
