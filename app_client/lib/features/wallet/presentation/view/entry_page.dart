import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:app_client/features/wallet/presentation/cubit/cubit.dart';
import 'package:app_client/l10n/l10n.dart';

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
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: Column(
        children: [
          Text(entryComponent.getName()),
          Text(entryComponent.entry.description),
          Text(entryComponent.entry.date.toString()),
          Text(entryComponent.entry.amount.toString()),
          Text(entryComponent.entry.pocketId.toString()),
        ],
      ),
    );
  }
}

class EntryPage extends StatelessWidget {
  const EntryPage({
    super.key,
    required this.components,
    required this.pocketId,
  });

  final List<Component> components;
  final int pocketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: ListView.builder(
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
                entry.entry.amount.toString(),
                style: TextStyle(
                  color: entry.entry.type == EntryType.income ? Colors.green : Colors.red,
                ),
              ),
              trailing: Text(entry.entry.date.toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<EntryCubit>().createEntry(
                Entry(
                  id: 0,
                  description: 'Test',
                  amount: 100,
                  date: DateTime.now(),
                  pocketId: pocketId,
                  type: EntryType.expense,
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PocketPage extends StatelessWidget {
  const PocketPage({
    super.key,
    required this.components,
    required this.budgetId,
  });

  final List<Component> components;
  final int budgetId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pockets')),
      body: ListView.builder(
        itemCount: components.length,
        itemBuilder: (context, index) {
          final pocket = components[index] as PocketComponent;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryPage(
                    pocketId: pocket.pocket.id,
                    components: pocket.components,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(pocket.getName()),
              subtitle: Text(pocket.pocket.description),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<PocketCubit>().createPocket(
                Pocket(
                  id: 0,
                  name: 'Test',
                  description: 'Test',
                  idBudget: budgetId,
                  createdAt: DateTime.now(),
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ComponentPage extends StatelessWidget {
  const ComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is ComponentLoaded) {
            return ListView.builder(
              itemCount: state.components.length,
              itemBuilder: (context, index) {
                final budgets = state.components[index] as BudgetComponent;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PocketPage(
                          components: budgets.components,
                          budgetId: budgets.budget.id,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      state.components[index].getName(),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Loading...'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<BudgetCubit>().createBudget(
                Budget(
                  id: 0,
                  name: 'Test',
                  description: 'Test',
                  createdAt: DateTime.now(),
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
