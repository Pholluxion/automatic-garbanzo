import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/cubit/cubit.dart';
import 'package:client/features/wallet/presentation/pages/pages.dart';
import 'package:client/features/wallet/presentation/widgets/widgets.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Budgets',
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ComponentCubit>().getComponents();
            },
            child: CustomScrollView(
              slivers: [
                if (state.components.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No budgets found.'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      for (final component in state.components as List<BudgetComponent>)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              context.read<ComponentCubit>().deleteBudget(component.budget.id);
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
                                subtitle: Text(component.budget.description),
                                leading: CircleAvatar(
                                  child: Text(component.getName().substring(0, 1)),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  _createRoute(component.budget.id),
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
              builder: (context) => const BudgetForm(),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add Budget'),
            ],
          ),
        ),
      ],
    );
  }
}

Route _createRoute(int budgetId) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PocketPage(budgetId: budgetId),
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

class BudgetForm extends StatefulWidget {
  const BudgetForm({super.key});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _formKey.currentState?.dispose();
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
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ComponentCubit>().createBudget(
                      Budget(
                        id: 0,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        createdAt: DateTime.now(),
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
