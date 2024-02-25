import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/cubit/cubit.dart';
import 'package:client/features/wallet/presentation/view/view.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is ComponentLoaded) {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: state.components.length,
                  itemBuilder: (context, index) {
                    final budgets = state.components[index] as BudgetComponent;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PocketPage(
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
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Scaffold.of(context).showBottomSheet(
                        (context) => const BudgetForm(),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
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
