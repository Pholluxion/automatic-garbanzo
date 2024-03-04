import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/core.dart';
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
      title: 'pocket.title_plural'.tr(),
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
                  SliverFillRemaining(
                    child: Center(
                      child: const Text('pocket.not_found').tr(),
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
                            child: InkWell(
                              onLongPress: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PocketDetailPage(
                                    component: component,
                                  ),
                                ),
                              ),
                              onTap: () => Navigator.push(
                                context,
                                _createRoute(component),
                              ),
                              child: Card(
                                child: ListTile(
                                  title: Text(component.getName()),
                                  subtitle: Text(component.pocket.description),
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.account_balance_wallet),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    onPressed: () => Navigator.push(
                                      context,
                                      _createRoute(component),
                                    ),
                                  ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('pocket.create').tr(),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'pocket.create'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'common.name'.tr(),
                ),
                maxLength: 20,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'common.amount'.tr(),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 10,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'common.description'.tr(),
                ),
                maxLines: 5,
                maxLength: 100,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text('common.save').tr()],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
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

class PocketDetailPage extends StatelessWidget {
  const PocketDetailPage({
    super.key,
    required this.component,
  });

  final Component component;

  @override
  Widget build(BuildContext context) {
    final pocketComponent = component as PocketComponent;
    Pocket pocket = pocketComponent.pocket;
    return AppScaffold(
      title: 'pocket.edit'.tr(),
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
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: pocketComponent.pocket.name,
                      decoration: InputDecoration(
                        hintText: 'common.name'.tr(),
                      ),
                      maxLength: 20,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          pocket = pocket.copyWith(name: value),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: pocketComponent.pocket.amount.toString(),
                      decoration: InputDecoration(
                        hintText: 'common.amount'.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 10,
                      onChanged: (value) =>
                          pocket = pocket.copyWith(amount: double.parse(value)),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: pocketComponent.pocket.description,
                      decoration: InputDecoration(
                        hintText: 'common.description'.tr(),
                      ),
                      maxLines: 5,
                      maxLength: 100,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          pocket = pocket.copyWith(description: value),
                    ),
                    const SizedBox(height: 16.0),
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
                context.read<ComponentCubit>().updatePocket(pocket);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('common.save').tr()],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text('common.cancel').tr()],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
