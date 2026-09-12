import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Whether a budget entry adds to or subtracts from the month.
enum EntryType { income, expense }

/// Kind of account. Credit and loan balances are tracked in their own
/// tables; these are the cash/asset side of net worth.
enum AccountType { checking, savings, cash, investment, retirement, other }

/// A bank, cash, or investment account.
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  TextColumn get institution => text().nullable()();
  TextColumn get type => textEnum<AccountType>()();
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();

  /// The statement balance this account was last reconciled to, and when —
  /// null until the first reconciliation. Not touched by day-to-day
  /// balance edits; only [HomebaseRepository.reconcileAccount] sets it.
  IntColumn get reconciledBalanceCents => integer().nullable()();
  DateTimeColumn get reconciledAt => dateTime().nullable()();
}

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  TextColumn get pinHash => text().nullable()();
  BoolColumn get isAdmin => boolean().withDefault(const Constant(false))();
}

class CreditCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();
  IntColumn get creditLimitCents => integer()(); // `limit` is an SQL keyword
  RealColumn get apr => real().withDefault(const Constant(0))();
  IntColumn get annualFeeCents => integer().withDefault(const Constant(0))();
  IntColumn get monthlyFeeCents => integer().withDefault(const Constant(0))();

  /// Day of month the statement closes.
  IntColumn get statementCloseDay => integer().nullable()();

  /// Day of month the payment is due, typically ~21-25 days after closing.
  IntColumn get paymentDueDay => integer().nullable()();

  /// Minimum payment shown on the current statement, when known. The payoff
  /// simulator prefers this over its own estimate.
  IntColumn get minimumPaymentDueCents => integer().nullable()();

  /// When the annual fee next hits. The amount is [annualFeeCents], which
  /// already feeds the budget set-aside — a second amount field here could
  /// disagree with it.
  DateTimeColumn get annualFeeDate => dateTime().nullable()();
}

/// Which kind of debt a payment was made against.
enum PaymentAccountType { card, loan }

/// A logged payment toward a card or loan. Kept as its own history so a
/// balance can be explained (and recomputed) rather than just overwritten.
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get accountType => textEnum<PaymentAccountType>()();

  /// Row id in CreditCards or Loans, depending on [accountType]. Not a
  /// foreign key because it points at one of two tables; cleanup is handled
  /// when a card or loan is deleted.
  IntColumn get accountId => integer()();

  IntColumn get amountCents => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  /// The bank or cash account this payment actually came from, when known.
  /// Optional — logging a payment still works without it, same as before;
  /// setting it also deducts the amount from that account's balance.
  IntColumn get fromAccountId =>
      integer().nullable().references(Accounts, #id)();
}

/// Point-in-time record of net worth, so the trend can be charted. Written
/// whenever a balance changes, at most once per day.
class NetWorthSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();

  /// Midnight of the day being recorded — one snapshot per profile per day.
  DateTimeColumn get date => dateTime()();
  IntColumn get totalAssetsCents => integer()();
  IntColumn get totalDebtCents => integer()();
  IntColumn get netWorthCents => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {profileId, date},
      ];
}

/// Point-in-time record of a single account's balance, so a sparkline can
/// show its recent trend. Written whenever the balance changes, at most
/// once per day per account — the same pattern as [NetWorthSnapshots].
class AccountBalanceSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get balanceCents => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {accountId, date},
      ];
}

/// Saving toward something, or paying something off.
enum GoalType { savings, payoff }

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  TextColumn get type => textEnum<GoalType>()();
  IntColumn get targetAmountCents => integer()();
  IntColumn get currentAmountCents =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();

  /// When set, progress is read live from this account's balance instead of
  /// the manually-entered [currentAmountCents] — e.g. a savings goal tied to
  /// the real account it's funded from, so it never drifts out of sync.
  IntColumn get accountId => integer().nullable().references(Accounts, #id)();
}

class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get balanceCents => integer()();
  IntColumn get originalAmountCents => integer()();
  RealColumn get apr => real().withDefault(const Constant(0))();
  IntColumn get monthlyPaymentCents => integer().withDefault(const Constant(0))();
}

/// How often a bill comes due.
enum BillFrequency { monthly, quarterly, annual, oneTime }

/// Which table [Bills.paymentSourceId] points into.
enum PaymentSourceType { account, card }

