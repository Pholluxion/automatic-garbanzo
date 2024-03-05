import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/core.dart';
import 'package:client/features/wallet/domain/domain.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'budget.title_plural'.tr(),
      body: BlocBuilder<ComponentCubit, ComponentState>(
        builder: (context, state) {
          if (state is! ComponentLoaded) {
            return const PageShimmer();
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<ComponentCubit>().getComponents(),
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
                  SliverFillRemaining(
                    child: Center(
                      child: const Text('budget.not_found').tr(),
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
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) =>
                                context.read<ComponentCubit>().deleteBudget(component.budget.id),
                            background: Container(
                              color: context.theme.primaryColor,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child: const Icon(Icons.delete),
                            ),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                _createRoute(component),
                              ),
                              onLongPress: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BudgetDetailPage(
                                    component: component,
                                  ),
                                ),
                              ),
                              child: Card(
                                child: ListTile(
                                  title: Text(component.getName()),
                                  subtitle: Text(component.budget.description),
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.wallet_rounded),
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
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => const BudgetForm(),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('budget.create'.tr()),
            ],
          ),
        ),
      ],
    );
  }
}

Route _createRoute(BudgetComponent component) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PocketPage(component: component),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'budget.create'.tr(),
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
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'common.description'.tr(),
              ),
              maxLines: 5,
              maxLength: 100,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Column(
              children: [
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('common.save'.tr())],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('budget.vinculate'.tr())],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class BudgetDetailPage extends StatelessWidget {
  const BudgetDetailPage({super.key, required this.component});

  final Component component;

  @override
  Widget build(BuildContext context) {
    final budgetComponent = component as BudgetComponent;
    Budget budget = budgetComponent.budget;
    return AppScaffold(
      title: 'budget.edit'.tr(),
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
                      initialValue: budgetComponent.budget.name,
                      decoration: InputDecoration(
                        hintText: 'common.name'.tr(),
                      ),
                      maxLength: 20,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => budget = budget.copyWith(name: value),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: budgetComponent.budget.description,
                      decoration: InputDecoration(
                        hintText: 'common.description'.tr(),
                      ),
                      maxLines: 5,
                      maxLength: 100,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => budget = budget.copyWith(description: value),
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
                context.read<ComponentCubit>().updateBudget(budget);
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
