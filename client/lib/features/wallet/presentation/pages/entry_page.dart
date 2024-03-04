import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/extension.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Edit Entry',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: entryComponent.entry.amount.toString(),
                      decoration: const InputDecoration(
                        hintText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 10,
                      onChanged: (value) =>
                          entry = entry.copyWith(amount: double.parse(value)),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: entryComponent.entry.description,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      maxLines: 5,
                      maxLength: 100,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          entry = entry.copyWith(description: value),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField(
                      isExpanded: true,
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
      persistentFooterButtons: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                log('entry: ${entry.toJson()}');
                context.read<ComponentCubit>().updateEntry(entry);
                Navigator.pop(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Save')],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Cancel')],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EntryPage extends StatelessWidget {
  const EntryPage({
    super.key,
    required this.component,
  });

  final PocketComponent component;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Entries',
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          final components = context
              .read<ComponentCubit>()
              .getAllEntries(component.pocket.id) as List<EntryComponent>;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ComponentCubit>().getComponents();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Card(
                    elevation: 0,
                    color: context.theme.secondaryHeaderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        '\$ ${context.read<ComponentCubit>().getFormatTotalEntry(component)}',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                if (components.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No entries found'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      for (final entryComponent in components.reversed.toList())
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              context
                                  .read<ComponentCubit>()
                                  .deleteEntry(entryComponent.entry.id);
                            },
                            background: Container(
                              color: context.theme.primaryColor,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.delete),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(
                                  context.formatCurrency(
                                    entryComponent.entry.amount.toString(),
                                  ),
                                  style: context.theme.textTheme.titleMedium,
                                ),
                                subtitle:
                                    Text(entryComponent.entry.description),
                                leading: CircleAvatar(
                                  backgroundColor: entryComponent.entry.type ==
                                          EntryType.income
                                      ? context.theme.colorScheme.primary
                                      : context.theme.colorScheme.secondary,
                                  child: Icon(
                                    entryComponent.entry.type ==
                                            EntryType.income
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                ),
                                trailing: Text(
                                  entryComponent.entry.dateFormatted,
                                  style: context.theme.textTheme.titleSmall,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  _createRoute(entryComponent),
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
            //show full screen bottom sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return EntryForm(component: component);
              },
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
    required this.component,
  });

  final PocketComponent component;

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
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButtonFormField(
                      isExpanded: true,
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
                    ),
                    ListenableBuilder(
                      listenable: _amountController,
                      builder: (context, _) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                '\$ ${context.formatCurrency(_amountController.text.isEmpty ? '0' : _amountController.text)}',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                            ListenableBuilder(
                              listenable: _typeController,
                              builder: (context, _) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    'Balance: \$ ${getFormatTotal(widget.component)}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    NumericKeyboard(
                      rightIcon: const Icon(Icons.backspace),
                      leftIcon: const Icon(Icons.cancel),
                      onKeyboardTap: (value) {
                        if (_amountController.text.length >= 7) {
                          return;
                        }

                        _amountController.text = _amountController.text + value;
                      },
                      leftButtonFn: () => Navigator.pop(context),
                      rightButtonFn: () {
                        if (_amountController.text.isEmpty) {
                          return;
                        }
                        _amountController.text = _amountController.text
                            .substring(0, _amountController.text.length - 1);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<ComponentCubit>().createEntry(
                      Entry(
                        id: 0,
                        pocketId: widget.component.pocket.id,
                        description: _descriptionController.text,
                        amount: double.parse(_amountController.text),
                        createdAt: DateTime.now(),
                        type: _typeController.value,
                      ),
                    );
                Navigator.pop(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Save')],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFormatTotal(PocketComponent component) {
    double total = 0;
    if (_typeController.value == EntryType.income) {
      total = context.read<ComponentCubit>().getTotal(component) +
          double.parse(
              _amountController.text.isEmpty ? '0' : _amountController.text);
    } else {
      total = context.read<ComponentCubit>().getTotal(component) -
          double.parse(
              _amountController.text.isEmpty ? '0' : _amountController.text);
    }

    return context.formatCurrency(total.toString());
  }
}

Route _createRoute(Component component) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        EntryDetailPage(component: component),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