class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get amountCents => integer()();
  IntColumn get dueDay => integer()(); // 1-31, clamped to month length
  TextColumn get frequency =>
      textEnum<BillFrequency>().withDefault(const Constant('monthly'))();

  /// What the bill is paid with, e.g. a specific checking account or credit
  /// card. When set, marking the bill paid moves real money: it comes off
  /// an account's balance or onto a card's, the same as materializing it
  /// via autopay does.
  TextColumn get paymentSourceType => textEnum<PaymentSourceType>().nullable()();

  /// Row id in Accounts or CreditCards, depending on [paymentSourceType].
  /// Not a foreign key because it points at one of two tables; cleanup is
  /// handled when an account or card is deleted.
  IntColumn get paymentSourceId => integer().nullable()();

  /// If true, the bill is charged automatically. Once its due day passes it
  /// is treated as paid with no manual check-off, and it never shows the
  /// overdue warning.
  BoolColumn get autopay => boolean().withDefault(const Constant(false))();

  /// Month it falls in. Required for annual and one-time bills; for
  /// quarterly it is the anchor month, repeating every three months.
  /// Unused for monthly bills.
  IntColumn get dueMonth => integer().nullable()();

  /// One-time bills only.
  IntColumn get dueYear => integer().nullable()();

  TextColumn get category => text().withDefault(const Constant('Other'))();
}

/// One row per bill per month it was paid for. "Paid" is derived from the
/// presence of a row for the current month, so status rolls over on its own
/// when the calendar month changes — nothing to reset by hand.
class BillPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get billId =>
      integer().references(Bills, #id, onDelete: KeyAction.cascade)();

  /// Midnight on the first day of the month this payment covers.
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get paidAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {billId, periodStart},
      ];
}

class CreditScoreSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get score => integer()();
  RealColumn get utilization => real()(); // 0.0 - 1.0
  IntColumn get derogatoryMarks => integer().withDefault(const Constant(0))();
  IntColumn get accountAgeMonths => integer().withDefault(const Constant(0))();
  IntColumn get hardInquiries => integer().withDefault(const Constant(0))();
}

/// One CSV import run, so its entries can all be undone together without
/// hunting for them individually.
@DataClassName('ImportBatch')
class ImportBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get sourceFilename => text()();
  DateTimeColumn get importedAt => dateTime()();
  IntColumn get rowCount => integer()();

  /// The account these transactions were imported into. Not a foreign key
  /// with cascade — deleting the account just clears this (see
  /// deleteAccount), same as every other account link in this schema.
  IntColumn get accountId => integer().nullable().references(Accounts, #id)();

  /// Net amount applied to [accountId]'s balance when this batch was
  /// committed, or 0 if the import left the balance alone. Recorded here
  /// rather than re-derived from the entries, so undo reverses exactly
  /// what happened even if entries were edited afterward.
  IntColumn get balanceAdjustmentCents =>
      integer().withDefault(const Constant(0))();
}

class BudgetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text().withDefault(const Constant('Other'))();
  IntColumn get amountCents => integer()();
  TextColumn get type => textEnum<EntryType>()();
  TextColumn get description => text().nullable()(); // matched by CategoryRules
  /// Who was paid or who paid you — separate from the free-text description,
  /// so "top payees" can be totaled without parsing description text.
  TextColumn get payee => text().nullable()();
  /// Which account the money moved through, when known.
  IntColumn get accountId => integer().nullable().references(Accounts, #id)();

  /// Which card the money was charged to or credited from, when known.
  /// Mutually exclusive with [accountId] in practice — the entry moves
  /// through one or the other, never both.
  IntColumn get cardId =>
      integer().nullable().references(CreditCards, #id)();

  /// Set when this entry was generated automatically because a paycheck was
  /// marked received — keeps the two in sync instead of double-entry.
  IntColumn get sourcePaycheckId =>
      integer().nullable().references(Paychecks, #id, onDelete: KeyAction.cascade)();

  /// Set when this entry was generated automatically because a bill was
  /// marked paid. Deleting the payment (or the bill) removes this entry.
  IntColumn get sourceBillPaymentId => integer()
      .nullable()
      .references(BillPayments, #id, onDelete: KeyAction.cascade)();

  /// Set when this entry came from a CSV import, so the whole batch can be
  /// undone together. Imported entries deliberately do not move any
  /// account or card balance on their own — see [ImportBatches].
  IntColumn get importBatchId => integer()
      .nullable()
      .references(ImportBatches, #id, onDelete: KeyAction.cascade)();
}

/// One slice of a split transaction — e.g. a single $150 store run entered
/// as $100 groceries + $50 household. When an entry has splits, the splits'
/// categories are what is shown and counted per-category; the parent
/// entry's own [BudgetEntries.category] is left as a fallback for display
/// contexts that do not know about splits.
class TransactionSplits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get entryId => integer()
      .references(BudgetEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get category => text()();
  IntColumn get amountCents => integer()();
}

/// Per-category monthly spending target for the budget screen.
class BudgetTargets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get category => text().withLength(min: 1, max: 64)();
  IntColumn get monthlyTargetCents => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {profileId, category},
      ];
}

/// What part of a budget entry a categorization rule matches against.
enum RuleField { description, amount }

/// Auto-categorization: when a new entry's [field] matches [pattern]
/// (case-insensitive substring for description, exact value for amount),
/// assign [category]. First match by [priority] wins.
class CategoryRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get field => textEnum<RuleField>()();
  TextColumn get pattern => text().withLength(min: 1, max: 128)();
  TextColumn get category => text().withLength(min: 1, max: 64)();
  IntColumn get priority => integer().withDefault(const Constant(0))();
}

/// How often a paycheck schedule pays out.
enum PayFrequency { weekly, biweekly, semimonthly, monthly }

/// A recurring paycheck: set it once and the app generates the individual
/// checks. Amounts are after-tax (take-home).
class PaycheckSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)(); // e.g. "Day job"
  TextColumn get frequency => textEnum<PayFrequency>()();
  DateTimeColumn get anchorDate => dateTime()(); // first/next known payday
  IntColumn get amountCents => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

/// An expected or received paycheck to plan against.
class Paychecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  DateTimeColumn get date => dateTime()();
  IntColumn get amountCents => integer()();
  IntColumn get bonusCents => integer().withDefault(const Constant(0))();
  BoolColumn get received => boolean().withDefault(const Constant(false))();

  /// True once you set [received] by hand. Automatic processing skips these
  /// rows, so overriding a paycheck (it was delayed, it never arrived) is
  /// not undone the next time the app opens.
  BoolColumn get receivedIsManual =>
      boolean().withDefault(const Constant(false))();

  /// Deleted by you. The row is kept rather than removed so the schedule
  /// that produced it doesn't just generate the same payday again; it is
  /// hidden everywhere in the UI.
  BoolColumn get dismissed => boolean().withDefault(const Constant(false))();

  /// Set when this check was generated from a schedule.
  IntColumn get scheduleId =>
      integer().nullable().references(PaycheckSchedules, #id)();
}

/// "From this paycheck, [amountCents] goes to [target]" — e.g. Savings, Rent.
/// Optionally linked to a Bill so paying it can mark the bill paid.
class PaycheckAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get paycheckId =>
      integer().references(Paychecks, #id, onDelete: KeyAction.cascade)();
  TextColumn get target => text().withLength(min: 1, max: 64)();
  IntColumn get amountCents => integer()();
  IntColumn get billId => integer().nullable().references(Bills, #id)();
}

/// A free-form label that can span multiple categories, for cross-cutting
/// totals a category alone can't capture (e.g. "vacation2026").
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 32)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {profileId, name},
      ];
}

/// Many-to-many: which tags apply to which budget entry.
class BudgetEntryTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId =>
      integer().references(BudgetEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {entryId, tagId},
      ];
}

/// A recurring, automatic movement of money between two of your own
/// accounts (e.g. $200 checking -> savings every month). This is not income
/// or spending, so it never touches BudgetEntries — just the two balances.
/// Deleting either account cascades into deleting the transfer: a transfer
/// with only one side left cannot mean anything.
class RecurringTransfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text().withLength(min: 1, max: 64)();
  IntColumn get fromAccountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get toAccountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountCents => integer()();
  TextColumn get frequency => textEnum<PayFrequency>()();
  DateTimeColumn get anchorDate => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

