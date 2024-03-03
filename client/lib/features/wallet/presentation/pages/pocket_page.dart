import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

class PocketPage extends StatelessWidget {
  const PocketPage({
    super.key,
    required this.component,
  });

  final BudgetComponent component;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pockets',
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          final components =
              context.read<ComponentCubit>().getAllPockets(component.budget.id);

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
                        '\$ ${context.read<ComponentCubit>().getFormatTotal(context.read<ComponentCubit>().getTotalBudget(component))}',
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
                      child: Text('No pockets found.'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      for (final component
                          in components as List<PocketComponent>)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              context
                                  .read<ComponentCubit>()
                                  .deletePocket(component.pocket.id);
                            },
                            background: Container(
                              color: context.theme.primaryColor,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child: const Icon(Icons.delete),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(component.getName()),
                                subtitle: Text(component.pocket.description),
                                leading: const CircleAvatar(
                                  child: Icon(Icons.account_balance_wallet),
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
              builder: (context) {
                return PocketForm(budgetId: component.budget.id);
              },
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add Pocket'),
            ],
          ),
        ),
      ],
    );
  }
}

class PocketForm extends StatefulWidget {
  const PocketForm({
    super.key,
    required this.budgetId,
  });

  final int budgetId;

  @override
  State<PocketForm> createState() => _PocketFormState();
}

class _PocketFormState extends State<PocketForm> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ComponentCubit>().createPocket(
                      Pocket(
                        id: 0,
                        amount: double.parse(_amountController.text),
                        name: _nameController.text,
                        description: _descriptionController.text,
                        idBudget: widget.budgetId,
                        createdAt: DateTime.now(),
                      ),
                    );

                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute(PocketComponent component) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        EntryPage(component: component),
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