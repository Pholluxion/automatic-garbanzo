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
    return Scaffold(
      appBar: AppBar(title: const Text('Pockets')),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is ComponentLoading) {
            return const Center(child: Text('Loading...'));
          }

          final components = context.read<ComponentCubit>().getAllPockets(budgetId);

          return Stack(
            children: [
              ListView.builder(
                itemCount: components.length,
                itemBuilder: (context, index) {
                  final pocket = components[index] as PocketComponent;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryPage(pocketId: pocket.pocket.id),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(pocket.getName()),
                      subtitle: Text(pocket.pocket.description),
                      leading: Text(
                        pocket.pocket.formattedAmount,
                        style: const TextStyle(color: Colors.green),
                      ),
                      trailing: Text(pocket.pocket.createdAtFormatted),
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
                      (context) => PocketForm(budgetId: budgetId),
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
