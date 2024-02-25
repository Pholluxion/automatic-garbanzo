import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_client/features/wallet/domain/domain.dart';
import 'package:app_client/features/wallet/presentation/cubit/cubit.dart';
import 'package:app_client/l10n/l10n.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: BlocBuilder<EntryCubit, EntryState>(
        builder: (context, state) {
          if (state is EntryLoaded) {
            final arg = ModalRoute.of(context)?.settings.arguments as int;
            final filter = state.entries.where((element) => element.pocketId == arg).toList();
            return ListView.builder(
              itemCount: filter.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filter[index].formattedDate),
                  subtitle: Text(filter[index].description.toString()),
                  leading: Text(
                    filter[index].amount.toString(),
                    style: TextStyle(color: filter[index].type == EntryType.income ? Colors.green : Colors.red),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<EntryCubit>().deleteEntry(filter[index].id);
                    },
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
          context.read<EntryCubit>().createEntry(
                Entry(
                  pocketId: 1,
                  description: 'Test',
                  amount: 50000,
                  date: DateTime.now(),
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
  const PocketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: BlocBuilder<PocketCubit, PocketState>(
        builder: (context, state) {
          if (state is PocketLoaded) {
            return ListView.builder(
              itemCount: state.pockets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.pockets[index].name),
                  subtitle: Text(state.pockets[index].description),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/pocket_entries',
                      arguments: state.pockets[index].id,
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}

class UserPocketPage extends StatelessWidget {
  const UserPocketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: BlocListener<PocketCubit, PocketState>(
        listener: (context, state) {
          if (state is PocketError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is PocketLoaded) {
            context.read<UserPocketCubit>().getUserPockets();
          }
        },
        child: BlocBuilder<UserPocketCubit, UserPocketState>(
          builder: (context, state) {
            if (state is UserPocketLoaded) {
              return ListView.builder(
                itemCount: state.userPockets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.userPockets[index].idUser),
                    subtitle: Text(state.userPockets[index].idPocket.toString()),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/pocket',
                      arguments: state.userPockets[index].idPocket,
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<PocketCubit>().createPocket(
                Pocket(
                  id: 0,
                  createdAt: DateTime.now(),
                  name: 'Test',
                  description: 'Test',
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
