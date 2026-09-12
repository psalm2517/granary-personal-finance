import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/util/payoff.dart';

void main() {
  group('simulatePayoff', () {
    test('a zero-interest debt clears in balance / payment months', () {
      final p = simulatePayoff(
          balanceCents: 100000, apr: 0, monthlyPaymentCents: 10000)!;
      expect(p.months, 10);
      expect(p.totalInterestCents, 0);
    });

    test('interest accrues before the payment is applied', () {
      // $1,000 at 12% APR = 1% a month = $10 interest in month one.
      final p = simulatePayoff(
          balanceCents: 100000, apr: 12, monthlyPaymentCents: 50000)!;
      expect(p.months, 3);
      expect(p.totalInterestCents, greaterThan(0));
      expect(p.balanceByMonth.first, 100000);
      expect(p.balanceByMonth.last, 0);
    });

    test('extra payments shorten the term and cut interest', () {
      const balance = 800000;
      const apr = 18.0;
      final base =
          simulatePayoff(balanceCents: balance, apr: apr, monthlyPaymentCents: 20000)!;
      final withExtra = simulatePayoff(
          balanceCents: balance,
          apr: apr,
          monthlyPaymentCents: 20000,
          extraCents: 10000)!;

      expect(withExtra.months, lessThan(base.months));
      expect(withExtra.totalInterestCents,
          lessThan(base.totalInterestCents));
    });

    test('a payment that cannot cover the interest never pays off', () {
      // $10,000 at 24% APR accrues $200/month; paying $150 goes backwards.
      expect(
          simulatePayoff(
              balanceCents: 1000000, apr: 24, monthlyPaymentCents: 15000),
          isNull);
    });

    test('a payment exactly equal to the interest never pays off', () {
      // $10,000 at 24% APR = exactly $200 interest in month one.
      expect(
          simulatePayoff(
              balanceCents: 1000000, apr: 24, monthlyPaymentCents: 20000),
          isNull);
    });

    test('a zero balance is already paid off', () {
      final p = simulatePayoff(
          balanceCents: 0, apr: 20, monthlyPaymentCents: 10000)!;
      expect(p.months, 0);
    });

    test('a zero payment has no projection', () {
      expect(
          simulatePayoff(
              balanceCents: 100000, apr: 10, monthlyPaymentCents: 0),
          isNull);
    });

    test('the balance series ends at zero and never rises', () {
      final p = simulatePayoff(
          balanceCents: 500000, apr: 15, monthlyPaymentCents: 50000)!;
      expect(p.balanceByMonth.last, 0);
      for (var i = 1; i < p.balanceByMonth.length; i++) {
        expect(p.balanceByMonth[i], lessThanOrEqualTo(p.balanceByMonth[i - 1]));
      }
    });

    test('payoff date is months out from today', () {
      final p = simulatePayoff(
          balanceCents: 100000, apr: 0, monthlyPaymentCents: 10000)!;
      final date = p.payoffDate(DateTime(2026, 8, 15));
      expect(date.year, 2027);
      expect(date.month, 6);
    });
  });

  group('estimateCardMinimumPayment', () {
    test('is 1% of balance plus interest', () {
      // $5,000 at 24% APR: 1% = $50, interest = $100 -> $150.
      expect(
          estimateCardMinimumPayment(balanceCents: 500000, apr: 24), 15000);
    });

    test('never goes below the 25 dollar floor', () {
      expect(estimateCardMinimumPayment(balanceCents: 10000, apr: 0), 2500);
    });

    test('never exceeds the balance itself', () {
      expect(estimateCardMinimumPayment(balanceCents: 1000, apr: 0), 1000);
    });

    test('a cleared card needs no payment', () {
      expect(estimateCardMinimumPayment(balanceCents: 0, apr: 24), 0);
    });

    test('the estimate always outruns the interest, so it can pay off', () {
      final minimum =
          estimateCardMinimumPayment(balanceCents: 1000000, apr: 29.99);
      expect(
          simulatePayoff(
              balanceCents: 1000000,
              apr: 29.99,
              monthlyPaymentCents: minimum),
          isNotNull);
    });
  });
}
