import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app_client/core/core.dart';
import 'package:app_client/l10n/l10n.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletAppBarTitle)),
      body: StreamBuilder(
        stream: ServiceLocator.instance.get<SupabaseClient>().from('expenses_incomes').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].toString()),
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
          final supabase = ServiceLocator.instance.get<SupabaseClient>();
          final id = supabase.auth.currentUser!.id;

          await supabase
              .from('expenses_incomes')
              .insert(
                {
                  'user_id': id,
                  'amount': 10000,
                  'description': 'test',
                  'type': 'income',
                  'date': DateTime.now().toIso8601String(),
                },
              )
              .select()
              .then((value) => log(value.toList().toString()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
