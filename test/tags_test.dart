import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/data/database.dart';
import 'package:granary/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
  });

  tearDown(() => db.close());

  Future<int> addEntry() => repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 15),
        amountCents: 5000,
        type: EntryType.expense,
      ));

  test('tagging an entry creates tags and links them', () async {
    final entryId = await addEntry();

    await repo.setEntryTags(
        profileId: profileId,
        entryId: entryId,
        tagNames: ['vacation2026', 'tax-deductible']);

    final tags = await repo.watchTags(profileId: profileId).first;
    expect(tags.map((t) => t.name), containsAll(['vacation2026', 'tax-deductible']));
    final byEntry = await repo.watchEntryTagNames(profileId: profileId).first;
    expect(byEntry[entryId], containsAll(['vacation2026', 'tax-deductible']));
  });

  test('re-tagging replaces the previous tags rather than adding to them',
      () async {
    final entryId = await addEntry();
    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['old']);

    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['new']);

    final byEntry = await repo.watchEntryTagNames(profileId: profileId).first;
    expect(byEntry[entryId], ['new']);
  });

  test('the same tag name is reused across entries, not duplicated',
      () async {
    final a = await addEntry();
    final b = await addEntry();

    await repo.setEntryTags(
        profileId: profileId, entryId: a, tagNames: ['shared']);
    await repo.setEntryTags(
        profileId: profileId, entryId: b, tagNames: ['shared']);

    final tags = await repo.watchTags(profileId: profileId).first;
    expect(tags.where((t) => t.name == 'shared'), hasLength(1));
  });

  test('blank tag names are dropped', () async {
    final entryId = await addEntry();
    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['  ', '', 'real']);

    final byEntry = await repo.watchEntryTagNames(profileId: profileId).first;
    expect(byEntry[entryId], ['real']);
  });

  test('deleting a tag removes it from every entry it was on', () async {
    final entryId = await addEntry();
    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['temp']);
    final tagId =
        (await repo.watchTags(profileId: profileId).first).single.id;

    await repo.deleteTag(profileId: profileId, id: tagId);

    final byEntry = await repo.watchEntryTagNames(profileId: profileId).first;
    expect(byEntry[entryId] ?? [], isEmpty);
  });

  test('deleting the entry removes its tag links', () async {
    final entryId = await addEntry();
    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['temp']);

    await repo.deleteBudgetEntry(profileId: profileId, id: entryId);

    // The tag itself survives — only the link to the deleted entry is gone.
    final tags = await repo.watchTags(profileId: profileId).first;
    expect(tags.map((t) => t.name), contains('temp'));
  });

  test('tags are per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    final entryId = await addEntry();
    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['mine']);

    expect(await repo.watchTags(profileId: other).first, isEmpty);
  });
}
