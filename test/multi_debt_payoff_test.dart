import 'package:flutter_test/flutter_test.dart';
import 'package:granary/util/payoff.dart';

void main() {
  // Two debts where the strategies genuinely disagree: the smaller balance
  // has the lower rate, so snowball clears it first while avalanche attacks
  // the expensive one.
  final debts = [
    const DebtInput(
        id: 1, balanceCents: 200000, apr: 5, minimumPaymentCents: 5000),
    const DebtInput(
        id: 2, balanceCents: 900000, apr: 24, minimumPaymentCents: 20000),
  ];

  test('avalanche costs less interest than snowball when rates differ', () {
    final snowball = simulateMultiDebtPayoff(
        debts: debts,
        strategy: PayoffStrategy.snowball,
        extraCents: 30000)!;
    final avalanche = simulateMultiDebtPayoff(
        debts: debts,
        strategy: PayoffStrategy.avalanche,
        extraCents: 30000)!;

    expect(avalanche.totalInterestCents,
        lessThan(snowball.totalInterestCents),
        reason: 'attacking the 24% debt first must save real money');
  });

  test('the strategies clear debts in different orders', () {
    final snowball = simulateMultiDebtPayoff(
        debts: debts,
        strategy: PayoffStrategy.snowball,
        extraCents: 30000)!;
    final avalanche = simulateMultiDebtPayoff(
        debts: debts,
        strategy: PayoffStrategy.avalanche,
        extraCents: 30000)!;

    expect(snowball.payoffOrder.first, 1,
        reason: 'snowball clears the small balance first');
    expect(avalanche.payoffOrder.first, 2,
        reason: 'avalanche clears the expensive debt first');
  });

  test('with two debts and no extra, the strategies are identical', () {
    // There is no spare money to direct, and once the first debt clears
    // there is only one left to receive its freed-up minimum — so there is
    // no ordering decision to make. Reporting them as equal is correct.
    final snowball = simulateMultiDebtPayoff(
        debts: debts, strategy: PayoffStrategy.snowball)!;
    final avalanche = simulateMultiDebtPayoff(
        debts: debts, strategy: PayoffStrategy.avalanche)!;

    expect(avalanche.totalInterestCents, snowball.totalInterestCents);
    expect(avalanche.months, snowball.months);
  });

  test('with three debts, freed-up minimums make the order matter even '
      'with no extra', () {
    final three = [
      ...debts,
      const DebtInput(
          id: 3, balanceCents: 400000, apr: 15, minimumPaymentCents: 9000),
    ];
    final snowball = simulateMultiDebtPayoff(
        debts: three, strategy: PayoffStrategy.snowball)!;
    final avalanche = simulateMultiDebtPayoff(
        debts: three, strategy: PayoffStrategy.avalanche)!;

    expect(avalanche.totalInterestCents,
        lessThan(snowball.totalInterestCents),
        reason: 'with a real choice of where freed money goes, avalanche '
            'wins even without extra payments');
  });

  test('a single debt makes the strategies identical', () {
    final one = [debts.first];
    final snowball = simulateMultiDebtPayoff(
        debts: one, strategy: PayoffStrategy.snowball, extraCents: 10000)!;
    final avalanche = simulateMultiDebtPayoff(
        debts: one, strategy: PayoffStrategy.avalanche, extraCents: 10000)!;

    expect(snowball.months, avalanche.months);
    expect(snowball.totalInterestCents, avalanche.totalInterestCents);
  });

  test('extra payments shorten the plan', () {
    final none = simulateMultiDebtPayoff(
        debts: debts, strategy: PayoffStrategy.avalanche)!;
    final extra = simulateMultiDebtPayoff(
        debts: debts,
        strategy: PayoffStrategy.avalanche,
        extraCents: 50000)!;

    expect(extra.months, lessThan(none.months));
    expect(extra.totalInterestCents, lessThan(none.totalInterestCents));
  });

  test('debts whose minimums cannot cover interest have no projection', () {
    final hopeless = [
      const DebtInput(
          id: 1, balanceCents: 1000000, apr: 24, minimumPaymentCents: 15000),
    ];
    expect(
        simulateMultiDebtPayoff(
            debts: hopeless, strategy: PayoffStrategy.avalanche),
        isNull);
  });

  test('no debts is a finished plan, not an error', () {
    final done =
        simulateMultiDebtPayoff(debts: [], strategy: PayoffStrategy.snowball)!;
    expect(done.months, 0);
    expect(done.totalInterestCents, 0);
  });
}
