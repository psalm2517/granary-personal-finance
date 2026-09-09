<div align="center">

# Granary

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Android-lightgrey.svg)](#building)
[![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Version](https://img.shields.io/badge/version-0.3.0-informational.svg)](https://github.com/psalm2517/homebase-money/releases)

A personal finance tracker for a household, built for the desktop. Everything
stays on your own machine: there is no account to make, no server, and
nothing is uploaded anywhere.

Built with Flutter and Drift (SQLite). Linux is the primary target;
Android is planned as a secondary one.

![Granary dashboard](docs/screenshots/dashboard1.png)

</div>

*All screenshots use generated demo data, not real finances.*

## What it does

**Accounts.** Checking, savings, cash, investment and retirement balances,
cards and loans, all in one place with a running total for each. These are
the asset side of net worth.

![Accounts](docs/screenshots/accounts.png)

**Cards.** Balances, limits, utilization and statement cycles.

**Loans.** Payoff progress, a snowball vs. avalanche comparison, and a
"what if" simulator with a slider for extra monthly payments that shows the
interest and time you would save.

![Loans](docs/screenshots/loans.png)

**Bills.** Monthly, quarterly, annual or one-time, with autopay support. A
bill can be assigned to the account or card it's paid from, so marking it
paid moves real money instead of just tracking that it happened. Paid
status is recorded against the month it covers, so it resets itself on the
1st and past months keep their real history.

![Bills](docs/screenshots/bills.png)

**Budget.** What came in, what went out and what is left for the month, plus
a Sankey-style chart of where it actually flowed. Paychecks and paid bills
post themselves automatically, so most months need no manual entry beyond
cash spending.

![Budget](docs/screenshots/budget.png)

**Transactions.** A full, searchable register across every month, not just
the current one — filter by account, card or income/expense. A transaction
can be split across multiple categories, and editing one after the fact
corrects any balance it already moved.

![Transactions](docs/screenshots/transactions.png)

**Transfers.** Move money between your own accounts, either on a recurring
schedule or as a one-off "transfer now."

**Paychecks.** Set a schedule once (weekly, bi-weekly, semi-monthly,
monthly) and paychecks generate 90 days ahead, mark themselves received on
payday, and can be split across allocations like rent or savings.

**Goals.** Savings or payoff targets with progress tracking, optionally
tied to a real account's live balance, and a monthly figure to hit a target
date.

![Goals](docs/screenshots/goals.png)

**Dashboard.** Net worth trend and breakdown, a 60-day cash balance
projection, credit utilization, cashflow, upcoming bills and a credit score
history you log yourself.

## Privacy between profiles

A household has multiple profiles. One is an admin, who can view and switch
into any profile. Everyone else sees only their own data and gets no
indication that other profiles exist.

This is enforced structurally, not by hiding UI: every query in the data
layer takes a required `profileId`, and there is no method that returns rows
across profiles. Backups follow the same rule: an admin's backup covers the
household, anyone else's covers only themselves, and restoring a household
backup as a non-admin touches only their own rows.

Profiles can have a PIN of any length using any characters. A PIN is a gate
for convenience, not encryption: the database itself is not encrypted, so
anyone with access to the file can read it.

## Your data

The database lives at:

    ~/.local/share/dev.granary.granary/granary.sqlite

Settings has a backup action that writes a JSON file wherever you choose, and
a restore that replaces the current data. Restore inspects the file and
shows what it contains before doing anything, refuses files from a newer
version before deleting a single row, and copies the live database next to
itself first so a mistaken restore can still be undone by hand.

Backups are plain JSON and are **not encrypted**, which is fine on a local
drive but worth thinking about before putting one in a synced cloud folder.

## Theme

All four [Catppuccin](https://catppuccin.com) flavors (Latte, Frappé,
Macchiato and Mocha) are selectable in Settings, with Mocha as the default.
Colours come from the official `catppuccin_flutter` package rather than
being copied into this repository.

![Settings and theme picker](docs/screenshots/settings.png)

## Building

See [BUILD.md](BUILD.md).

## Architecture

    lib/
      data/         Drift schema, repository, backup, notifications
      screens/      One file per screen
      widgets/      Shared UI pieces
      theme/        Catppuccin flavors and ThemeData
      util/         Money formatting, payoff maths, PIN hashing

All database access goes through `HomebaseRepository`; widgets never touch
Drift directly. That keeps the per-profile rule in one place and leaves room
for a sync layer later without rewriting the screens.

Schema changes are versioned migrations (currently v17) with tests that
upgrade a real database of each older shape, so existing data survives an
update.

Money is stored as integer cents throughout, never floating point.

## Planned

Android build

Flatpak packaging

SimpleFin Bridge integration

Ollama integration

## AI disclosure

This project was built with AI assistance, directed by me.

## License

MIT. See [LICENSE](./LICENSE).
