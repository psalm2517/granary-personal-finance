import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../main.dart';
import '../screens/accounts.dart' show accountIcon, accountTypeColor;
import '../util/money.dart';
import 'common.dart';

/// One account you can pay, from either the cards or the loans table.
class PayableAccount {
  const PayableAccount({
    required this.type,
    required this.id,
    required this.name,
    required this.balanceCents,
    this.suggestedCents,
  });

  final PaymentAccountType type;
  final int id;
  final String name;
  final int balanceCents;

  /// Pre-filled amount — a loan's monthly payment, where there is one.
  final int? suggestedCents;
}

/// Quick-add payment: pick an account, type an amount, done. Logs the
/// payment, reduces the balance, and everything derived from it (utilization,
/// net worth trend) follows automatically.
Future<bool> showQuickPaymentDialog(
  BuildContext context,
  WidgetRef ref, {
  required List<PayableAccount> accounts,
  PayableAccount? preselected,
  List<Account> fromAccounts = const [],
}) async {
  if (accounts.isEmpty) return false;
  var selected = preselected ?? accounts.first;
  final amount = TextEditingController(
      text: selected.suggestedCents == null
          ? ''
          : (selected.suggestedCents! / 100).toStringAsFixed(2));
  final note = TextEditingController();
  var date = DateTime.now();
  int? fromAccountId;

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setLocal) => SubmitOnEnter(
        onSubmit: () => Navigator.pop(context, true),
        child: AlertDialog(
          icon: const Icon(Icons.payments_outlined),
          title: const Text('Log a payment'),
          content: SizedBox(
            width: 400,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (accounts.length > 1)
                DropdownButtonFormField<PayableAccount>(
                  initialValue: selected,
                  decoration: const InputDecoration(
                      labelText: 'Paying', border: OutlineInputBorder()),
                  items: [
                    for (final a in accounts)
                      DropdownMenuItem(
                        value: a,
                        child: Row(children: [
                          Icon(
                              a.type == PaymentAccountType.card
                                  ? Icons.credit_card
                                  : Icons.request_quote_outlined,
                              size: 16),
                          const SizedBox(width: 8),
                          Text('${a.name} — ${fmtCents(a.balanceCents)}'),
                        ]),
                      ),
                  ],
                  onChanged: (v) => setLocal(() {
                    selected = v!;
                    if (selected.suggestedCents != null) {
                      amount.text =
                          (selected.suggestedCents! / 100).toStringAsFixed(2);
                    }
                  }),
                )
              else
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(selected.type == PaymentAccountType.card
                      ? Icons.credit_card
                      : Icons.request_quote_outlined),
                  title: Text(selected.name),
                  subtitle:
                      Text('Balance ${fmtCents(selected.balanceCents)}'),
                ),
              const SizedBox(height: 12),
              DialogField(amount, 'Amount (\$)',
                  autofocus: true,
                  helper: 'Comes off the balance straight away'),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text('Paid ${_fmtDate(date)}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040),
                      );
                      if (picked != null) setLocal(() => date = picked);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => setLocal(() => amount.text =
                      (selected.balanceCents / 100).toStringAsFixed(2)),
                  child: const Text('Pay in full'),
                ),
              ]),
              const SizedBox(height: 12),
              DialogField(note, 'Note (optional)'),
              if (fromAccounts.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: fromAccountId,
                  decoration: const InputDecoration(
                      labelText: 'Paid from (optional)',
                      helperText: 'Also deducts this amount from the '
                          'account\'s balance',
                      border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('Not linked')),
                    for (final a in fromAccounts)
                      DropdownMenuItem(
                        value: a.id,
                        child: Row(children: [
                          Icon(accountIcon(a.type),
                              size: 16,
                              color: accountTypeColor(context, a.type)),
                          const SizedBox(width: 8),
                          Text(a.name),
                        ]),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => fromAccountId = v),
                ),
              ],
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Log payment')),
          ],
        ),
      ),
    ),
  );

  if (saved != true) return false;
  final cents = parseDollarsToCents(amount.text);
  if (cents == null || cents <= 0) return false;

  await ref.read(repositoryProvider).addPayment(
        profileId: ref.read(activeProfileProvider)!.id,
        accountType: selected.type,
        accountId: selected.id,
        amountCents: cents,
        date: date,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
        fromAccountId: fromAccountId,
      );
  return true;
}

String _fmtDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[d.month - 1]} ${ordinalDay(d.day)}';
}
