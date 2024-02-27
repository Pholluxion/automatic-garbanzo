import 'package:client/features/wallet/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/cubit/cubit.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

class PocketPage extends StatelessWidget {
  const PocketPage({
    super.key,
    required this.budgetId,
  });

  final int budgetId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pockets',
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          final components = context.read<ComponentCubit>().getAllPockets(budgetId);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ComponentCubit>().getComponents();
            },
            child: CustomScrollView(
              slivers: [
                if (components.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No pockets found.'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      for (final component in components as List<PocketComponent>)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              context.read<ComponentCubit>().deletePocket(component.pocket.id);
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
                                subtitle: Text(component.pocket.description),
                                leading: CircleAvatar(
                                  child: Text(component.getName().substring(0, 1)),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  _createRoute(component.pocket.id),
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
                return PocketForm(budgetId: budgetId);
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

Route _createRoute(int pocketId) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EntryPage(pocketId: pocketId),
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
