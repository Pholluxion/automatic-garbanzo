import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/core.dart';
import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

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
            onRefresh: () async =>
                context.read<ComponentCubit>().getComponents(),
            child: CustomScrollView(
              slivers: [
                SliverVisibility(
                  visible: state.components.isNotEmpty,
                  sliver: SliverToBoxAdapter(
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
                          '\$ ${context.read<ComponentCubit>().getFormatTotalBudget()}',
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.components.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No budgets found.'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      for (final component
                          in state.components as List<BudgetComponent>)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) => context
                                .read<ComponentCubit>()
                                .deleteBudget(component.budget.id),
                            background: Container(
                              color: context.theme.primaryColor,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child: const Icon(Icons.delete),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(component.getName()),
                                subtitle: Text(component.budget.description),
                                leading: const CircleAvatar(
                                  child: Icon(
                                    Icons.wallet_rounded,
                                  ),
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

Route _createRoute(BudgetComponent component) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        PocketPage(component: component),
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