/// One row per transfer occurrence actually executed, so a schedule never
/// double-moves money for a date it already ran, and there is a real history
/// to show — the same pattern as [BillPayments] for bills.
class TransferLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get transferId => integer()
      .references(RecurringTransfers, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get amountCents => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {transferId, date},
      ];
}

@DriftDatabase(tables: [
  Profiles,
  Accounts,
  CreditCards,
  Loans,
  Bills,
  BillPayments,
  CreditScoreSnapshots,
  BudgetEntries,
  BudgetTargets,
  CategoryRules,
  Payments,
  NetWorthSnapshots,
  AccountBalanceSnapshots,
  Goals,
  PaycheckSchedules,
  Paychecks,
  PaycheckAllocations,
  Tags,
  BudgetEntryTags,
  RecurringTransfers,
  TransferLogs,
  TransactionSplits,
  ImportBatches,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 20;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(accounts);
            await m.addColumn(budgetEntries, budgetEntries.accountId);
          }
          if (from < 3) {
            await m.createTable(billPayments);
            // Carry any bills currently flagged paid into a payment record
            // for the current month, then drop the boolean column.
            final now = DateTime.now();
            final periodStart = DateTime(now.year, now.month);
            await customInsert(
              'INSERT INTO bill_payments '
              '(profile_id, bill_id, period_start, paid_at) '
              'SELECT profile_id, id, ?, ? FROM bills '
              'WHERE paid_this_month = 1',
              variables: [
                Variable.withInt(periodStart.millisecondsSinceEpoch ~/ 1000),
                Variable.withInt(now.millisecondsSinceEpoch ~/ 1000),
              ],
            );
            await m.addColumn(creditCards, creditCards.statementCloseDay);
            await m.addColumn(creditCards, creditCards.paymentDueDay);
          }
          if (from < 4) {
            // Bills gain a frequency. Anything previously marked recurring
            // becomes monthly; the rest become one-time in the current month.
            final now = DateTime.now();
            await m.addColumn(bills, bills.dueMonth);
            await m.addColumn(bills, bills.dueYear);
            await m.addColumn(bills, bills.frequency);
            await customUpdate(
              "UPDATE bills SET frequency = CASE WHEN recurring = 1 "
              "THEN 'monthly' ELSE 'oneTime' END, "
              'due_month = CASE WHEN recurring = 1 THEN NULL ELSE ?1 END, '
              'due_year = CASE WHEN recurring = 1 THEN NULL ELSE ?2 END',
              variables: [
                Variable.withInt(now.month),
                Variable.withInt(now.year),
              ],
              updates: {bills},
            );
          }
          if (from < 5) {
            await m.addColumn(bills, bills.autopay);
          }
          if (from < 6) {
            await m.addColumn(budgetEntries, budgetEntries.sourcePaycheckId);
          }
          if (from < 7) {
            await m.addColumn(
                budgetEntries, budgetEntries.sourceBillPaymentId);
          }
          if (from < 9) {
            await m.addColumn(paychecks, paychecks.dismissed);
          }
          if (from < 10) {
            await m.createTable(payments);
            await m.createTable(netWorthSnapshots);
            await m.createTable(goals);
            await m.addColumn(creditCards, creditCards.annualFeeDate);
          }
          if (from < 11) {
            // statementDay becomes statementCloseDay: same meaning, clearer
            // name now that a statement *balance* exists alongside it.
            if (from >= 3) {
              await m.renameColumn(
                  creditCards, 'statement_day', creditCards.statementCloseDay);
            }
            // statement_balance_cents no longer exists as of v13 (see
            // below), so it is added here with raw SQL rather than the
            // typed column, which the current schema class has dropped.
            await customStatement(
                'ALTER TABLE credit_cards ADD COLUMN '
                'statement_balance_cents INTEGER NOT NULL DEFAULT 0');
            await m.addColumn(
                creditCards, creditCards.minimumPaymentDueCents);
            // Seed the statement balance from the current balance so
            // utilization is not zero for everyone on first launch.
            await customUpdate(
              'UPDATE credit_cards SET statement_balance_cents = '
              'balance_cents WHERE statement_balance_cents = 0',
              updates: {creditCards},
            );
          }
          if (from < 8) {
            await m.addColumn(paychecks, paychecks.receivedIsManual);
            // Anything already marked received was marked by hand, so keep
            // it that way rather than letting automation reinterpret it.
            await customUpdate(
              'UPDATE paychecks SET received_is_manual = 1 WHERE received = 1',
              updates: {paychecks},
            );
          }
          if (from < 4) {
            // Every bills column added by a later step must exist before
            // this rebuild runs, since it copies data using the table's
            // current (newest) Dart column set.
            await m.addColumn(bills, bills.paymentSourceType);
            await m.addColumn(bills, bills.paymentSourceId);
            // Rebuild bills once, after every column addition (including
            // autopay above), to drop columns no longer in the schema:
            // paid_this_month (replaced by BillPayments) and recurring
            // (replaced by frequency).
            await m.alterTable(TableMigration(bills));
          }
          if (from < 12) {
            await m.addColumn(budgetEntries, budgetEntries.payee);
            // Anyone upgrading from before v10 gets goals.accountId for
            // free: createTable above already used the current (v12) column
            // set, so adding it again here would collide.
            if (from >= 10) {
              await m.addColumn(goals, goals.accountId);
            }
            await m.createTable(tags);
            await m.createTable(budgetEntryTags);
            await m.createTable(recurringTransfers);
            await m.createTable(transferLogs);
          }
          if (from < 13) {
            // Two dollar amounts for one card (current vs. reported to the
            // bureaus) was more confusing than useful — utilization is now
            // judged off the real balance instead.
            await m.alterTable(TableMigration(creditCards));
          }
          if (from < 14) {
            await m.createTable(accountBalanceSnapshots);
          }
          if (from < 15) {
            // Upgraders from before v4 already gained these columns above,
            // ahead of the bills rebuild that step performs.
            if (from >= 4) {
              await m.addColumn(bills, bills.paymentSourceType);
              await m.addColumn(bills, bills.paymentSourceId);
            }
          }
          if (from < 16) {
            await m.createTable(transactionSplits);
          }
          if (from < 17) {
            await m.addColumn(budgetEntries, budgetEntries.cardId);
          }
          if (from < 18) {
            // Upgraders from before v10 already gained this column above —
            // createTable(payments) there always uses the current (v18)
            // Dart column set, so adding it again here would collide.
            if (from >= 10) {
              await m.addColumn(payments, payments.fromAccountId);
            }
          }
          if (from < 19) {
            await m.createTable(importBatches);
            await m.addColumn(budgetEntries, budgetEntries.importBatchId);
          }
          if (from < 20) {
            // Upgraders from before v2 already gained these columns above —
            // createTable(accounts) there always uses the current (v20)
            // Dart column set, so adding them again here would collide.
            if (from >= 2) {
              await m.addColumn(accounts, accounts.reconciledBalanceCents);
              await m.addColumn(accounts, accounts.reconciledAt);
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Where the database file lives, or null when it is in memory.
  Future<String?> get databasePath async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'clearly.sqlite'));
    return file.existsSync() ? file.path : null;
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'clearly.sqlite'));
      await _migrateFromRename(file);
      return NativeDatabase.createInBackground(file);
    });
  }

  /// The app has been renamed four times (homebase -> homebase_finance ->
  /// homebase_money -> granary -> clearly), and on Linux and Android the
  /// application id decides where getApplicationSupportDirectory points,
  /// and each rename also renamed the database file itself. Without this,
  /// a rename would look to the user like their data had been wiped. Each
  /// previous directory is checked newest first, so an install that
  /// skipped a rename still finds its database.
  static Future<void> _migrateFromRename(File newFile) async {
    if (newFile.existsSync()) return;
    try {
      final support = await getApplicationSupportDirectory();
      const previousDirs = [
        ('dev.granary.granary', 'granary.sqlite'),
        ('dev.homebase.homebase_money', 'homebase.sqlite'),
        ('dev.homebase.homebase_finance', 'homebase.sqlite'),
        ('dev.homebase.homebase', 'homebase.sqlite'),
      ];
      for (final (id, filename) in previousDirs) {
        final oldFile = File(p.join(support.parent.path, id, filename));
        if (!oldFile.existsSync()) continue;
        await newFile.parent.create(recursive: true);
        await oldFile.copy(newFile.path);
        return;
      }
    } catch (_) {
      // Best-effort: if this fails, _openConnection just creates a fresh
      // database, same as any other first run.
    }
  }
}
