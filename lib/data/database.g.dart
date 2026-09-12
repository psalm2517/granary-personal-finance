// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAdminMeta = const VerificationMeta(
    'isAdmin',
  );
  @override
  late final GeneratedColumn<bool> isAdmin = GeneratedColumn<bool>(
    'is_admin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_admin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, pinHash, isAdmin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    }
    if (data.containsKey('is_admin')) {
      context.handle(
        _isAdminMeta,
        isAdmin.isAcceptableOrUnknown(data['is_admin']!, _isAdminMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
      isAdmin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_admin'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String name;
  final String? pinHash;
  final bool isAdmin;
  const Profile({
    required this.id,
    required this.name,
    this.pinHash,
    required this.isAdmin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['is_admin'] = Variable<bool>(isAdmin);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      isAdmin: Value(isAdmin),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      isAdmin: serializer.fromJson<bool>(json['isAdmin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'pinHash': serializer.toJson<String?>(pinHash),
      'isAdmin': serializer.toJson<bool>(isAdmin),
    };
  }

  Profile copyWith({
    int? id,
    String? name,
    Value<String?> pinHash = const Value.absent(),
    bool? isAdmin,
  }) => Profile(
    id: id ?? this.id,
    name: name ?? this.name,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
    isAdmin: isAdmin ?? this.isAdmin,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      isAdmin: data.isAdmin.present ? data.isAdmin.value : this.isAdmin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pinHash: $pinHash, ')
          ..write('isAdmin: $isAdmin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pinHash, isAdmin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.pinHash == this.pinHash &&
          other.isAdmin == this.isAdmin);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> pinHash;
  final Value<bool> isAdmin;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.isAdmin = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.pinHash = const Value.absent(),
    this.isAdmin = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? pinHash,
    Expression<bool>? isAdmin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pinHash != null) 'pin_hash': pinHash,
      if (isAdmin != null) 'is_admin': isAdmin,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? pinHash,
    Value<bool>? isAdmin,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pinHash: pinHash ?? this.pinHash,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (isAdmin.present) {
      map['is_admin'] = Variable<bool>(isAdmin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pinHash: $pinHash, ')
          ..write('isAdmin: $isAdmin')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reconciledBalanceCentsMeta =
      const VerificationMeta('reconciledBalanceCents');
  @override
  late final GeneratedColumn<int> reconciledBalanceCents = GeneratedColumn<int>(
    'reconciled_balance_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reconciledAtMeta = const VerificationMeta(
    'reconciledAt',
  );
  @override
  late final GeneratedColumn<DateTime> reconciledAt = GeneratedColumn<DateTime>(
    'reconciled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    institution,
    type,
    balanceCents,
    reconciledBalanceCents,
    reconciledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('reconciled_balance_cents')) {
      context.handle(
        _reconciledBalanceCentsMeta,
        reconciledBalanceCents.isAcceptableOrUnknown(
          data['reconciled_balance_cents']!,
          _reconciledBalanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('reconciled_at')) {
      context.handle(
        _reconciledAtMeta,
        reconciledAt.isAcceptableOrUnknown(
          data['reconciled_at']!,
          _reconciledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      reconciledBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reconciled_balance_cents'],
      ),
      reconciledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reconciled_at'],
      ),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter<AccountType>(AccountType.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final int profileId;
  final String name;
  final String? institution;
  final AccountType type;
  final int balanceCents;

  /// The statement balance this account was last reconciled to, and when —
  /// null until the first reconciliation. Not touched by day-to-day
  /// balance edits; only [HomebaseRepository.reconcileAccount] sets it.
  final int? reconciledBalanceCents;
  final DateTime? reconciledAt;
  const Account({
    required this.id,
    required this.profileId,
    required this.name,
    this.institution,
    required this.type,
    required this.balanceCents,
    this.reconciledBalanceCents,
    this.reconciledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['balance_cents'] = Variable<int>(balanceCents);
    if (!nullToAbsent || reconciledBalanceCents != null) {
      map['reconciled_balance_cents'] = Variable<int>(reconciledBalanceCents);
    }
    if (!nullToAbsent || reconciledAt != null) {
      map['reconciled_at'] = Variable<DateTime>(reconciledAt);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      type: Value(type),
      balanceCents: Value(balanceCents),
      reconciledBalanceCents: reconciledBalanceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(reconciledBalanceCents),
      reconciledAt: reconciledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reconciledAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      institution: serializer.fromJson<String?>(json['institution']),
      type: $AccountsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      reconciledBalanceCents: serializer.fromJson<int?>(
        json['reconciledBalanceCents'],
      ),
      reconciledAt: serializer.fromJson<DateTime?>(json['reconciledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'institution': serializer.toJson<String?>(institution),
      'type': serializer.toJson<String>(
        $AccountsTable.$convertertype.toJson(type),
      ),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'reconciledBalanceCents': serializer.toJson<int?>(reconciledBalanceCents),
      'reconciledAt': serializer.toJson<DateTime?>(reconciledAt),
    };
  }

  Account copyWith({
    int? id,
    int? profileId,
    String? name,
    Value<String?> institution = const Value.absent(),
    AccountType? type,
    int? balanceCents,
    Value<int?> reconciledBalanceCents = const Value.absent(),
    Value<DateTime?> reconciledAt = const Value.absent(),
  }) => Account(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    institution: institution.present ? institution.value : this.institution,
    type: type ?? this.type,
    balanceCents: balanceCents ?? this.balanceCents,
    reconciledBalanceCents: reconciledBalanceCents.present
        ? reconciledBalanceCents.value
        : this.reconciledBalanceCents,
    reconciledAt: reconciledAt.present ? reconciledAt.value : this.reconciledAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      type: data.type.present ? data.type.value : this.type,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      reconciledBalanceCents: data.reconciledBalanceCents.present
          ? data.reconciledBalanceCents.value
          : this.reconciledBalanceCents,
      reconciledAt: data.reconciledAt.present
          ? data.reconciledAt.value
          : this.reconciledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('institution: $institution, ')
          ..write('type: $type, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('reconciledBalanceCents: $reconciledBalanceCents, ')
          ..write('reconciledAt: $reconciledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    institution,
    type,
    balanceCents,
    reconciledBalanceCents,
    reconciledAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.institution == this.institution &&
          other.type == this.type &&
          other.balanceCents == this.balanceCents &&
          other.reconciledBalanceCents == this.reconciledBalanceCents &&
          other.reconciledAt == this.reconciledAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<String?> institution;
  final Value<AccountType> type;
  final Value<int> balanceCents;
  final Value<int?> reconciledBalanceCents;
  final Value<DateTime?> reconciledAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.institution = const Value.absent(),
    this.type = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.reconciledBalanceCents = const Value.absent(),
    this.reconciledAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    this.institution = const Value.absent(),
    required AccountType type,
    this.balanceCents = const Value.absent(),
    this.reconciledBalanceCents = const Value.absent(),
    this.reconciledAt = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       type = Value(type);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<String>? institution,
    Expression<String>? type,
    Expression<int>? balanceCents,
    Expression<int>? reconciledBalanceCents,
    Expression<DateTime>? reconciledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (institution != null) 'institution': institution,
      if (type != null) 'type': type,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (reconciledBalanceCents != null)
        'reconciled_balance_cents': reconciledBalanceCents,
      if (reconciledAt != null) 'reconciled_at': reconciledAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<String?>? institution,
    Value<AccountType>? type,
    Value<int>? balanceCents,
    Value<int?>? reconciledBalanceCents,
    Value<DateTime?>? reconciledAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      institution: institution ?? this.institution,
      type: type ?? this.type,
      balanceCents: balanceCents ?? this.balanceCents,
      reconciledBalanceCents:
          reconciledBalanceCents ?? this.reconciledBalanceCents,
      reconciledAt: reconciledAt ?? this.reconciledAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AccountsTable.$convertertype.toSql(type.value),
      );
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (reconciledBalanceCents.present) {
      map['reconciled_balance_cents'] = Variable<int>(
        reconciledBalanceCents.value,
      );
    }
    if (reconciledAt.present) {
      map['reconciled_at'] = Variable<DateTime>(reconciledAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('institution: $institution, ')
          ..write('type: $type, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('reconciledBalanceCents: $reconciledBalanceCents, ')
          ..write('reconciledAt: $reconciledAt')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creditLimitCentsMeta = const VerificationMeta(
    'creditLimitCents',
  );
  @override
  late final GeneratedColumn<int> creditLimitCents = GeneratedColumn<int>(
    'credit_limit_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aprMeta = const VerificationMeta('apr');
  @override
  late final GeneratedColumn<double> apr = GeneratedColumn<double>(
    'apr',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _annualFeeCentsMeta = const VerificationMeta(
    'annualFeeCents',
  );
  @override
  late final GeneratedColumn<int> annualFeeCents = GeneratedColumn<int>(
    'annual_fee_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _monthlyFeeCentsMeta = const VerificationMeta(
    'monthlyFeeCents',
  );
  @override
  late final GeneratedColumn<int> monthlyFeeCents = GeneratedColumn<int>(
    'monthly_fee_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statementCloseDayMeta = const VerificationMeta(
    'statementCloseDay',
  );
  @override
  late final GeneratedColumn<int> statementCloseDay = GeneratedColumn<int>(
    'statement_close_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentDueDayMeta = const VerificationMeta(
    'paymentDueDay',
  );
  @override
  late final GeneratedColumn<int> paymentDueDay = GeneratedColumn<int>(
    'payment_due_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minimumPaymentDueCentsMeta =
      const VerificationMeta('minimumPaymentDueCents');
  @override
  late final GeneratedColumn<int> minimumPaymentDueCents = GeneratedColumn<int>(
    'minimum_payment_due_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _annualFeeDateMeta = const VerificationMeta(
    'annualFeeDate',
  );
  @override
  late final GeneratedColumn<DateTime> annualFeeDate =
      GeneratedColumn<DateTime>(
        'annual_fee_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    balanceCents,
    creditLimitCents,
    apr,
    annualFeeCents,
    monthlyFeeCents,
    statementCloseDay,
    paymentDueDay,
    minimumPaymentDueCents,
    annualFeeDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit_cents')) {
      context.handle(
        _creditLimitCentsMeta,
        creditLimitCents.isAcceptableOrUnknown(
          data['credit_limit_cents']!,
          _creditLimitCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditLimitCentsMeta);
    }
    if (data.containsKey('apr')) {
      context.handle(
        _aprMeta,
        apr.isAcceptableOrUnknown(data['apr']!, _aprMeta),
      );
    }
    if (data.containsKey('annual_fee_cents')) {
      context.handle(
        _annualFeeCentsMeta,
        annualFeeCents.isAcceptableOrUnknown(
          data['annual_fee_cents']!,
          _annualFeeCentsMeta,
        ),
      );
    }
    if (data.containsKey('monthly_fee_cents')) {
      context.handle(
        _monthlyFeeCentsMeta,
        monthlyFeeCents.isAcceptableOrUnknown(
          data['monthly_fee_cents']!,
          _monthlyFeeCentsMeta,
        ),
      );
    }
    if (data.containsKey('statement_close_day')) {
      context.handle(
        _statementCloseDayMeta,
        statementCloseDay.isAcceptableOrUnknown(
          data['statement_close_day']!,
          _statementCloseDayMeta,
        ),
      );
    }
    if (data.containsKey('payment_due_day')) {
      context.handle(
        _paymentDueDayMeta,
        paymentDueDay.isAcceptableOrUnknown(
          data['payment_due_day']!,
          _paymentDueDayMeta,
        ),
      );
    }
    if (data.containsKey('minimum_payment_due_cents')) {
      context.handle(
        _minimumPaymentDueCentsMeta,
        minimumPaymentDueCents.isAcceptableOrUnknown(
          data['minimum_payment_due_cents']!,
          _minimumPaymentDueCentsMeta,
        ),
      );
    }
    if (data.containsKey('annual_fee_date')) {
      context.handle(
        _annualFeeDateMeta,
        annualFeeDate.isAcceptableOrUnknown(
          data['annual_fee_date']!,
          _annualFeeDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      creditLimitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit_cents'],
      )!,
      apr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}apr'],
      )!,
      annualFeeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annual_fee_cents'],
      )!,
      monthlyFeeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_fee_cents'],
      )!,
      statementCloseDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}statement_close_day'],
      ),
      paymentDueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_due_day'],
      ),
      minimumPaymentDueCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_payment_due_cents'],
      ),
      annualFeeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}annual_fee_date'],
      ),
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }
}

class CreditCard extends DataClass implements Insertable<CreditCard> {
  final int id;
  final int profileId;
  final String name;
  final int balanceCents;
  final int creditLimitCents;
  final double apr;
  final int annualFeeCents;
  final int monthlyFeeCents;

  /// Day of month the statement closes.
  final int? statementCloseDay;

  /// Day of month the payment is due, typically ~21-25 days after closing.
  final int? paymentDueDay;

  /// Minimum payment shown on the current statement, when known. The payoff
  /// simulator prefers this over its own estimate.
  final int? minimumPaymentDueCents;

  /// When the annual fee next hits. The amount is [annualFeeCents], which
  /// already feeds the budget set-aside — a second amount field here could
  /// disagree with it.
  final DateTime? annualFeeDate;
  const CreditCard({
    required this.id,
    required this.profileId,
    required this.name,
    required this.balanceCents,
    required this.creditLimitCents,
    required this.apr,
    required this.annualFeeCents,
    required this.monthlyFeeCents,
    this.statementCloseDay,
    this.paymentDueDay,
    this.minimumPaymentDueCents,
    this.annualFeeDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['credit_limit_cents'] = Variable<int>(creditLimitCents);
    map['apr'] = Variable<double>(apr);
    map['annual_fee_cents'] = Variable<int>(annualFeeCents);
    map['monthly_fee_cents'] = Variable<int>(monthlyFeeCents);
    if (!nullToAbsent || statementCloseDay != null) {
      map['statement_close_day'] = Variable<int>(statementCloseDay);
    }
    if (!nullToAbsent || paymentDueDay != null) {
      map['payment_due_day'] = Variable<int>(paymentDueDay);
    }
    if (!nullToAbsent || minimumPaymentDueCents != null) {
      map['minimum_payment_due_cents'] = Variable<int>(minimumPaymentDueCents);
    }
    if (!nullToAbsent || annualFeeDate != null) {
      map['annual_fee_date'] = Variable<DateTime>(annualFeeDate);
    }
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      balanceCents: Value(balanceCents),
      creditLimitCents: Value(creditLimitCents),
      apr: Value(apr),
      annualFeeCents: Value(annualFeeCents),
      monthlyFeeCents: Value(monthlyFeeCents),
      statementCloseDay: statementCloseDay == null && nullToAbsent
          ? const Value.absent()
          : Value(statementCloseDay),
      paymentDueDay: paymentDueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDueDay),
      minimumPaymentDueCents: minimumPaymentDueCents == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumPaymentDueCents),
      annualFeeDate: annualFeeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(annualFeeDate),
    );
  }

  factory CreditCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCard(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      creditLimitCents: serializer.fromJson<int>(json['creditLimitCents']),
      apr: serializer.fromJson<double>(json['apr']),
      annualFeeCents: serializer.fromJson<int>(json['annualFeeCents']),
      monthlyFeeCents: serializer.fromJson<int>(json['monthlyFeeCents']),
      statementCloseDay: serializer.fromJson<int?>(json['statementCloseDay']),
      paymentDueDay: serializer.fromJson<int?>(json['paymentDueDay']),
      minimumPaymentDueCents: serializer.fromJson<int?>(
        json['minimumPaymentDueCents'],
      ),
      annualFeeDate: serializer.fromJson<DateTime?>(json['annualFeeDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'creditLimitCents': serializer.toJson<int>(creditLimitCents),
      'apr': serializer.toJson<double>(apr),
      'annualFeeCents': serializer.toJson<int>(annualFeeCents),
      'monthlyFeeCents': serializer.toJson<int>(monthlyFeeCents),
      'statementCloseDay': serializer.toJson<int?>(statementCloseDay),
      'paymentDueDay': serializer.toJson<int?>(paymentDueDay),
      'minimumPaymentDueCents': serializer.toJson<int?>(minimumPaymentDueCents),
      'annualFeeDate': serializer.toJson<DateTime?>(annualFeeDate),
    };
  }

  CreditCard copyWith({
    int? id,
    int? profileId,
    String? name,
    int? balanceCents,
    int? creditLimitCents,
    double? apr,
    int? annualFeeCents,
    int? monthlyFeeCents,
    Value<int?> statementCloseDay = const Value.absent(),
    Value<int?> paymentDueDay = const Value.absent(),
    Value<int?> minimumPaymentDueCents = const Value.absent(),
    Value<DateTime?> annualFeeDate = const Value.absent(),
  }) => CreditCard(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    balanceCents: balanceCents ?? this.balanceCents,
    creditLimitCents: creditLimitCents ?? this.creditLimitCents,
    apr: apr ?? this.apr,
    annualFeeCents: annualFeeCents ?? this.annualFeeCents,
    monthlyFeeCents: monthlyFeeCents ?? this.monthlyFeeCents,
    statementCloseDay: statementCloseDay.present
        ? statementCloseDay.value
        : this.statementCloseDay,
    paymentDueDay: paymentDueDay.present
        ? paymentDueDay.value
        : this.paymentDueDay,
    minimumPaymentDueCents: minimumPaymentDueCents.present
        ? minimumPaymentDueCents.value
        : this.minimumPaymentDueCents,
    annualFeeDate: annualFeeDate.present
        ? annualFeeDate.value
        : this.annualFeeDate,
  );
  CreditCard copyWithCompanion(CreditCardsCompanion data) {
    return CreditCard(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      creditLimitCents: data.creditLimitCents.present
          ? data.creditLimitCents.value
          : this.creditLimitCents,
      apr: data.apr.present ? data.apr.value : this.apr,
      annualFeeCents: data.annualFeeCents.present
          ? data.annualFeeCents.value
          : this.annualFeeCents,
      monthlyFeeCents: data.monthlyFeeCents.present
          ? data.monthlyFeeCents.value
          : this.monthlyFeeCents,
      statementCloseDay: data.statementCloseDay.present
          ? data.statementCloseDay.value
          : this.statementCloseDay,
      paymentDueDay: data.paymentDueDay.present
          ? data.paymentDueDay.value
          : this.paymentDueDay,
      minimumPaymentDueCents: data.minimumPaymentDueCents.present
          ? data.minimumPaymentDueCents.value
          : this.minimumPaymentDueCents,
      annualFeeDate: data.annualFeeDate.present
          ? data.annualFeeDate.value
          : this.annualFeeDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCard(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('creditLimitCents: $creditLimitCents, ')
          ..write('apr: $apr, ')
          ..write('annualFeeCents: $annualFeeCents, ')
          ..write('monthlyFeeCents: $monthlyFeeCents, ')
          ..write('statementCloseDay: $statementCloseDay, ')
          ..write('paymentDueDay: $paymentDueDay, ')
          ..write('minimumPaymentDueCents: $minimumPaymentDueCents, ')
          ..write('annualFeeDate: $annualFeeDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    balanceCents,
    creditLimitCents,
    apr,
    annualFeeCents,
    monthlyFeeCents,
    statementCloseDay,
    paymentDueDay,
    minimumPaymentDueCents,
    annualFeeDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCard &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.balanceCents == this.balanceCents &&
          other.creditLimitCents == this.creditLimitCents &&
          other.apr == this.apr &&
          other.annualFeeCents == this.annualFeeCents &&
          other.monthlyFeeCents == this.monthlyFeeCents &&
          other.statementCloseDay == this.statementCloseDay &&
          other.paymentDueDay == this.paymentDueDay &&
          other.minimumPaymentDueCents == this.minimumPaymentDueCents &&
          other.annualFeeDate == this.annualFeeDate);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCard> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<int> balanceCents;
  final Value<int> creditLimitCents;
  final Value<double> apr;
  final Value<int> annualFeeCents;
  final Value<int> monthlyFeeCents;
  final Value<int?> statementCloseDay;
  final Value<int?> paymentDueDay;
  final Value<int?> minimumPaymentDueCents;
  final Value<DateTime?> annualFeeDate;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.creditLimitCents = const Value.absent(),
    this.apr = const Value.absent(),
    this.annualFeeCents = const Value.absent(),
    this.monthlyFeeCents = const Value.absent(),
    this.statementCloseDay = const Value.absent(),
    this.paymentDueDay = const Value.absent(),
    this.minimumPaymentDueCents = const Value.absent(),
    this.annualFeeDate = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    this.balanceCents = const Value.absent(),
    required int creditLimitCents,
    this.apr = const Value.absent(),
    this.annualFeeCents = const Value.absent(),
    this.monthlyFeeCents = const Value.absent(),
    this.statementCloseDay = const Value.absent(),
    this.paymentDueDay = const Value.absent(),
    this.minimumPaymentDueCents = const Value.absent(),
    this.annualFeeDate = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       creditLimitCents = Value(creditLimitCents);
  static Insertable<CreditCard> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<int>? balanceCents,
    Expression<int>? creditLimitCents,
    Expression<double>? apr,
    Expression<int>? annualFeeCents,
    Expression<int>? monthlyFeeCents,
    Expression<int>? statementCloseDay,
    Expression<int>? paymentDueDay,
    Expression<int>? minimumPaymentDueCents,
    Expression<DateTime>? annualFeeDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (creditLimitCents != null) 'credit_limit_cents': creditLimitCents,
      if (apr != null) 'apr': apr,
      if (annualFeeCents != null) 'annual_fee_cents': annualFeeCents,
      if (monthlyFeeCents != null) 'monthly_fee_cents': monthlyFeeCents,
      if (statementCloseDay != null) 'statement_close_day': statementCloseDay,
      if (paymentDueDay != null) 'payment_due_day': paymentDueDay,
      if (minimumPaymentDueCents != null)
        'minimum_payment_due_cents': minimumPaymentDueCents,
      if (annualFeeDate != null) 'annual_fee_date': annualFeeDate,
    });
  }

  CreditCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<int>? balanceCents,
    Value<int>? creditLimitCents,
    Value<double>? apr,
    Value<int>? annualFeeCents,
    Value<int>? monthlyFeeCents,
    Value<int?>? statementCloseDay,
    Value<int?>? paymentDueDay,
    Value<int?>? minimumPaymentDueCents,
    Value<DateTime?>? annualFeeDate,
  }) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      balanceCents: balanceCents ?? this.balanceCents,
      creditLimitCents: creditLimitCents ?? this.creditLimitCents,
      apr: apr ?? this.apr,
      annualFeeCents: annualFeeCents ?? this.annualFeeCents,
      monthlyFeeCents: monthlyFeeCents ?? this.monthlyFeeCents,
      statementCloseDay: statementCloseDay ?? this.statementCloseDay,
      paymentDueDay: paymentDueDay ?? this.paymentDueDay,
      minimumPaymentDueCents:
          minimumPaymentDueCents ?? this.minimumPaymentDueCents,
      annualFeeDate: annualFeeDate ?? this.annualFeeDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (creditLimitCents.present) {
      map['credit_limit_cents'] = Variable<int>(creditLimitCents.value);
    }
    if (apr.present) {
      map['apr'] = Variable<double>(apr.value);
    }
    if (annualFeeCents.present) {
      map['annual_fee_cents'] = Variable<int>(annualFeeCents.value);
    }
    if (monthlyFeeCents.present) {
      map['monthly_fee_cents'] = Variable<int>(monthlyFeeCents.value);
    }
    if (statementCloseDay.present) {
      map['statement_close_day'] = Variable<int>(statementCloseDay.value);
    }
    if (paymentDueDay.present) {
      map['payment_due_day'] = Variable<int>(paymentDueDay.value);
    }
    if (minimumPaymentDueCents.present) {
      map['minimum_payment_due_cents'] = Variable<int>(
        minimumPaymentDueCents.value,
      );
    }
    if (annualFeeDate.present) {
      map['annual_fee_date'] = Variable<DateTime>(annualFeeDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('creditLimitCents: $creditLimitCents, ')
          ..write('apr: $apr, ')
          ..write('annualFeeCents: $annualFeeCents, ')
          ..write('monthlyFeeCents: $monthlyFeeCents, ')
          ..write('statementCloseDay: $statementCloseDay, ')
          ..write('paymentDueDay: $paymentDueDay, ')
          ..write('minimumPaymentDueCents: $minimumPaymentDueCents, ')
          ..write('annualFeeDate: $annualFeeDate')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalAmountCentsMeta =
      const VerificationMeta('originalAmountCents');
  @override
  late final GeneratedColumn<int> originalAmountCents = GeneratedColumn<int>(
    'original_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aprMeta = const VerificationMeta('apr');
  @override
  late final GeneratedColumn<double> apr = GeneratedColumn<double>(
    'apr',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _monthlyPaymentCentsMeta =
      const VerificationMeta('monthlyPaymentCents');
  @override
  late final GeneratedColumn<int> monthlyPaymentCents = GeneratedColumn<int>(
    'monthly_payment_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    balanceCents,
    originalAmountCents,
    apr,
    monthlyPaymentCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Loan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceCentsMeta);
    }
    if (data.containsKey('original_amount_cents')) {
      context.handle(
        _originalAmountCentsMeta,
        originalAmountCents.isAcceptableOrUnknown(
          data['original_amount_cents']!,
          _originalAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalAmountCentsMeta);
    }
    if (data.containsKey('apr')) {
      context.handle(
        _aprMeta,
        apr.isAcceptableOrUnknown(data['apr']!, _aprMeta),
      );
    }
    if (data.containsKey('monthly_payment_cents')) {
      context.handle(
        _monthlyPaymentCentsMeta,
        monthlyPaymentCents.isAcceptableOrUnknown(
          data['monthly_payment_cents']!,
          _monthlyPaymentCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      originalAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_amount_cents'],
      )!,
      apr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}apr'],
      )!,
      monthlyPaymentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_payment_cents'],
      )!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }
}

class Loan extends DataClass implements Insertable<Loan> {
  final int id;
  final int profileId;
  final String name;
  final int balanceCents;
  final int originalAmountCents;
  final double apr;
  final int monthlyPaymentCents;
  const Loan({
    required this.id,
    required this.profileId,
    required this.name,
    required this.balanceCents,
    required this.originalAmountCents,
    required this.apr,
    required this.monthlyPaymentCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['original_amount_cents'] = Variable<int>(originalAmountCents);
    map['apr'] = Variable<double>(apr);
    map['monthly_payment_cents'] = Variable<int>(monthlyPaymentCents);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      balanceCents: Value(balanceCents),
      originalAmountCents: Value(originalAmountCents),
      apr: Value(apr),
      monthlyPaymentCents: Value(monthlyPaymentCents),
    );
  }

  factory Loan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      originalAmountCents: serializer.fromJson<int>(
        json['originalAmountCents'],
      ),
      apr: serializer.fromJson<double>(json['apr']),
      monthlyPaymentCents: serializer.fromJson<int>(
        json['monthlyPaymentCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'originalAmountCents': serializer.toJson<int>(originalAmountCents),
      'apr': serializer.toJson<double>(apr),
      'monthlyPaymentCents': serializer.toJson<int>(monthlyPaymentCents),
    };
  }

  Loan copyWith({
    int? id,
    int? profileId,
    String? name,
    int? balanceCents,
    int? originalAmountCents,
    double? apr,
    int? monthlyPaymentCents,
  }) => Loan(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    balanceCents: balanceCents ?? this.balanceCents,
    originalAmountCents: originalAmountCents ?? this.originalAmountCents,
    apr: apr ?? this.apr,
    monthlyPaymentCents: monthlyPaymentCents ?? this.monthlyPaymentCents,
  );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      originalAmountCents: data.originalAmountCents.present
          ? data.originalAmountCents.value
          : this.originalAmountCents,
      apr: data.apr.present ? data.apr.value : this.apr,
      monthlyPaymentCents: data.monthlyPaymentCents.present
          ? data.monthlyPaymentCents.value
          : this.monthlyPaymentCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('originalAmountCents: $originalAmountCents, ')
          ..write('apr: $apr, ')
          ..write('monthlyPaymentCents: $monthlyPaymentCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    balanceCents,
    originalAmountCents,
    apr,
    monthlyPaymentCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.balanceCents == this.balanceCents &&
          other.originalAmountCents == this.originalAmountCents &&
          other.apr == this.apr &&
          other.monthlyPaymentCents == this.monthlyPaymentCents);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<int> balanceCents;
  final Value<int> originalAmountCents;
  final Value<double> apr;
  final Value<int> monthlyPaymentCents;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.originalAmountCents = const Value.absent(),
    this.apr = const Value.absent(),
    this.monthlyPaymentCents = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required int balanceCents,
    required int originalAmountCents,
    this.apr = const Value.absent(),
    this.monthlyPaymentCents = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       balanceCents = Value(balanceCents),
       originalAmountCents = Value(originalAmountCents);
  static Insertable<Loan> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<int>? balanceCents,
    Expression<int>? originalAmountCents,
    Expression<double>? apr,
    Expression<int>? monthlyPaymentCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (originalAmountCents != null)
        'original_amount_cents': originalAmountCents,
      if (apr != null) 'apr': apr,
      if (monthlyPaymentCents != null)
        'monthly_payment_cents': monthlyPaymentCents,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<int>? balanceCents,
    Value<int>? originalAmountCents,
    Value<double>? apr,
    Value<int>? monthlyPaymentCents,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      balanceCents: balanceCents ?? this.balanceCents,
      originalAmountCents: originalAmountCents ?? this.originalAmountCents,
      apr: apr ?? this.apr,
      monthlyPaymentCents: monthlyPaymentCents ?? this.monthlyPaymentCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (originalAmountCents.present) {
      map['original_amount_cents'] = Variable<int>(originalAmountCents.value);
    }
    if (apr.present) {
      map['apr'] = Variable<double>(apr.value);
    }
    if (monthlyPaymentCents.present) {
      map['monthly_payment_cents'] = Variable<int>(monthlyPaymentCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('originalAmountCents: $originalAmountCents, ')
          ..write('apr: $apr, ')
          ..write('monthlyPaymentCents: $monthlyPaymentCents')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, Bill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BillFrequency, String> frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('monthly'),
      ).withConverter<BillFrequency>($BillsTable.$converterfrequency);
  @override
  late final GeneratedColumnWithTypeConverter<PaymentSourceType?, String>
  paymentSourceType = GeneratedColumn<String>(
    'payment_source_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<PaymentSourceType?>($BillsTable.$converterpaymentSourceTypen);
  static const VerificationMeta _paymentSourceIdMeta = const VerificationMeta(
    'paymentSourceId',
  );
  @override
  late final GeneratedColumn<int> paymentSourceId = GeneratedColumn<int>(
    'payment_source_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autopayMeta = const VerificationMeta(
    'autopay',
  );
  @override
  late final GeneratedColumn<bool> autopay = GeneratedColumn<bool>(
    'autopay',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("autopay" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dueMonthMeta = const VerificationMeta(
    'dueMonth',
  );
  @override
  late final GeneratedColumn<int> dueMonth = GeneratedColumn<int>(
    'due_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueYearMeta = const VerificationMeta(
    'dueYear',
  );
  @override
  late final GeneratedColumn<int> dueYear = GeneratedColumn<int>(
    'due_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Other'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    amountCents,
    dueDay,
    frequency,
    paymentSourceType,
    paymentSourceId,
    autopay,
    dueMonth,
    dueYear,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('payment_source_id')) {
      context.handle(
        _paymentSourceIdMeta,
        paymentSourceId.isAcceptableOrUnknown(
          data['payment_source_id']!,
          _paymentSourceIdMeta,
        ),
      );
    }
    if (data.containsKey('autopay')) {
      context.handle(
        _autopayMeta,
        autopay.isAcceptableOrUnknown(data['autopay']!, _autopayMeta),
      );
    }
    if (data.containsKey('due_month')) {
      context.handle(
        _dueMonthMeta,
        dueMonth.isAcceptableOrUnknown(data['due_month']!, _dueMonthMeta),
      );
    }
    if (data.containsKey('due_year')) {
      context.handle(
        _dueYearMeta,
        dueYear.isAcceptableOrUnknown(data['due_year']!, _dueYearMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bill(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      frequency: $BillsTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      paymentSourceType: $BillsTable.$converterpaymentSourceTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_source_type'],
        ),
      ),
      paymentSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_source_id'],
      ),
      autopay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}autopay'],
      )!,
      dueMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_month'],
      ),
      dueYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_year'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillFrequency, String, String> $converterfrequency =
      const EnumNameConverter<BillFrequency>(BillFrequency.values);
  static JsonTypeConverter2<PaymentSourceType, String, String>
  $converterpaymentSourceType = const EnumNameConverter<PaymentSourceType>(
    PaymentSourceType.values,
  );
  static JsonTypeConverter2<PaymentSourceType?, String?, String?>
  $converterpaymentSourceTypen = JsonTypeConverter2.asNullable(
    $converterpaymentSourceType,
  );
}

class Bill extends DataClass implements Insertable<Bill> {
  final int id;
  final int profileId;
  final String name;
  final int amountCents;
  final int dueDay;
  final BillFrequency frequency;

  /// What the bill is paid with, e.g. a specific checking account or credit
  /// card. When set, marking the bill paid moves real money: it comes off
  /// an account's balance or onto a card's, the same as materializing it
  /// via autopay does.
  final PaymentSourceType? paymentSourceType;

  /// Row id in Accounts or CreditCards, depending on [paymentSourceType].
  /// Not a foreign key because it points at one of two tables; cleanup is
  /// handled when an account or card is deleted.
  final int? paymentSourceId;

  /// If true, the bill is charged automatically. Once its due day passes it
  /// is treated as paid with no manual check-off, and it never shows the
  /// overdue warning.
  final bool autopay;

  /// Month it falls in. Required for annual and one-time bills; for
  /// quarterly it is the anchor month, repeating every three months.
  /// Unused for monthly bills.
  final int? dueMonth;

  /// One-time bills only.
  final int? dueYear;
  final String category;
  const Bill({
    required this.id,
    required this.profileId,
    required this.name,
    required this.amountCents,
    required this.dueDay,
    required this.frequency,
    this.paymentSourceType,
    this.paymentSourceId,
    required this.autopay,
    this.dueMonth,
    this.dueYear,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    map['amount_cents'] = Variable<int>(amountCents);
    map['due_day'] = Variable<int>(dueDay);
    {
      map['frequency'] = Variable<String>(
        $BillsTable.$converterfrequency.toSql(frequency),
      );
    }
    if (!nullToAbsent || paymentSourceType != null) {
      map['payment_source_type'] = Variable<String>(
        $BillsTable.$converterpaymentSourceTypen.toSql(paymentSourceType),
      );
    }
    if (!nullToAbsent || paymentSourceId != null) {
      map['payment_source_id'] = Variable<int>(paymentSourceId);
    }
    map['autopay'] = Variable<bool>(autopay);
    if (!nullToAbsent || dueMonth != null) {
      map['due_month'] = Variable<int>(dueMonth);
    }
    if (!nullToAbsent || dueYear != null) {
      map['due_year'] = Variable<int>(dueYear);
    }
    map['category'] = Variable<String>(category);
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      amountCents: Value(amountCents),
      dueDay: Value(dueDay),
      frequency: Value(frequency),
      paymentSourceType: paymentSourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentSourceType),
      paymentSourceId: paymentSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentSourceId),
      autopay: Value(autopay),
      dueMonth: dueMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(dueMonth),
      dueYear: dueYear == null && nullToAbsent
          ? const Value.absent()
          : Value(dueYear),
      category: Value(category),
    );
  }

  factory Bill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bill(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      frequency: $BillsTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      paymentSourceType: $BillsTable.$converterpaymentSourceTypen.fromJson(
        serializer.fromJson<String?>(json['paymentSourceType']),
      ),
      paymentSourceId: serializer.fromJson<int?>(json['paymentSourceId']),
      autopay: serializer.fromJson<bool>(json['autopay']),
      dueMonth: serializer.fromJson<int?>(json['dueMonth']),
      dueYear: serializer.fromJson<int?>(json['dueYear']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'amountCents': serializer.toJson<int>(amountCents),
      'dueDay': serializer.toJson<int>(dueDay),
      'frequency': serializer.toJson<String>(
        $BillsTable.$converterfrequency.toJson(frequency),
      ),
      'paymentSourceType': serializer.toJson<String?>(
        $BillsTable.$converterpaymentSourceTypen.toJson(paymentSourceType),
      ),
      'paymentSourceId': serializer.toJson<int?>(paymentSourceId),
      'autopay': serializer.toJson<bool>(autopay),
      'dueMonth': serializer.toJson<int?>(dueMonth),
      'dueYear': serializer.toJson<int?>(dueYear),
      'category': serializer.toJson<String>(category),
    };
  }

  Bill copyWith({
    int? id,
    int? profileId,
    String? name,
    int? amountCents,
    int? dueDay,
    BillFrequency? frequency,
    Value<PaymentSourceType?> paymentSourceType = const Value.absent(),
    Value<int?> paymentSourceId = const Value.absent(),
    bool? autopay,
    Value<int?> dueMonth = const Value.absent(),
    Value<int?> dueYear = const Value.absent(),
    String? category,
  }) => Bill(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    amountCents: amountCents ?? this.amountCents,
    dueDay: dueDay ?? this.dueDay,
    frequency: frequency ?? this.frequency,
    paymentSourceType: paymentSourceType.present
        ? paymentSourceType.value
        : this.paymentSourceType,
    paymentSourceId: paymentSourceId.present
        ? paymentSourceId.value
        : this.paymentSourceId,
    autopay: autopay ?? this.autopay,
    dueMonth: dueMonth.present ? dueMonth.value : this.dueMonth,
    dueYear: dueYear.present ? dueYear.value : this.dueYear,
    category: category ?? this.category,
  );
  Bill copyWithCompanion(BillsCompanion data) {
    return Bill(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      paymentSourceType: data.paymentSourceType.present
          ? data.paymentSourceType.value
          : this.paymentSourceType,
      paymentSourceId: data.paymentSourceId.present
          ? data.paymentSourceId.value
          : this.paymentSourceId,
      autopay: data.autopay.present ? data.autopay.value : this.autopay,
      dueMonth: data.dueMonth.present ? data.dueMonth.value : this.dueMonth,
      dueYear: data.dueYear.present ? data.dueYear.value : this.dueYear,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bill(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('amountCents: $amountCents, ')
          ..write('dueDay: $dueDay, ')
          ..write('frequency: $frequency, ')
          ..write('paymentSourceType: $paymentSourceType, ')
          ..write('paymentSourceId: $paymentSourceId, ')
          ..write('autopay: $autopay, ')
          ..write('dueMonth: $dueMonth, ')
          ..write('dueYear: $dueYear, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    amountCents,
    dueDay,
    frequency,
    paymentSourceType,
    paymentSourceId,
    autopay,
    dueMonth,
    dueYear,
    category,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.amountCents == this.amountCents &&
          other.dueDay == this.dueDay &&
          other.frequency == this.frequency &&
          other.paymentSourceType == this.paymentSourceType &&
          other.paymentSourceId == this.paymentSourceId &&
          other.autopay == this.autopay &&
          other.dueMonth == this.dueMonth &&
          other.dueYear == this.dueYear &&
          other.category == this.category);
}

class BillsCompanion extends UpdateCompanion<Bill> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<int> amountCents;
  final Value<int> dueDay;
  final Value<BillFrequency> frequency;
  final Value<PaymentSourceType?> paymentSourceType;
  final Value<int?> paymentSourceId;
  final Value<bool> autopay;
  final Value<int?> dueMonth;
  final Value<int?> dueYear;
  final Value<String> category;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.frequency = const Value.absent(),
    this.paymentSourceType = const Value.absent(),
    this.paymentSourceId = const Value.absent(),
    this.autopay = const Value.absent(),
    this.dueMonth = const Value.absent(),
    this.dueYear = const Value.absent(),
    this.category = const Value.absent(),
  });
  BillsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required int amountCents,
    required int dueDay,
    this.frequency = const Value.absent(),
    this.paymentSourceType = const Value.absent(),
    this.paymentSourceId = const Value.absent(),
    this.autopay = const Value.absent(),
    this.dueMonth = const Value.absent(),
    this.dueYear = const Value.absent(),
    this.category = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       amountCents = Value(amountCents),
       dueDay = Value(dueDay);
  static Insertable<Bill> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<int>? amountCents,
    Expression<int>? dueDay,
    Expression<String>? frequency,
    Expression<String>? paymentSourceType,
    Expression<int>? paymentSourceId,
    Expression<bool>? autopay,
    Expression<int>? dueMonth,
    Expression<int>? dueYear,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (amountCents != null) 'amount_cents': amountCents,
      if (dueDay != null) 'due_day': dueDay,
      if (frequency != null) 'frequency': frequency,
      if (paymentSourceType != null) 'payment_source_type': paymentSourceType,
      if (paymentSourceId != null) 'payment_source_id': paymentSourceId,
      if (autopay != null) 'autopay': autopay,
      if (dueMonth != null) 'due_month': dueMonth,
      if (dueYear != null) 'due_year': dueYear,
      if (category != null) 'category': category,
    });
  }

  BillsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<int>? amountCents,
    Value<int>? dueDay,
    Value<BillFrequency>? frequency,
    Value<PaymentSourceType?>? paymentSourceType,
    Value<int?>? paymentSourceId,
    Value<bool>? autopay,
    Value<int?>? dueMonth,
    Value<int?>? dueYear,
    Value<String>? category,
  }) {
    return BillsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      amountCents: amountCents ?? this.amountCents,
      dueDay: dueDay ?? this.dueDay,
      frequency: frequency ?? this.frequency,
      paymentSourceType: paymentSourceType ?? this.paymentSourceType,
      paymentSourceId: paymentSourceId ?? this.paymentSourceId,
      autopay: autopay ?? this.autopay,
      dueMonth: dueMonth ?? this.dueMonth,
      dueYear: dueYear ?? this.dueYear,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $BillsTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (paymentSourceType.present) {
      map['payment_source_type'] = Variable<String>(
        $BillsTable.$converterpaymentSourceTypen.toSql(paymentSourceType.value),
      );
    }
    if (paymentSourceId.present) {
      map['payment_source_id'] = Variable<int>(paymentSourceId.value);
    }
    if (autopay.present) {
      map['autopay'] = Variable<bool>(autopay.value);
    }
    if (dueMonth.present) {
      map['due_month'] = Variable<int>(dueMonth.value);
    }
    if (dueYear.present) {
      map['due_year'] = Variable<int>(dueYear.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('amountCents: $amountCents, ')
          ..write('dueDay: $dueDay, ')
          ..write('frequency: $frequency, ')
          ..write('paymentSourceType: $paymentSourceType, ')
          ..write('paymentSourceId: $paymentSourceId, ')
          ..write('autopay: $autopay, ')
          ..write('dueMonth: $dueMonth, ')
          ..write('dueYear: $dueYear, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $BillPaymentsTable extends BillPayments
    with TableInfo<$BillPaymentsTable, BillPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    billId,
    periodStart,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {billId, periodStart},
  ];
  @override
  BillPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      )!,
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
    );
  }

  @override
  $BillPaymentsTable createAlias(String alias) {
    return $BillPaymentsTable(attachedDatabase, alias);
  }
}

class BillPayment extends DataClass implements Insertable<BillPayment> {
  final int id;
  final int profileId;
  final int billId;

  /// Midnight on the first day of the month this payment covers.
  final DateTime periodStart;
  final DateTime paidAt;
  const BillPayment({
    required this.id,
    required this.profileId,
    required this.billId,
    required this.periodStart,
    required this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['bill_id'] = Variable<int>(billId);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['paid_at'] = Variable<DateTime>(paidAt);
    return map;
  }

  BillPaymentsCompanion toCompanion(bool nullToAbsent) {
    return BillPaymentsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      billId: Value(billId),
      periodStart: Value(periodStart),
      paidAt: Value(paidAt),
    );
  }

  factory BillPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillPayment(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      billId: serializer.fromJson<int>(json['billId']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'billId': serializer.toJson<int>(billId),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'paidAt': serializer.toJson<DateTime>(paidAt),
    };
  }

  BillPayment copyWith({
    int? id,
    int? profileId,
    int? billId,
    DateTime? periodStart,
    DateTime? paidAt,
  }) => BillPayment(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    billId: billId ?? this.billId,
    periodStart: periodStart ?? this.periodStart,
    paidAt: paidAt ?? this.paidAt,
  );
  BillPayment copyWithCompanion(BillPaymentsCompanion data) {
    return BillPayment(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      billId: data.billId.present ? data.billId.value : this.billId,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillPayment(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('billId: $billId, ')
          ..write('periodStart: $periodStart, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, billId, periodStart, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillPayment &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.billId == this.billId &&
          other.periodStart == this.periodStart &&
          other.paidAt == this.paidAt);
}

class BillPaymentsCompanion extends UpdateCompanion<BillPayment> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> billId;
  final Value<DateTime> periodStart;
  final Value<DateTime> paidAt;
  const BillPaymentsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.billId = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.paidAt = const Value.absent(),
  });
  BillPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int billId,
    required DateTime periodStart,
    required DateTime paidAt,
  }) : profileId = Value(profileId),
       billId = Value(billId),
       periodStart = Value(periodStart),
       paidAt = Value(paidAt);
  static Insertable<BillPayment> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? billId,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? paidAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (billId != null) 'bill_id': billId,
      if (periodStart != null) 'period_start': periodStart,
      if (paidAt != null) 'paid_at': paidAt,
    });
  }

  BillPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? billId,
    Value<DateTime>? periodStart,
    Value<DateTime>? paidAt,
  }) {
    return BillPaymentsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      billId: billId ?? this.billId,
      periodStart: periodStart ?? this.periodStart,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('billId: $billId, ')
          ..write('periodStart: $periodStart, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }
}

class $CreditScoreSnapshotsTable extends CreditScoreSnapshots
    with TableInfo<$CreditScoreSnapshotsTable, CreditScoreSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditScoreSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utilizationMeta = const VerificationMeta(
    'utilization',
  );
  @override
  late final GeneratedColumn<double> utilization = GeneratedColumn<double>(
    'utilization',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _derogatoryMarksMeta = const VerificationMeta(
    'derogatoryMarks',
  );
  @override
  late final GeneratedColumn<int> derogatoryMarks = GeneratedColumn<int>(
    'derogatory_marks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accountAgeMonthsMeta = const VerificationMeta(
    'accountAgeMonths',
  );
  @override
  late final GeneratedColumn<int> accountAgeMonths = GeneratedColumn<int>(
    'account_age_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hardInquiriesMeta = const VerificationMeta(
    'hardInquiries',
  );
  @override
  late final GeneratedColumn<int> hardInquiries = GeneratedColumn<int>(
    'hard_inquiries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    date,
    score,
    utilization,
    derogatoryMarks,
    accountAgeMonths,
    hardInquiries,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_score_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditScoreSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('utilization')) {
      context.handle(
        _utilizationMeta,
        utilization.isAcceptableOrUnknown(
          data['utilization']!,
          _utilizationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utilizationMeta);
    }
    if (data.containsKey('derogatory_marks')) {
      context.handle(
        _derogatoryMarksMeta,
        derogatoryMarks.isAcceptableOrUnknown(
          data['derogatory_marks']!,
          _derogatoryMarksMeta,
        ),
      );
    }
    if (data.containsKey('account_age_months')) {
      context.handle(
        _accountAgeMonthsMeta,
        accountAgeMonths.isAcceptableOrUnknown(
          data['account_age_months']!,
          _accountAgeMonthsMeta,
        ),
      );
    }
    if (data.containsKey('hard_inquiries')) {
      context.handle(
        _hardInquiriesMeta,
        hardInquiries.isAcceptableOrUnknown(
          data['hard_inquiries']!,
          _hardInquiriesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditScoreSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditScoreSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      utilization: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}utilization'],
      )!,
      derogatoryMarks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}derogatory_marks'],
      )!,
      accountAgeMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_age_months'],
      )!,
      hardInquiries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hard_inquiries'],
      )!,
    );
  }

  @override
  $CreditScoreSnapshotsTable createAlias(String alias) {
    return $CreditScoreSnapshotsTable(attachedDatabase, alias);
  }
}

class CreditScoreSnapshot extends DataClass
    implements Insertable<CreditScoreSnapshot> {
  final int id;
  final int profileId;
  final DateTime date;
  final int score;
  final double utilization;
  final int derogatoryMarks;
  final int accountAgeMonths;
  final int hardInquiries;
  const CreditScoreSnapshot({
    required this.id,
    required this.profileId,
    required this.date,
    required this.score,
    required this.utilization,
    required this.derogatoryMarks,
    required this.accountAgeMonths,
    required this.hardInquiries,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['date'] = Variable<DateTime>(date);
    map['score'] = Variable<int>(score);
    map['utilization'] = Variable<double>(utilization);
    map['derogatory_marks'] = Variable<int>(derogatoryMarks);
    map['account_age_months'] = Variable<int>(accountAgeMonths);
    map['hard_inquiries'] = Variable<int>(hardInquiries);
    return map;
  }

  CreditScoreSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return CreditScoreSnapshotsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      score: Value(score),
      utilization: Value(utilization),
      derogatoryMarks: Value(derogatoryMarks),
      accountAgeMonths: Value(accountAgeMonths),
      hardInquiries: Value(hardInquiries),
    );
  }

  factory CreditScoreSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditScoreSnapshot(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      date: serializer.fromJson<DateTime>(json['date']),
      score: serializer.fromJson<int>(json['score']),
      utilization: serializer.fromJson<double>(json['utilization']),
      derogatoryMarks: serializer.fromJson<int>(json['derogatoryMarks']),
      accountAgeMonths: serializer.fromJson<int>(json['accountAgeMonths']),
      hardInquiries: serializer.fromJson<int>(json['hardInquiries']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'date': serializer.toJson<DateTime>(date),
      'score': serializer.toJson<int>(score),
      'utilization': serializer.toJson<double>(utilization),
      'derogatoryMarks': serializer.toJson<int>(derogatoryMarks),
      'accountAgeMonths': serializer.toJson<int>(accountAgeMonths),
      'hardInquiries': serializer.toJson<int>(hardInquiries),
    };
  }

  CreditScoreSnapshot copyWith({
    int? id,
    int? profileId,
    DateTime? date,
    int? score,
    double? utilization,
    int? derogatoryMarks,
    int? accountAgeMonths,
    int? hardInquiries,
  }) => CreditScoreSnapshot(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    date: date ?? this.date,
    score: score ?? this.score,
    utilization: utilization ?? this.utilization,
    derogatoryMarks: derogatoryMarks ?? this.derogatoryMarks,
    accountAgeMonths: accountAgeMonths ?? this.accountAgeMonths,
    hardInquiries: hardInquiries ?? this.hardInquiries,
  );
  CreditScoreSnapshot copyWithCompanion(CreditScoreSnapshotsCompanion data) {
    return CreditScoreSnapshot(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      score: data.score.present ? data.score.value : this.score,
      utilization: data.utilization.present
          ? data.utilization.value
          : this.utilization,
      derogatoryMarks: data.derogatoryMarks.present
          ? data.derogatoryMarks.value
          : this.derogatoryMarks,
      accountAgeMonths: data.accountAgeMonths.present
          ? data.accountAgeMonths.value
          : this.accountAgeMonths,
      hardInquiries: data.hardInquiries.present
          ? data.hardInquiries.value
          : this.hardInquiries,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditScoreSnapshot(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('utilization: $utilization, ')
          ..write('derogatoryMarks: $derogatoryMarks, ')
          ..write('accountAgeMonths: $accountAgeMonths, ')
          ..write('hardInquiries: $hardInquiries')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    date,
    score,
    utilization,
    derogatoryMarks,
    accountAgeMonths,
    hardInquiries,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditScoreSnapshot &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.score == this.score &&
          other.utilization == this.utilization &&
          other.derogatoryMarks == this.derogatoryMarks &&
          other.accountAgeMonths == this.accountAgeMonths &&
          other.hardInquiries == this.hardInquiries);
}

class CreditScoreSnapshotsCompanion
    extends UpdateCompanion<CreditScoreSnapshot> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<DateTime> date;
  final Value<int> score;
  final Value<double> utilization;
  final Value<int> derogatoryMarks;
  final Value<int> accountAgeMonths;
  final Value<int> hardInquiries;
  const CreditScoreSnapshotsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.score = const Value.absent(),
    this.utilization = const Value.absent(),
    this.derogatoryMarks = const Value.absent(),
    this.accountAgeMonths = const Value.absent(),
    this.hardInquiries = const Value.absent(),
  });
  CreditScoreSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required DateTime date,
    required int score,
    required double utilization,
    this.derogatoryMarks = const Value.absent(),
    this.accountAgeMonths = const Value.absent(),
    this.hardInquiries = const Value.absent(),
  }) : profileId = Value(profileId),
       date = Value(date),
       score = Value(score),
       utilization = Value(utilization);
  static Insertable<CreditScoreSnapshot> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<DateTime>? date,
    Expression<int>? score,
    Expression<double>? utilization,
    Expression<int>? derogatoryMarks,
    Expression<int>? accountAgeMonths,
    Expression<int>? hardInquiries,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (score != null) 'score': score,
      if (utilization != null) 'utilization': utilization,
      if (derogatoryMarks != null) 'derogatory_marks': derogatoryMarks,
      if (accountAgeMonths != null) 'account_age_months': accountAgeMonths,
      if (hardInquiries != null) 'hard_inquiries': hardInquiries,
    });
  }

  CreditScoreSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<DateTime>? date,
    Value<int>? score,
    Value<double>? utilization,
    Value<int>? derogatoryMarks,
    Value<int>? accountAgeMonths,
    Value<int>? hardInquiries,
  }) {
    return CreditScoreSnapshotsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      score: score ?? this.score,
      utilization: utilization ?? this.utilization,
      derogatoryMarks: derogatoryMarks ?? this.derogatoryMarks,
      accountAgeMonths: accountAgeMonths ?? this.accountAgeMonths,
      hardInquiries: hardInquiries ?? this.hardInquiries,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (utilization.present) {
      map['utilization'] = Variable<double>(utilization.value);
    }
    if (derogatoryMarks.present) {
      map['derogatory_marks'] = Variable<int>(derogatoryMarks.value);
    }
    if (accountAgeMonths.present) {
      map['account_age_months'] = Variable<int>(accountAgeMonths.value);
    }
    if (hardInquiries.present) {
      map['hard_inquiries'] = Variable<int>(hardInquiries.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditScoreSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('utilization: $utilization, ')
          ..write('derogatoryMarks: $derogatoryMarks, ')
          ..write('accountAgeMonths: $accountAgeMonths, ')
          ..write('hardInquiries: $hardInquiries')
          ..write(')'))
        .toString();
  }
}

class $PaycheckSchedulesTable extends PaycheckSchedules
    with TableInfo<$PaycheckSchedulesTable, PaycheckSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaycheckSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayFrequency, String> frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PayFrequency>(
        $PaycheckSchedulesTable.$converterfrequency,
      );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<DateTime> anchorDate = GeneratedColumn<DateTime>(
    'anchor_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    frequency,
    anchorDate,
    amountCents,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paycheck_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaycheckSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaycheckSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaycheckSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      frequency: $PaycheckSchedulesTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}anchor_date'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $PaycheckSchedulesTable createAlias(String alias) {
    return $PaycheckSchedulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PayFrequency, String, String> $converterfrequency =
      const EnumNameConverter<PayFrequency>(PayFrequency.values);
}

class PaycheckSchedule extends DataClass
    implements Insertable<PaycheckSchedule> {
  final int id;
  final int profileId;
  final String name;
  final PayFrequency frequency;
  final DateTime anchorDate;
  final int amountCents;
  final bool active;
  const PaycheckSchedule({
    required this.id,
    required this.profileId,
    required this.name,
    required this.frequency,
    required this.anchorDate,
    required this.amountCents,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    {
      map['frequency'] = Variable<String>(
        $PaycheckSchedulesTable.$converterfrequency.toSql(frequency),
      );
    }
    map['anchor_date'] = Variable<DateTime>(anchorDate);
    map['amount_cents'] = Variable<int>(amountCents);
    map['active'] = Variable<bool>(active);
    return map;
  }

  PaycheckSchedulesCompanion toCompanion(bool nullToAbsent) {
    return PaycheckSchedulesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      frequency: Value(frequency),
      anchorDate: Value(anchorDate),
      amountCents: Value(amountCents),
      active: Value(active),
    );
  }

  factory PaycheckSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaycheckSchedule(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      frequency: $PaycheckSchedulesTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      anchorDate: serializer.fromJson<DateTime>(json['anchorDate']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'frequency': serializer.toJson<String>(
        $PaycheckSchedulesTable.$converterfrequency.toJson(frequency),
      ),
      'anchorDate': serializer.toJson<DateTime>(anchorDate),
      'amountCents': serializer.toJson<int>(amountCents),
      'active': serializer.toJson<bool>(active),
    };
  }

  PaycheckSchedule copyWith({
    int? id,
    int? profileId,
    String? name,
    PayFrequency? frequency,
    DateTime? anchorDate,
    int? amountCents,
    bool? active,
  }) => PaycheckSchedule(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    frequency: frequency ?? this.frequency,
    anchorDate: anchorDate ?? this.anchorDate,
    amountCents: amountCents ?? this.amountCents,
    active: active ?? this.active,
  );
  PaycheckSchedule copyWithCompanion(PaycheckSchedulesCompanion data) {
    return PaycheckSchedule(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaycheckSchedule(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('frequency: $frequency, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('amountCents: $amountCents, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    frequency,
    anchorDate,
    amountCents,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaycheckSchedule &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.frequency == this.frequency &&
          other.anchorDate == this.anchorDate &&
          other.amountCents == this.amountCents &&
          other.active == this.active);
}

class PaycheckSchedulesCompanion extends UpdateCompanion<PaycheckSchedule> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<PayFrequency> frequency;
  final Value<DateTime> anchorDate;
  final Value<int> amountCents;
  final Value<bool> active;
  const PaycheckSchedulesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.frequency = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.active = const Value.absent(),
  });
  PaycheckSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required PayFrequency frequency,
    required DateTime anchorDate,
    required int amountCents,
    this.active = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       frequency = Value(frequency),
       anchorDate = Value(anchorDate),
       amountCents = Value(amountCents);
  static Insertable<PaycheckSchedule> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<String>? frequency,
    Expression<DateTime>? anchorDate,
    Expression<int>? amountCents,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (frequency != null) 'frequency': frequency,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (amountCents != null) 'amount_cents': amountCents,
      if (active != null) 'active': active,
    });
  }

  PaycheckSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<PayFrequency>? frequency,
    Value<DateTime>? anchorDate,
    Value<int>? amountCents,
    Value<bool>? active,
  }) {
    return PaycheckSchedulesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      anchorDate: anchorDate ?? this.anchorDate,
      amountCents: amountCents ?? this.amountCents,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $PaycheckSchedulesTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<DateTime>(anchorDate.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaycheckSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('frequency: $frequency, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('amountCents: $amountCents, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $PaychecksTable extends Paychecks
    with TableInfo<$PaychecksTable, Paycheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaychecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonusCentsMeta = const VerificationMeta(
    'bonusCents',
  );
  @override
  late final GeneratedColumn<int> bonusCents = GeneratedColumn<int>(
    'bonus_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receivedMeta = const VerificationMeta(
    'received',
  );
  @override
  late final GeneratedColumn<bool> received = GeneratedColumn<bool>(
    'received',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("received" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receivedIsManualMeta = const VerificationMeta(
    'receivedIsManual',
  );
  @override
  late final GeneratedColumn<bool> receivedIsManual = GeneratedColumn<bool>(
    'received_is_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("received_is_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dismissedMeta = const VerificationMeta(
    'dismissed',
  );
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
    'dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
    'schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES paycheck_schedules (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    date,
    amountCents,
    bonusCents,
    received,
    receivedIsManual,
    dismissed,
    scheduleId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paychecks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Paycheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('bonus_cents')) {
      context.handle(
        _bonusCentsMeta,
        bonusCents.isAcceptableOrUnknown(data['bonus_cents']!, _bonusCentsMeta),
      );
    }
    if (data.containsKey('received')) {
      context.handle(
        _receivedMeta,
        received.isAcceptableOrUnknown(data['received']!, _receivedMeta),
      );
    }
    if (data.containsKey('received_is_manual')) {
      context.handle(
        _receivedIsManualMeta,
        receivedIsManual.isAcceptableOrUnknown(
          data['received_is_manual']!,
          _receivedIsManualMeta,
        ),
      );
    }
    if (data.containsKey('dismissed')) {
      context.handle(
        _dismissedMeta,
        dismissed.isAcceptableOrUnknown(data['dismissed']!, _dismissedMeta),
      );
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Paycheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paycheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      bonusCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_cents'],
      )!,
      received: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}received'],
      )!,
      receivedIsManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}received_is_manual'],
      )!,
      dismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dismissed'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_id'],
      ),
    );
  }

  @override
  $PaychecksTable createAlias(String alias) {
    return $PaychecksTable(attachedDatabase, alias);
  }
}

class Paycheck extends DataClass implements Insertable<Paycheck> {
  final int id;
  final int profileId;
  final String name;
  final DateTime date;
  final int amountCents;
  final int bonusCents;
  final bool received;

  /// True once you set [received] by hand. Automatic processing skips these
  /// rows, so overriding a paycheck (it was delayed, it never arrived) is
  /// not undone the next time the app opens.
  final bool receivedIsManual;

  /// Deleted by you. The row is kept rather than removed so the schedule
  /// that produced it doesn't just generate the same payday again; it is
  /// hidden everywhere in the UI.
  final bool dismissed;

  /// Set when this check was generated from a schedule.
  final int? scheduleId;
  const Paycheck({
    required this.id,
    required this.profileId,
    required this.name,
    required this.date,
    required this.amountCents,
    required this.bonusCents,
    required this.received,
    required this.receivedIsManual,
    required this.dismissed,
    this.scheduleId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    map['amount_cents'] = Variable<int>(amountCents);
    map['bonus_cents'] = Variable<int>(bonusCents);
    map['received'] = Variable<bool>(received);
    map['received_is_manual'] = Variable<bool>(receivedIsManual);
    map['dismissed'] = Variable<bool>(dismissed);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<int>(scheduleId);
    }
    return map;
  }

  PaychecksCompanion toCompanion(bool nullToAbsent) {
    return PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      date: Value(date),
      amountCents: Value(amountCents),
      bonusCents: Value(bonusCents),
      received: Value(received),
      receivedIsManual: Value(receivedIsManual),
      dismissed: Value(dismissed),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
    );
  }

  factory Paycheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paycheck(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      bonusCents: serializer.fromJson<int>(json['bonusCents']),
      received: serializer.fromJson<bool>(json['received']),
      receivedIsManual: serializer.fromJson<bool>(json['receivedIsManual']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
      scheduleId: serializer.fromJson<int?>(json['scheduleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'amountCents': serializer.toJson<int>(amountCents),
      'bonusCents': serializer.toJson<int>(bonusCents),
      'received': serializer.toJson<bool>(received),
      'receivedIsManual': serializer.toJson<bool>(receivedIsManual),
      'dismissed': serializer.toJson<bool>(dismissed),
      'scheduleId': serializer.toJson<int?>(scheduleId),
    };
  }

  Paycheck copyWith({
    int? id,
    int? profileId,
    String? name,
    DateTime? date,
    int? amountCents,
    int? bonusCents,
    bool? received,
    bool? receivedIsManual,
    bool? dismissed,
    Value<int?> scheduleId = const Value.absent(),
  }) => Paycheck(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    date: date ?? this.date,
    amountCents: amountCents ?? this.amountCents,
    bonusCents: bonusCents ?? this.bonusCents,
    received: received ?? this.received,
    receivedIsManual: receivedIsManual ?? this.receivedIsManual,
    dismissed: dismissed ?? this.dismissed,
    scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
  );
  Paycheck copyWithCompanion(PaychecksCompanion data) {
    return Paycheck(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      bonusCents: data.bonusCents.present
          ? data.bonusCents.value
          : this.bonusCents,
      received: data.received.present ? data.received.value : this.received,
      receivedIsManual: data.receivedIsManual.present
          ? data.receivedIsManual.value
          : this.receivedIsManual,
      dismissed: data.dismissed.present ? data.dismissed.value : this.dismissed,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paycheck(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents, ')
          ..write('bonusCents: $bonusCents, ')
          ..write('received: $received, ')
          ..write('receivedIsManual: $receivedIsManual, ')
          ..write('dismissed: $dismissed, ')
          ..write('scheduleId: $scheduleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    date,
    amountCents,
    bonusCents,
    received,
    receivedIsManual,
    dismissed,
    scheduleId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paycheck &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.date == this.date &&
          other.amountCents == this.amountCents &&
          other.bonusCents == this.bonusCents &&
          other.received == this.received &&
          other.receivedIsManual == this.receivedIsManual &&
          other.dismissed == this.dismissed &&
          other.scheduleId == this.scheduleId);
}

class PaychecksCompanion extends UpdateCompanion<Paycheck> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<int> amountCents;
  final Value<int> bonusCents;
  final Value<bool> received;
  final Value<bool> receivedIsManual;
  final Value<bool> dismissed;
  final Value<int?> scheduleId;
  const PaychecksCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.bonusCents = const Value.absent(),
    this.received = const Value.absent(),
    this.receivedIsManual = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.scheduleId = const Value.absent(),
  });
  PaychecksCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required DateTime date,
    required int amountCents,
    this.bonusCents = const Value.absent(),
    this.received = const Value.absent(),
    this.receivedIsManual = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.scheduleId = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       date = Value(date),
       amountCents = Value(amountCents);
  static Insertable<Paycheck> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<int>? amountCents,
    Expression<int>? bonusCents,
    Expression<bool>? received,
    Expression<bool>? receivedIsManual,
    Expression<bool>? dismissed,
    Expression<int>? scheduleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (amountCents != null) 'amount_cents': amountCents,
      if (bonusCents != null) 'bonus_cents': bonusCents,
      if (received != null) 'received': received,
      if (receivedIsManual != null) 'received_is_manual': receivedIsManual,
      if (dismissed != null) 'dismissed': dismissed,
      if (scheduleId != null) 'schedule_id': scheduleId,
    });
  }

  PaychecksCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<DateTime>? date,
    Value<int>? amountCents,
    Value<int>? bonusCents,
    Value<bool>? received,
    Value<bool>? receivedIsManual,
    Value<bool>? dismissed,
    Value<int?>? scheduleId,
  }) {
    return PaychecksCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      bonusCents: bonusCents ?? this.bonusCents,
      received: received ?? this.received,
      receivedIsManual: receivedIsManual ?? this.receivedIsManual,
      dismissed: dismissed ?? this.dismissed,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (bonusCents.present) {
      map['bonus_cents'] = Variable<int>(bonusCents.value);
    }
    if (received.present) {
      map['received'] = Variable<bool>(received.value);
    }
    if (receivedIsManual.present) {
      map['received_is_manual'] = Variable<bool>(receivedIsManual.value);
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaychecksCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents, ')
          ..write('bonusCents: $bonusCents, ')
          ..write('received: $received, ')
          ..write('receivedIsManual: $receivedIsManual, ')
          ..write('dismissed: $dismissed, ')
          ..write('scheduleId: $scheduleId')
          ..write(')'))
        .toString();
  }
}

class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _sourceFilenameMeta = const VerificationMeta(
    'sourceFilename',
  );
  @override
  late final GeneratedColumn<String> sourceFilename = GeneratedColumn<String>(
    'source_filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowCountMeta = const VerificationMeta(
    'rowCount',
  );
  @override
  late final GeneratedColumn<int> rowCount = GeneratedColumn<int>(
    'row_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _balanceAdjustmentCentsMeta =
      const VerificationMeta('balanceAdjustmentCents');
  @override
  late final GeneratedColumn<int> balanceAdjustmentCents = GeneratedColumn<int>(
    'balance_adjustment_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    sourceFilename,
    importedAt,
    rowCount,
    accountId,
    balanceAdjustmentCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportBatch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('source_filename')) {
      context.handle(
        _sourceFilenameMeta,
        sourceFilename.isAcceptableOrUnknown(
          data['source_filename']!,
          _sourceFilenameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceFilenameMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('row_count')) {
      context.handle(
        _rowCountMeta,
        rowCount.isAcceptableOrUnknown(data['row_count']!, _rowCountMeta),
      );
    } else if (isInserting) {
      context.missing(_rowCountMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('balance_adjustment_cents')) {
      context.handle(
        _balanceAdjustmentCentsMeta,
        balanceAdjustmentCents.isAcceptableOrUnknown(
          data['balance_adjustment_cents']!,
          _balanceAdjustmentCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      sourceFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_filename'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      rowCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_count'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      balanceAdjustmentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_adjustment_cents'],
      )!,
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }
}

class ImportBatch extends DataClass implements Insertable<ImportBatch> {
  final int id;
  final int profileId;
  final String sourceFilename;
  final DateTime importedAt;
  final int rowCount;

  /// The account these transactions were imported into. Not a foreign key
  /// with cascade — deleting the account just clears this (see
  /// deleteAccount), same as every other account link in this schema.
  final int? accountId;

  /// Net amount applied to [accountId]'s balance when this batch was
  /// committed, or 0 if the import left the balance alone. Recorded here
  /// rather than re-derived from the entries, so undo reverses exactly
  /// what happened even if entries were edited afterward.
  final int balanceAdjustmentCents;
  const ImportBatch({
    required this.id,
    required this.profileId,
    required this.sourceFilename,
    required this.importedAt,
    required this.rowCount,
    this.accountId,
    required this.balanceAdjustmentCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['source_filename'] = Variable<String>(sourceFilename);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['row_count'] = Variable<int>(rowCount);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['balance_adjustment_cents'] = Variable<int>(balanceAdjustmentCents);
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      sourceFilename: Value(sourceFilename),
      importedAt: Value(importedAt),
      rowCount: Value(rowCount),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      balanceAdjustmentCents: Value(balanceAdjustmentCents),
    );
  }

  factory ImportBatch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatch(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      sourceFilename: serializer.fromJson<String>(json['sourceFilename']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      rowCount: serializer.fromJson<int>(json['rowCount']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      balanceAdjustmentCents: serializer.fromJson<int>(
        json['balanceAdjustmentCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'sourceFilename': serializer.toJson<String>(sourceFilename),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'rowCount': serializer.toJson<int>(rowCount),
      'accountId': serializer.toJson<int?>(accountId),
      'balanceAdjustmentCents': serializer.toJson<int>(balanceAdjustmentCents),
    };
  }

  ImportBatch copyWith({
    int? id,
    int? profileId,
    String? sourceFilename,
    DateTime? importedAt,
    int? rowCount,
    Value<int?> accountId = const Value.absent(),
    int? balanceAdjustmentCents,
  }) => ImportBatch(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    sourceFilename: sourceFilename ?? this.sourceFilename,
    importedAt: importedAt ?? this.importedAt,
    rowCount: rowCount ?? this.rowCount,
    accountId: accountId.present ? accountId.value : this.accountId,
    balanceAdjustmentCents:
        balanceAdjustmentCents ?? this.balanceAdjustmentCents,
  );
  ImportBatch copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatch(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      sourceFilename: data.sourceFilename.present
          ? data.sourceFilename.value
          : this.sourceFilename,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      rowCount: data.rowCount.present ? data.rowCount.value : this.rowCount,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      balanceAdjustmentCents: data.balanceAdjustmentCents.present
          ? data.balanceAdjustmentCents.value
          : this.balanceAdjustmentCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatch(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sourceFilename: $sourceFilename, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowCount: $rowCount, ')
          ..write('accountId: $accountId, ')
          ..write('balanceAdjustmentCents: $balanceAdjustmentCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    sourceFilename,
    importedAt,
    rowCount,
    accountId,
    balanceAdjustmentCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatch &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.sourceFilename == this.sourceFilename &&
          other.importedAt == this.importedAt &&
          other.rowCount == this.rowCount &&
          other.accountId == this.accountId &&
          other.balanceAdjustmentCents == this.balanceAdjustmentCents);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatch> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> sourceFilename;
  final Value<DateTime> importedAt;
  final Value<int> rowCount;
  final Value<int?> accountId;
  final Value<int> balanceAdjustmentCents;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.sourceFilename = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowCount = const Value.absent(),
    this.accountId = const Value.absent(),
    this.balanceAdjustmentCents = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String sourceFilename,
    required DateTime importedAt,
    required int rowCount,
    this.accountId = const Value.absent(),
    this.balanceAdjustmentCents = const Value.absent(),
  }) : profileId = Value(profileId),
       sourceFilename = Value(sourceFilename),
       importedAt = Value(importedAt),
       rowCount = Value(rowCount);
  static Insertable<ImportBatch> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? sourceFilename,
    Expression<DateTime>? importedAt,
    Expression<int>? rowCount,
    Expression<int>? accountId,
    Expression<int>? balanceAdjustmentCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (sourceFilename != null) 'source_filename': sourceFilename,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowCount != null) 'row_count': rowCount,
      if (accountId != null) 'account_id': accountId,
      if (balanceAdjustmentCents != null)
        'balance_adjustment_cents': balanceAdjustmentCents,
    });
  }

  ImportBatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? sourceFilename,
    Value<DateTime>? importedAt,
    Value<int>? rowCount,
    Value<int?>? accountId,
    Value<int>? balanceAdjustmentCents,
  }) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      sourceFilename: sourceFilename ?? this.sourceFilename,
      importedAt: importedAt ?? this.importedAt,
      rowCount: rowCount ?? this.rowCount,
      accountId: accountId ?? this.accountId,
      balanceAdjustmentCents:
          balanceAdjustmentCents ?? this.balanceAdjustmentCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (sourceFilename.present) {
      map['source_filename'] = Variable<String>(sourceFilename.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (rowCount.present) {
      map['row_count'] = Variable<int>(rowCount.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (balanceAdjustmentCents.present) {
      map['balance_adjustment_cents'] = Variable<int>(
        balanceAdjustmentCents.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sourceFilename: $sourceFilename, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowCount: $rowCount, ')
          ..write('accountId: $accountId, ')
          ..write('balanceAdjustmentCents: $balanceAdjustmentCents')
          ..write(')'))
        .toString();
  }
}

class $BudgetEntriesTable extends BudgetEntries
    with TableInfo<$BudgetEntriesTable, BudgetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Other'),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntryType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntryType>($BudgetEntriesTable.$convertertype);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id)',
    ),
  );
  static const VerificationMeta _sourcePaycheckIdMeta = const VerificationMeta(
    'sourcePaycheckId',
  );
  @override
  late final GeneratedColumn<int> sourcePaycheckId = GeneratedColumn<int>(
    'source_paycheck_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES paychecks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceBillPaymentIdMeta =
      const VerificationMeta('sourceBillPaymentId');
  @override
  late final GeneratedColumn<int> sourceBillPaymentId = GeneratedColumn<int>(
    'source_bill_payment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bill_payments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _importBatchIdMeta = const VerificationMeta(
    'importBatchId',
  );
  @override
  late final GeneratedColumn<int> importBatchId = GeneratedColumn<int>(
    'import_batch_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    date,
    category,
    amountCents,
    type,
    description,
    payee,
    accountId,
    cardId,
    sourcePaycheckId,
    sourceBillPaymentId,
    importBatchId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('source_paycheck_id')) {
      context.handle(
        _sourcePaycheckIdMeta,
        sourcePaycheckId.isAcceptableOrUnknown(
          data['source_paycheck_id']!,
          _sourcePaycheckIdMeta,
        ),
      );
    }
    if (data.containsKey('source_bill_payment_id')) {
      context.handle(
        _sourceBillPaymentIdMeta,
        sourceBillPaymentId.isAcceptableOrUnknown(
          data['source_bill_payment_id']!,
          _sourceBillPaymentIdMeta,
        ),
      );
    }
    if (data.containsKey('import_batch_id')) {
      context.handle(
        _importBatchIdMeta,
        importBatchId.isAcceptableOrUnknown(
          data['import_batch_id']!,
          _importBatchIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      type: $BudgetEntriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      ),
      sourcePaycheckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_paycheck_id'],
      ),
      sourceBillPaymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_bill_payment_id'],
      ),
      importBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_batch_id'],
      ),
    );
  }

  @override
  $BudgetEntriesTable createAlias(String alias) {
    return $BudgetEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EntryType, String, String> $convertertype =
      const EnumNameConverter<EntryType>(EntryType.values);
}

class BudgetEntry extends DataClass implements Insertable<BudgetEntry> {
  final int id;
  final int profileId;
  final DateTime date;
  final String category;
  final int amountCents;
  final EntryType type;
  final String? description;

  /// Who was paid or who paid you — separate from the free-text description,
  /// so "top payees" can be totaled without parsing description text.
  final String? payee;

  /// Which account the money moved through, when known.
  final int? accountId;

  /// Which card the money was charged to or credited from, when known.
  /// Mutually exclusive with [accountId] in practice — the entry moves
  /// through one or the other, never both.
  final int? cardId;

  /// Set when this entry was generated automatically because a paycheck was
  /// marked received — keeps the two in sync instead of double-entry.
  final int? sourcePaycheckId;

  /// Set when this entry was generated automatically because a bill was
  /// marked paid. Deleting the payment (or the bill) removes this entry.
  final int? sourceBillPaymentId;

  /// Set when this entry came from a CSV import, so the whole batch can be
  /// undone together. Imported entries deliberately do not move any
  /// account or card balance on their own — see [ImportBatches].
  final int? importBatchId;
  const BudgetEntry({
    required this.id,
    required this.profileId,
    required this.date,
    required this.category,
    required this.amountCents,
    required this.type,
    this.description,
    this.payee,
    this.accountId,
    this.cardId,
    this.sourcePaycheckId,
    this.sourceBillPaymentId,
    this.importBatchId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['amount_cents'] = Variable<int>(amountCents);
    {
      map['type'] = Variable<String>(
        $BudgetEntriesTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<int>(cardId);
    }
    if (!nullToAbsent || sourcePaycheckId != null) {
      map['source_paycheck_id'] = Variable<int>(sourcePaycheckId);
    }
    if (!nullToAbsent || sourceBillPaymentId != null) {
      map['source_bill_payment_id'] = Variable<int>(sourceBillPaymentId);
    }
    if (!nullToAbsent || importBatchId != null) {
      map['import_batch_id'] = Variable<int>(importBatchId);
    }
    return map;
  }

  BudgetEntriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      category: Value(category),
      amountCents: Value(amountCents),
      type: Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      payee: payee == null && nullToAbsent
          ? const Value.absent()
          : Value(payee),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      cardId: cardId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardId),
      sourcePaycheckId: sourcePaycheckId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePaycheckId),
      sourceBillPaymentId: sourceBillPaymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBillPaymentId),
      importBatchId: importBatchId == null && nullToAbsent
          ? const Value.absent()
          : Value(importBatchId),
    );
  }

  factory BudgetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntry(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      type: $BudgetEntriesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      description: serializer.fromJson<String?>(json['description']),
      payee: serializer.fromJson<String?>(json['payee']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      cardId: serializer.fromJson<int?>(json['cardId']),
      sourcePaycheckId: serializer.fromJson<int?>(json['sourcePaycheckId']),
      sourceBillPaymentId: serializer.fromJson<int?>(
        json['sourceBillPaymentId'],
      ),
      importBatchId: serializer.fromJson<int?>(json['importBatchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'amountCents': serializer.toJson<int>(amountCents),
      'type': serializer.toJson<String>(
        $BudgetEntriesTable.$convertertype.toJson(type),
      ),
      'description': serializer.toJson<String?>(description),
      'payee': serializer.toJson<String?>(payee),
      'accountId': serializer.toJson<int?>(accountId),
      'cardId': serializer.toJson<int?>(cardId),
      'sourcePaycheckId': serializer.toJson<int?>(sourcePaycheckId),
      'sourceBillPaymentId': serializer.toJson<int?>(sourceBillPaymentId),
      'importBatchId': serializer.toJson<int?>(importBatchId),
    };
  }

  BudgetEntry copyWith({
    int? id,
    int? profileId,
    DateTime? date,
    String? category,
    int? amountCents,
    EntryType? type,
    Value<String?> description = const Value.absent(),
    Value<String?> payee = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    Value<int?> cardId = const Value.absent(),
    Value<int?> sourcePaycheckId = const Value.absent(),
    Value<int?> sourceBillPaymentId = const Value.absent(),
    Value<int?> importBatchId = const Value.absent(),
  }) => BudgetEntry(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    date: date ?? this.date,
    category: category ?? this.category,
    amountCents: amountCents ?? this.amountCents,
    type: type ?? this.type,
    description: description.present ? description.value : this.description,
    payee: payee.present ? payee.value : this.payee,
    accountId: accountId.present ? accountId.value : this.accountId,
    cardId: cardId.present ? cardId.value : this.cardId,
    sourcePaycheckId: sourcePaycheckId.present
        ? sourcePaycheckId.value
        : this.sourcePaycheckId,
    sourceBillPaymentId: sourceBillPaymentId.present
        ? sourceBillPaymentId.value
        : this.sourceBillPaymentId,
    importBatchId: importBatchId.present
        ? importBatchId.value
        : this.importBatchId,
  );
  BudgetEntry copyWithCompanion(BudgetEntriesCompanion data) {
    return BudgetEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      payee: data.payee.present ? data.payee.value : this.payee,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      sourcePaycheckId: data.sourcePaycheckId.present
          ? data.sourcePaycheckId.value
          : this.sourcePaycheckId,
      sourceBillPaymentId: data.sourceBillPaymentId.present
          ? data.sourceBillPaymentId.value
          : this.sourceBillPaymentId,
      importBatchId: data.importBatchId.present
          ? data.importBatchId.value
          : this.importBatchId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('amountCents: $amountCents, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('payee: $payee, ')
          ..write('accountId: $accountId, ')
          ..write('cardId: $cardId, ')
          ..write('sourcePaycheckId: $sourcePaycheckId, ')
          ..write('sourceBillPaymentId: $sourceBillPaymentId, ')
          ..write('importBatchId: $importBatchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    date,
    category,
    amountCents,
    type,
    description,
    payee,
    accountId,
    cardId,
    sourcePaycheckId,
    sourceBillPaymentId,
    importBatchId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.category == this.category &&
          other.amountCents == this.amountCents &&
          other.type == this.type &&
          other.description == this.description &&
          other.payee == this.payee &&
          other.accountId == this.accountId &&
          other.cardId == this.cardId &&
          other.sourcePaycheckId == this.sourcePaycheckId &&
          other.sourceBillPaymentId == this.sourceBillPaymentId &&
          other.importBatchId == this.importBatchId);
}

class BudgetEntriesCompanion extends UpdateCompanion<BudgetEntry> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<int> amountCents;
  final Value<EntryType> type;
  final Value<String?> description;
  final Value<String?> payee;
  final Value<int?> accountId;
  final Value<int?> cardId;
  final Value<int?> sourcePaycheckId;
  final Value<int?> sourceBillPaymentId;
  final Value<int?> importBatchId;
  const BudgetEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.payee = const Value.absent(),
    this.accountId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.sourcePaycheckId = const Value.absent(),
    this.sourceBillPaymentId = const Value.absent(),
    this.importBatchId = const Value.absent(),
  });
  BudgetEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required DateTime date,
    this.category = const Value.absent(),
    required int amountCents,
    required EntryType type,
    this.description = const Value.absent(),
    this.payee = const Value.absent(),
    this.accountId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.sourcePaycheckId = const Value.absent(),
    this.sourceBillPaymentId = const Value.absent(),
    this.importBatchId = const Value.absent(),
  }) : profileId = Value(profileId),
       date = Value(date),
       amountCents = Value(amountCents),
       type = Value(type);
  static Insertable<BudgetEntry> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<int>? amountCents,
    Expression<String>? type,
    Expression<String>? description,
    Expression<String>? payee,
    Expression<int>? accountId,
    Expression<int>? cardId,
    Expression<int>? sourcePaycheckId,
    Expression<int>? sourceBillPaymentId,
    Expression<int>? importBatchId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (amountCents != null) 'amount_cents': amountCents,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (payee != null) 'payee': payee,
      if (accountId != null) 'account_id': accountId,
      if (cardId != null) 'card_id': cardId,
      if (sourcePaycheckId != null) 'source_paycheck_id': sourcePaycheckId,
      if (sourceBillPaymentId != null)
        'source_bill_payment_id': sourceBillPaymentId,
      if (importBatchId != null) 'import_batch_id': importBatchId,
    });
  }

  BudgetEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<DateTime>? date,
    Value<String>? category,
    Value<int>? amountCents,
    Value<EntryType>? type,
    Value<String?>? description,
    Value<String?>? payee,
    Value<int?>? accountId,
    Value<int?>? cardId,
    Value<int?>? sourcePaycheckId,
    Value<int?>? sourceBillPaymentId,
    Value<int?>? importBatchId,
  }) {
    return BudgetEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      category: category ?? this.category,
      amountCents: amountCents ?? this.amountCents,
      type: type ?? this.type,
      description: description ?? this.description,
      payee: payee ?? this.payee,
      accountId: accountId ?? this.accountId,
      cardId: cardId ?? this.cardId,
      sourcePaycheckId: sourcePaycheckId ?? this.sourcePaycheckId,
      sourceBillPaymentId: sourceBillPaymentId ?? this.sourceBillPaymentId,
      importBatchId: importBatchId ?? this.importBatchId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $BudgetEntriesTable.$convertertype.toSql(type.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (sourcePaycheckId.present) {
      map['source_paycheck_id'] = Variable<int>(sourcePaycheckId.value);
    }
    if (sourceBillPaymentId.present) {
      map['source_bill_payment_id'] = Variable<int>(sourceBillPaymentId.value);
    }
    if (importBatchId.present) {
      map['import_batch_id'] = Variable<int>(importBatchId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('amountCents: $amountCents, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('payee: $payee, ')
          ..write('accountId: $accountId, ')
          ..write('cardId: $cardId, ')
          ..write('sourcePaycheckId: $sourcePaycheckId, ')
          ..write('sourceBillPaymentId: $sourceBillPaymentId, ')
          ..write('importBatchId: $importBatchId')
          ..write(')'))
        .toString();
  }
}

class $BudgetTargetsTable extends BudgetTargets
    with TableInfo<$BudgetTargetsTable, BudgetTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyTargetCentsMeta =
      const VerificationMeta('monthlyTargetCents');
  @override
  late final GeneratedColumn<int> monthlyTargetCents = GeneratedColumn<int>(
    'monthly_target_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    category,
    monthlyTargetCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('monthly_target_cents')) {
      context.handle(
        _monthlyTargetCentsMeta,
        monthlyTargetCents.isAcceptableOrUnknown(
          data['monthly_target_cents']!,
          _monthlyTargetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyTargetCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, category},
  ];
  @override
  BudgetTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetTarget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      monthlyTargetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_target_cents'],
      )!,
    );
  }

  @override
  $BudgetTargetsTable createAlias(String alias) {
    return $BudgetTargetsTable(attachedDatabase, alias);
  }
}

class BudgetTarget extends DataClass implements Insertable<BudgetTarget> {
  final int id;
  final int profileId;
  final String category;
  final int monthlyTargetCents;
  const BudgetTarget({
    required this.id,
    required this.profileId,
    required this.category,
    required this.monthlyTargetCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['category'] = Variable<String>(category);
    map['monthly_target_cents'] = Variable<int>(monthlyTargetCents);
    return map;
  }

  BudgetTargetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetTargetsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      category: Value(category),
      monthlyTargetCents: Value(monthlyTargetCents),
    );
  }

  factory BudgetTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetTarget(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      category: serializer.fromJson<String>(json['category']),
      monthlyTargetCents: serializer.fromJson<int>(json['monthlyTargetCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'category': serializer.toJson<String>(category),
      'monthlyTargetCents': serializer.toJson<int>(monthlyTargetCents),
    };
  }

  BudgetTarget copyWith({
    int? id,
    int? profileId,
    String? category,
    int? monthlyTargetCents,
  }) => BudgetTarget(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    category: category ?? this.category,
    monthlyTargetCents: monthlyTargetCents ?? this.monthlyTargetCents,
  );
  BudgetTarget copyWithCompanion(BudgetTargetsCompanion data) {
    return BudgetTarget(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      category: data.category.present ? data.category.value : this.category,
      monthlyTargetCents: data.monthlyTargetCents.present
          ? data.monthlyTargetCents.value
          : this.monthlyTargetCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTarget(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('category: $category, ')
          ..write('monthlyTargetCents: $monthlyTargetCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, category, monthlyTargetCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetTarget &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.category == this.category &&
          other.monthlyTargetCents == this.monthlyTargetCents);
}

class BudgetTargetsCompanion extends UpdateCompanion<BudgetTarget> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> category;
  final Value<int> monthlyTargetCents;
  const BudgetTargetsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.category = const Value.absent(),
    this.monthlyTargetCents = const Value.absent(),
  });
  BudgetTargetsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String category,
    required int monthlyTargetCents,
  }) : profileId = Value(profileId),
       category = Value(category),
       monthlyTargetCents = Value(monthlyTargetCents);
  static Insertable<BudgetTarget> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? category,
    Expression<int>? monthlyTargetCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (category != null) 'category': category,
      if (monthlyTargetCents != null)
        'monthly_target_cents': monthlyTargetCents,
    });
  }

  BudgetTargetsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? category,
    Value<int>? monthlyTargetCents,
  }) {
    return BudgetTargetsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      category: category ?? this.category,
      monthlyTargetCents: monthlyTargetCents ?? this.monthlyTargetCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (monthlyTargetCents.present) {
      map['monthly_target_cents'] = Variable<int>(monthlyTargetCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTargetsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('category: $category, ')
          ..write('monthlyTargetCents: $monthlyTargetCents')
          ..write(')'))
        .toString();
  }
}

class $CategoryRulesTable extends CategoryRules
    with TableInfo<$CategoryRulesTable, CategoryRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RuleField, String> field =
      GeneratedColumn<String>(
        'field',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RuleField>($CategoryRulesTable.$converterfield);
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 128,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    field,
    pattern,
    category,
    priority,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      field: $CategoryRulesTable.$converterfield.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field'],
        )!,
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
    );
  }

  @override
  $CategoryRulesTable createAlias(String alias) {
    return $CategoryRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RuleField, String, String> $converterfield =
      const EnumNameConverter<RuleField>(RuleField.values);
}

class CategoryRule extends DataClass implements Insertable<CategoryRule> {
  final int id;
  final int profileId;
  final RuleField field;
  final String pattern;
  final String category;
  final int priority;
  const CategoryRule({
    required this.id,
    required this.profileId,
    required this.field,
    required this.pattern,
    required this.category,
    required this.priority,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    {
      map['field'] = Variable<String>(
        $CategoryRulesTable.$converterfield.toSql(field),
      );
    }
    map['pattern'] = Variable<String>(pattern);
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<int>(priority);
    return map;
  }

  CategoryRulesCompanion toCompanion(bool nullToAbsent) {
    return CategoryRulesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      field: Value(field),
      pattern: Value(pattern),
      category: Value(category),
      priority: Value(priority),
    );
  }

  factory CategoryRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRule(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      field: $CategoryRulesTable.$converterfield.fromJson(
        serializer.fromJson<String>(json['field']),
      ),
      pattern: serializer.fromJson<String>(json['pattern']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<int>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'field': serializer.toJson<String>(
        $CategoryRulesTable.$converterfield.toJson(field),
      ),
      'pattern': serializer.toJson<String>(pattern),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<int>(priority),
    };
  }

  CategoryRule copyWith({
    int? id,
    int? profileId,
    RuleField? field,
    String? pattern,
    String? category,
    int? priority,
  }) => CategoryRule(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    field: field ?? this.field,
    pattern: pattern ?? this.pattern,
    category: category ?? this.category,
    priority: priority ?? this.priority,
  );
  CategoryRule copyWithCompanion(CategoryRulesCompanion data) {
    return CategoryRule(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      field: data.field.present ? data.field.value : this.field,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRule(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('field: $field, ')
          ..write('pattern: $pattern, ')
          ..write('category: $category, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, field, pattern, category, priority);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRule &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.field == this.field &&
          other.pattern == this.pattern &&
          other.category == this.category &&
          other.priority == this.priority);
}

class CategoryRulesCompanion extends UpdateCompanion<CategoryRule> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<RuleField> field;
  final Value<String> pattern;
  final Value<String> category;
  final Value<int> priority;
  const CategoryRulesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.field = const Value.absent(),
    this.pattern = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
  });
  CategoryRulesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required RuleField field,
    required String pattern,
    required String category,
    this.priority = const Value.absent(),
  }) : profileId = Value(profileId),
       field = Value(field),
       pattern = Value(pattern),
       category = Value(category);
  static Insertable<CategoryRule> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? field,
    Expression<String>? pattern,
    Expression<String>? category,
    Expression<int>? priority,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (field != null) 'field': field,
      if (pattern != null) 'pattern': pattern,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
    });
  }

  CategoryRulesCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<RuleField>? field,
    Value<String>? pattern,
    Value<String>? category,
    Value<int>? priority,
  }) {
    return CategoryRulesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      field: field ?? this.field,
      pattern: pattern ?? this.pattern,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (field.present) {
      map['field'] = Variable<String>(
        $CategoryRulesTable.$converterfield.toSql(field.value),
      );
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRulesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('field: $field, ')
          ..write('pattern: $pattern, ')
          ..write('category: $category, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentAccountType, String>
  accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PaymentAccountType>($PaymentsTable.$converteraccountType);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<int> fromAccountId = GeneratedColumn<int>(
    'from_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    accountType,
    accountId,
    amountCents,
    date,
    note,
    fromAccountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      accountType: $PaymentsTable.$converteraccountType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}account_type'],
        )!,
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_account_id'],
      ),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentAccountType, String, String>
  $converteraccountType = const EnumNameConverter<PaymentAccountType>(
    PaymentAccountType.values,
  );
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int profileId;
  final PaymentAccountType accountType;

  /// Row id in CreditCards or Loans, depending on [accountType]. Not a
  /// foreign key because it points at one of two tables; cleanup is handled
  /// when a card or loan is deleted.
  final int accountId;
  final int amountCents;
  final DateTime date;
  final String? note;

  /// The bank or cash account this payment actually came from, when known.
  /// Optional — logging a payment still works without it, same as before;
  /// setting it also deducts the amount from that account's balance.
  final int? fromAccountId;
  const Payment({
    required this.id,
    required this.profileId,
    required this.accountType,
    required this.accountId,
    required this.amountCents,
    required this.date,
    this.note,
    this.fromAccountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    {
      map['account_type'] = Variable<String>(
        $PaymentsTable.$converteraccountType.toSql(accountType),
      );
    }
    map['account_id'] = Variable<int>(accountId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || fromAccountId != null) {
      map['from_account_id'] = Variable<int>(fromAccountId);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      accountType: Value(accountType),
      accountId: Value(accountId),
      amountCents: Value(amountCents),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      fromAccountId: fromAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAccountId),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      accountType: $PaymentsTable.$converteraccountType.fromJson(
        serializer.fromJson<String>(json['accountType']),
      ),
      accountId: serializer.fromJson<int>(json['accountId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      fromAccountId: serializer.fromJson<int?>(json['fromAccountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'accountType': serializer.toJson<String>(
        $PaymentsTable.$converteraccountType.toJson(accountType),
      ),
      'accountId': serializer.toJson<int>(accountId),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'fromAccountId': serializer.toJson<int?>(fromAccountId),
    };
  }

  Payment copyWith({
    int? id,
    int? profileId,
    PaymentAccountType? accountType,
    int? accountId,
    int? amountCents,
    DateTime? date,
    Value<String?> note = const Value.absent(),
    Value<int?> fromAccountId = const Value.absent(),
  }) => Payment(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    accountType: accountType ?? this.accountType,
    accountId: accountId ?? this.accountId,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    fromAccountId: fromAccountId.present
        ? fromAccountId.value
        : this.fromAccountId,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('accountType: $accountType, ')
          ..write('accountId: $accountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('fromAccountId: $fromAccountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    accountType,
    accountId,
    amountCents,
    date,
    note,
    fromAccountId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.accountType == this.accountType &&
          other.accountId == this.accountId &&
          other.amountCents == this.amountCents &&
          other.date == this.date &&
          other.note == this.note &&
          other.fromAccountId == this.fromAccountId);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<PaymentAccountType> accountType;
  final Value<int> accountId;
  final Value<int> amountCents;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<int?> fromAccountId;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.accountType = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.fromAccountId = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required PaymentAccountType accountType,
    required int accountId,
    required int amountCents,
    required DateTime date,
    this.note = const Value.absent(),
    this.fromAccountId = const Value.absent(),
  }) : profileId = Value(profileId),
       accountType = Value(accountType),
       accountId = Value(accountId),
       amountCents = Value(amountCents),
       date = Value(date);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? accountType,
    Expression<int>? accountId,
    Expression<int>? amountCents,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<int>? fromAccountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (accountType != null) 'account_type': accountType,
      if (accountId != null) 'account_id': accountId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<PaymentAccountType>? accountType,
    Value<int>? accountId,
    Value<int>? amountCents,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<int?>? fromAccountId,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      accountType: accountType ?? this.accountType,
      accountId: accountId ?? this.accountId,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      note: note ?? this.note,
      fromAccountId: fromAccountId ?? this.fromAccountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(
        $PaymentsTable.$converteraccountType.toSql(accountType.value),
      );
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<int>(fromAccountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('accountType: $accountType, ')
          ..write('accountId: $accountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('fromAccountId: $fromAccountId')
          ..write(')'))
        .toString();
  }
}

class $NetWorthSnapshotsTable extends NetWorthSnapshots
    with TableInfo<$NetWorthSnapshotsTable, NetWorthSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NetWorthSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAssetsCentsMeta = const VerificationMeta(
    'totalAssetsCents',
  );
  @override
  late final GeneratedColumn<int> totalAssetsCents = GeneratedColumn<int>(
    'total_assets_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDebtCentsMeta = const VerificationMeta(
    'totalDebtCents',
  );
  @override
  late final GeneratedColumn<int> totalDebtCents = GeneratedColumn<int>(
    'total_debt_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netWorthCentsMeta = const VerificationMeta(
    'netWorthCents',
  );
  @override
  late final GeneratedColumn<int> netWorthCents = GeneratedColumn<int>(
    'net_worth_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    date,
    totalAssetsCents,
    totalDebtCents,
    netWorthCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'net_worth_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<NetWorthSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_assets_cents')) {
      context.handle(
        _totalAssetsCentsMeta,
        totalAssetsCents.isAcceptableOrUnknown(
          data['total_assets_cents']!,
          _totalAssetsCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAssetsCentsMeta);
    }
    if (data.containsKey('total_debt_cents')) {
      context.handle(
        _totalDebtCentsMeta,
        totalDebtCents.isAcceptableOrUnknown(
          data['total_debt_cents']!,
          _totalDebtCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDebtCentsMeta);
    }
    if (data.containsKey('net_worth_cents')) {
      context.handle(
        _netWorthCentsMeta,
        netWorthCents.isAcceptableOrUnknown(
          data['net_worth_cents']!,
          _netWorthCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_netWorthCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, date},
  ];
  @override
  NetWorthSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NetWorthSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalAssetsCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_assets_cents'],
      )!,
      totalDebtCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_debt_cents'],
      )!,
      netWorthCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_worth_cents'],
      )!,
    );
  }

  @override
  $NetWorthSnapshotsTable createAlias(String alias) {
    return $NetWorthSnapshotsTable(attachedDatabase, alias);
  }
}

class NetWorthSnapshot extends DataClass
    implements Insertable<NetWorthSnapshot> {
  final int id;
  final int profileId;

  /// Midnight of the day being recorded — one snapshot per profile per day.
  final DateTime date;
  final int totalAssetsCents;
  final int totalDebtCents;
  final int netWorthCents;
  const NetWorthSnapshot({
    required this.id,
    required this.profileId,
    required this.date,
    required this.totalAssetsCents,
    required this.totalDebtCents,
    required this.netWorthCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['date'] = Variable<DateTime>(date);
    map['total_assets_cents'] = Variable<int>(totalAssetsCents);
    map['total_debt_cents'] = Variable<int>(totalDebtCents);
    map['net_worth_cents'] = Variable<int>(netWorthCents);
    return map;
  }

  NetWorthSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return NetWorthSnapshotsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      totalAssetsCents: Value(totalAssetsCents),
      totalDebtCents: Value(totalDebtCents),
      netWorthCents: Value(netWorthCents),
    );
  }

  factory NetWorthSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NetWorthSnapshot(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalAssetsCents: serializer.fromJson<int>(json['totalAssetsCents']),
      totalDebtCents: serializer.fromJson<int>(json['totalDebtCents']),
      netWorthCents: serializer.fromJson<int>(json['netWorthCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'date': serializer.toJson<DateTime>(date),
      'totalAssetsCents': serializer.toJson<int>(totalAssetsCents),
      'totalDebtCents': serializer.toJson<int>(totalDebtCents),
      'netWorthCents': serializer.toJson<int>(netWorthCents),
    };
  }

  NetWorthSnapshot copyWith({
    int? id,
    int? profileId,
    DateTime? date,
    int? totalAssetsCents,
    int? totalDebtCents,
    int? netWorthCents,
  }) => NetWorthSnapshot(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    date: date ?? this.date,
    totalAssetsCents: totalAssetsCents ?? this.totalAssetsCents,
    totalDebtCents: totalDebtCents ?? this.totalDebtCents,
    netWorthCents: netWorthCents ?? this.netWorthCents,
  );
  NetWorthSnapshot copyWithCompanion(NetWorthSnapshotsCompanion data) {
    return NetWorthSnapshot(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      totalAssetsCents: data.totalAssetsCents.present
          ? data.totalAssetsCents.value
          : this.totalAssetsCents,
      totalDebtCents: data.totalDebtCents.present
          ? data.totalDebtCents.value
          : this.totalDebtCents,
      netWorthCents: data.netWorthCents.present
          ? data.netWorthCents.value
          : this.netWorthCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NetWorthSnapshot(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('totalAssetsCents: $totalAssetsCents, ')
          ..write('totalDebtCents: $totalDebtCents, ')
          ..write('netWorthCents: $netWorthCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    date,
    totalAssetsCents,
    totalDebtCents,
    netWorthCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetWorthSnapshot &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.totalAssetsCents == this.totalAssetsCents &&
          other.totalDebtCents == this.totalDebtCents &&
          other.netWorthCents == this.netWorthCents);
}

class NetWorthSnapshotsCompanion extends UpdateCompanion<NetWorthSnapshot> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<DateTime> date;
  final Value<int> totalAssetsCents;
  final Value<int> totalDebtCents;
  final Value<int> netWorthCents;
  const NetWorthSnapshotsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalAssetsCents = const Value.absent(),
    this.totalDebtCents = const Value.absent(),
    this.netWorthCents = const Value.absent(),
  });
  NetWorthSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required DateTime date,
    required int totalAssetsCents,
    required int totalDebtCents,
    required int netWorthCents,
  }) : profileId = Value(profileId),
       date = Value(date),
       totalAssetsCents = Value(totalAssetsCents),
       totalDebtCents = Value(totalDebtCents),
       netWorthCents = Value(netWorthCents);
  static Insertable<NetWorthSnapshot> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<DateTime>? date,
    Expression<int>? totalAssetsCents,
    Expression<int>? totalDebtCents,
    Expression<int>? netWorthCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (totalAssetsCents != null) 'total_assets_cents': totalAssetsCents,
      if (totalDebtCents != null) 'total_debt_cents': totalDebtCents,
      if (netWorthCents != null) 'net_worth_cents': netWorthCents,
    });
  }

  NetWorthSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<DateTime>? date,
    Value<int>? totalAssetsCents,
    Value<int>? totalDebtCents,
    Value<int>? netWorthCents,
  }) {
    return NetWorthSnapshotsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      totalAssetsCents: totalAssetsCents ?? this.totalAssetsCents,
      totalDebtCents: totalDebtCents ?? this.totalDebtCents,
      netWorthCents: netWorthCents ?? this.netWorthCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalAssetsCents.present) {
      map['total_assets_cents'] = Variable<int>(totalAssetsCents.value);
    }
    if (totalDebtCents.present) {
      map['total_debt_cents'] = Variable<int>(totalDebtCents.value);
    }
    if (netWorthCents.present) {
      map['net_worth_cents'] = Variable<int>(netWorthCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetWorthSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('totalAssetsCents: $totalAssetsCents, ')
          ..write('totalDebtCents: $totalDebtCents, ')
          ..write('netWorthCents: $netWorthCents')
          ..write(')'))
        .toString();
  }
}

class $AccountBalanceSnapshotsTable extends AccountBalanceSnapshots
    with TableInfo<$AccountBalanceSnapshotsTable, AccountBalanceSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountBalanceSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    accountId,
    date,
    balanceCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_balance_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountBalanceSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountId, date},
  ];
  @override
  AccountBalanceSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountBalanceSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
    );
  }

  @override
  $AccountBalanceSnapshotsTable createAlias(String alias) {
    return $AccountBalanceSnapshotsTable(attachedDatabase, alias);
  }
}

class AccountBalanceSnapshot extends DataClass
    implements Insertable<AccountBalanceSnapshot> {
  final int id;
  final int profileId;
  final int accountId;
  final DateTime date;
  final int balanceCents;
  const AccountBalanceSnapshot({
    required this.id,
    required this.profileId,
    required this.accountId,
    required this.date,
    required this.balanceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['account_id'] = Variable<int>(accountId);
    map['date'] = Variable<DateTime>(date);
    map['balance_cents'] = Variable<int>(balanceCents);
    return map;
  }

  AccountBalanceSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return AccountBalanceSnapshotsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      accountId: Value(accountId),
      date: Value(date),
      balanceCents: Value(balanceCents),
    );
  }

  factory AccountBalanceSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountBalanceSnapshot(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      date: serializer.fromJson<DateTime>(json['date']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'accountId': serializer.toJson<int>(accountId),
      'date': serializer.toJson<DateTime>(date),
      'balanceCents': serializer.toJson<int>(balanceCents),
    };
  }

  AccountBalanceSnapshot copyWith({
    int? id,
    int? profileId,
    int? accountId,
    DateTime? date,
    int? balanceCents,
  }) => AccountBalanceSnapshot(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    accountId: accountId ?? this.accountId,
    date: date ?? this.date,
    balanceCents: balanceCents ?? this.balanceCents,
  );
  AccountBalanceSnapshot copyWithCompanion(
    AccountBalanceSnapshotsCompanion data,
  ) {
    return AccountBalanceSnapshot(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      date: data.date.present ? data.date.value : this.date,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountBalanceSnapshot(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('balanceCents: $balanceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, accountId, date, balanceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountBalanceSnapshot &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.accountId == this.accountId &&
          other.date == this.date &&
          other.balanceCents == this.balanceCents);
}

class AccountBalanceSnapshotsCompanion
    extends UpdateCompanion<AccountBalanceSnapshot> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> accountId;
  final Value<DateTime> date;
  final Value<int> balanceCents;
  const AccountBalanceSnapshotsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.date = const Value.absent(),
    this.balanceCents = const Value.absent(),
  });
  AccountBalanceSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int accountId,
    required DateTime date,
    required int balanceCents,
  }) : profileId = Value(profileId),
       accountId = Value(accountId),
       date = Value(date),
       balanceCents = Value(balanceCents);
  static Insertable<AccountBalanceSnapshot> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? accountId,
    Expression<DateTime>? date,
    Expression<int>? balanceCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (accountId != null) 'account_id': accountId,
      if (date != null) 'date': date,
      if (balanceCents != null) 'balance_cents': balanceCents,
    });
  }

  AccountBalanceSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? accountId,
    Value<DateTime>? date,
    Value<int>? balanceCents,
  }) {
    return AccountBalanceSnapshotsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      balanceCents: balanceCents ?? this.balanceCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountBalanceSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('balanceCents: $balanceCents')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GoalType>($GoalsTable.$convertertype);
  static const VerificationMeta _targetAmountCentsMeta = const VerificationMeta(
    'targetAmountCents',
  );
  @override
  late final GeneratedColumn<int> targetAmountCents = GeneratedColumn<int>(
    'target_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountCentsMeta =
      const VerificationMeta('currentAmountCents');
  @override
  late final GeneratedColumn<int> currentAmountCents = GeneratedColumn<int>(
    'current_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    type,
    targetAmountCents,
    currentAmountCents,
    targetDate,
    accountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount_cents')) {
      context.handle(
        _targetAmountCentsMeta,
        targetAmountCents.isAcceptableOrUnknown(
          data['target_amount_cents']!,
          _targetAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountCentsMeta);
    }
    if (data.containsKey('current_amount_cents')) {
      context.handle(
        _currentAmountCentsMeta,
        currentAmountCents.isAcceptableOrUnknown(
          data['current_amount_cents']!,
          _currentAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $GoalsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      targetAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount_cents'],
      )!,
      currentAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_amount_cents'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GoalType, String, String> $convertertype =
      const EnumNameConverter<GoalType>(GoalType.values);
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final int profileId;
  final String name;
  final GoalType type;
  final int targetAmountCents;
  final int currentAmountCents;
  final DateTime? targetDate;

  /// When set, progress is read live from this account's balance instead of
  /// the manually-entered [currentAmountCents] — e.g. a savings goal tied to
  /// the real account it's funded from, so it never drifts out of sync.
  final int? accountId;
  const Goal({
    required this.id,
    required this.profileId,
    required this.name,
    required this.type,
    required this.targetAmountCents,
    required this.currentAmountCents,
    this.targetDate,
    this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($GoalsTable.$convertertype.toSql(type));
    }
    map['target_amount_cents'] = Variable<int>(targetAmountCents);
    map['current_amount_cents'] = Variable<int>(currentAmountCents);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      type: Value(type),
      targetAmountCents: Value(targetAmountCents),
      currentAmountCents: Value(currentAmountCents),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      type: $GoalsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      targetAmountCents: serializer.fromJson<int>(json['targetAmountCents']),
      currentAmountCents: serializer.fromJson<int>(json['currentAmountCents']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      accountId: serializer.fromJson<int?>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $GoalsTable.$convertertype.toJson(type),
      ),
      'targetAmountCents': serializer.toJson<int>(targetAmountCents),
      'currentAmountCents': serializer.toJson<int>(currentAmountCents),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'accountId': serializer.toJson<int?>(accountId),
    };
  }

  Goal copyWith({
    int? id,
    int? profileId,
    String? name,
    GoalType? type,
    int? targetAmountCents,
    int? currentAmountCents,
    Value<DateTime?> targetDate = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
  }) => Goal(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    type: type ?? this.type,
    targetAmountCents: targetAmountCents ?? this.targetAmountCents,
    currentAmountCents: currentAmountCents ?? this.currentAmountCents,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    accountId: accountId.present ? accountId.value : this.accountId,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      targetAmountCents: data.targetAmountCents.present
          ? data.targetAmountCents.value
          : this.targetAmountCents,
      currentAmountCents: data.currentAmountCents.present
          ? data.currentAmountCents.value
          : this.currentAmountCents,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('currentAmountCents: $currentAmountCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    type,
    targetAmountCents,
    currentAmountCents,
    targetDate,
    accountId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.type == this.type &&
          other.targetAmountCents == this.targetAmountCents &&
          other.currentAmountCents == this.currentAmountCents &&
          other.targetDate == this.targetDate &&
          other.accountId == this.accountId);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<GoalType> type;
  final Value<int> targetAmountCents;
  final Value<int> currentAmountCents;
  final Value<DateTime?> targetDate;
  final Value<int?> accountId;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.targetAmountCents = const Value.absent(),
    this.currentAmountCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.accountId = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required GoalType type,
    required int targetAmountCents,
    this.currentAmountCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.accountId = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       type = Value(type),
       targetAmountCents = Value(targetAmountCents);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? targetAmountCents,
    Expression<int>? currentAmountCents,
    Expression<DateTime>? targetDate,
    Expression<int>? accountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (targetAmountCents != null) 'target_amount_cents': targetAmountCents,
      if (currentAmountCents != null)
        'current_amount_cents': currentAmountCents,
      if (targetDate != null) 'target_date': targetDate,
      if (accountId != null) 'account_id': accountId,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<GoalType>? type,
    Value<int>? targetAmountCents,
    Value<int>? currentAmountCents,
    Value<DateTime?>? targetDate,
    Value<int?>? accountId,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      type: type ?? this.type,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      currentAmountCents: currentAmountCents ?? this.currentAmountCents,
      targetDate: targetDate ?? this.targetDate,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $GoalsTable.$convertertype.toSql(type.value),
      );
    }
    if (targetAmountCents.present) {
      map['target_amount_cents'] = Variable<int>(targetAmountCents.value);
    }
    if (currentAmountCents.present) {
      map['current_amount_cents'] = Variable<int>(currentAmountCents.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('currentAmountCents: $currentAmountCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }
}

class $PaycheckAllocationsTable extends PaycheckAllocations
    with TableInfo<$PaycheckAllocationsTable, PaycheckAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaycheckAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _paycheckIdMeta = const VerificationMeta(
    'paycheckId',
  );
  @override
  late final GeneratedColumn<int> paycheckId = GeneratedColumn<int>(
    'paycheck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES paychecks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    paycheckId,
    target,
    amountCents,
    billId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paycheck_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaycheckAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('paycheck_id')) {
      context.handle(
        _paycheckIdMeta,
        paycheckId.isAcceptableOrUnknown(data['paycheck_id']!, _paycheckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paycheckIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaycheckAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaycheckAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      paycheckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paycheck_id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      ),
    );
  }

  @override
  $PaycheckAllocationsTable createAlias(String alias) {
    return $PaycheckAllocationsTable(attachedDatabase, alias);
  }
}

class PaycheckAllocation extends DataClass
    implements Insertable<PaycheckAllocation> {
  final int id;
  final int profileId;
  final int paycheckId;
  final String target;
  final int amountCents;
  final int? billId;
  const PaycheckAllocation({
    required this.id,
    required this.profileId,
    required this.paycheckId,
    required this.target,
    required this.amountCents,
    this.billId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['paycheck_id'] = Variable<int>(paycheckId);
    map['target'] = Variable<String>(target);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || billId != null) {
      map['bill_id'] = Variable<int>(billId);
    }
    return map;
  }

  PaycheckAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaycheckAllocationsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      paycheckId: Value(paycheckId),
      target: Value(target),
      amountCents: Value(amountCents),
      billId: billId == null && nullToAbsent
          ? const Value.absent()
          : Value(billId),
    );
  }

  factory PaycheckAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaycheckAllocation(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      paycheckId: serializer.fromJson<int>(json['paycheckId']),
      target: serializer.fromJson<String>(json['target']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      billId: serializer.fromJson<int?>(json['billId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'paycheckId': serializer.toJson<int>(paycheckId),
      'target': serializer.toJson<String>(target),
      'amountCents': serializer.toJson<int>(amountCents),
      'billId': serializer.toJson<int?>(billId),
    };
  }

  PaycheckAllocation copyWith({
    int? id,
    int? profileId,
    int? paycheckId,
    String? target,
    int? amountCents,
    Value<int?> billId = const Value.absent(),
  }) => PaycheckAllocation(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    paycheckId: paycheckId ?? this.paycheckId,
    target: target ?? this.target,
    amountCents: amountCents ?? this.amountCents,
    billId: billId.present ? billId.value : this.billId,
  );
  PaycheckAllocation copyWithCompanion(PaycheckAllocationsCompanion data) {
    return PaycheckAllocation(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      paycheckId: data.paycheckId.present
          ? data.paycheckId.value
          : this.paycheckId,
      target: data.target.present ? data.target.value : this.target,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      billId: data.billId.present ? data.billId.value : this.billId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaycheckAllocation(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('paycheckId: $paycheckId, ')
          ..write('target: $target, ')
          ..write('amountCents: $amountCents, ')
          ..write('billId: $billId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, paycheckId, target, amountCents, billId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaycheckAllocation &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.paycheckId == this.paycheckId &&
          other.target == this.target &&
          other.amountCents == this.amountCents &&
          other.billId == this.billId);
}

class PaycheckAllocationsCompanion extends UpdateCompanion<PaycheckAllocation> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> paycheckId;
  final Value<String> target;
  final Value<int> amountCents;
  final Value<int?> billId;
  const PaycheckAllocationsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.paycheckId = const Value.absent(),
    this.target = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.billId = const Value.absent(),
  });
  PaycheckAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int paycheckId,
    required String target,
    required int amountCents,
    this.billId = const Value.absent(),
  }) : profileId = Value(profileId),
       paycheckId = Value(paycheckId),
       target = Value(target),
       amountCents = Value(amountCents);
  static Insertable<PaycheckAllocation> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? paycheckId,
    Expression<String>? target,
    Expression<int>? amountCents,
    Expression<int>? billId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (paycheckId != null) 'paycheck_id': paycheckId,
      if (target != null) 'target': target,
      if (amountCents != null) 'amount_cents': amountCents,
      if (billId != null) 'bill_id': billId,
    });
  }

  PaycheckAllocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? paycheckId,
    Value<String>? target,
    Value<int>? amountCents,
    Value<int?>? billId,
  }) {
    return PaycheckAllocationsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      paycheckId: paycheckId ?? this.paycheckId,
      target: target ?? this.target,
      amountCents: amountCents ?? this.amountCents,
      billId: billId ?? this.billId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (paycheckId.present) {
      map['paycheck_id'] = Variable<int>(paycheckId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaycheckAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('paycheckId: $paycheckId, ')
          ..write('target: $target, ')
          ..write('amountCents: $amountCents, ')
          ..write('billId: $billId')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, profileId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, name},
  ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final int profileId;
  final String name;
  const Tag({required this.id, required this.profileId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({int? id, int? profileId, String? name}) => Tag(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
  }) : profileId = Value(profileId),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $BudgetEntryTagsTable extends BudgetEntryTags
    with TableInfo<$BudgetEntryTagsTable, BudgetEntryTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetEntryTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budget_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_entry_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetEntryTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entryId, tagId},
  ];
  @override
  BudgetEntryTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntryTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $BudgetEntryTagsTable createAlias(String alias) {
    return $BudgetEntryTagsTable(attachedDatabase, alias);
  }
}

class BudgetEntryTag extends DataClass implements Insertable<BudgetEntryTag> {
  final int id;
  final int entryId;
  final int tagId;
  const BudgetEntryTag({
    required this.id,
    required this.entryId,
    required this.tagId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entry_id'] = Variable<int>(entryId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  BudgetEntryTagsCompanion toCompanion(bool nullToAbsent) {
    return BudgetEntryTagsCompanion(
      id: Value(id),
      entryId: Value(entryId),
      tagId: Value(tagId),
    );
  }

  factory BudgetEntryTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntryTag(
      id: serializer.fromJson<int>(json['id']),
      entryId: serializer.fromJson<int>(json['entryId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entryId': serializer.toJson<int>(entryId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  BudgetEntryTag copyWith({int? id, int? entryId, int? tagId}) =>
      BudgetEntryTag(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        tagId: tagId ?? this.tagId,
      );
  BudgetEntryTag copyWithCompanion(BudgetEntryTagsCompanion data) {
    return BudgetEntryTag(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntryTag(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entryId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntryTag &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.tagId == this.tagId);
}

class BudgetEntryTagsCompanion extends UpdateCompanion<BudgetEntryTag> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<int> tagId;
  const BudgetEntryTagsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.tagId = const Value.absent(),
  });
  BudgetEntryTagsCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required int tagId,
  }) : entryId = Value(entryId),
       tagId = Value(tagId);
  static Insertable<BudgetEntryTag> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<int>? tagId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (tagId != null) 'tag_id': tagId,
    });
  }

  BudgetEntryTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<int>? tagId,
  }) {
    return BudgetEntryTagsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      tagId: tagId ?? this.tagId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntryTagsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransfersTable extends RecurringTransfers
    with TableInfo<$RecurringTransfersTable, RecurringTransfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<int> fromAccountId = GeneratedColumn<int>(
    'from_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
    'to_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayFrequency, String> frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PayFrequency>(
        $RecurringTransfersTable.$converterfrequency,
      );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<DateTime> anchorDate = GeneratedColumn<DateTime>(
    'anchor_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    fromAccountId,
    toAccountId,
    amountCents,
    frequency,
    anchorDate,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringTransfer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromAccountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toAccountIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDateMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransfer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_account_id'],
      )!,
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_account_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      frequency: $RecurringTransfersTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}anchor_date'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $RecurringTransfersTable createAlias(String alias) {
    return $RecurringTransfersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PayFrequency, String, String> $converterfrequency =
      const EnumNameConverter<PayFrequency>(PayFrequency.values);
}

class RecurringTransfer extends DataClass
    implements Insertable<RecurringTransfer> {
  final int id;
  final int profileId;
  final String name;
  final int fromAccountId;
  final int toAccountId;
  final int amountCents;
  final PayFrequency frequency;
  final DateTime anchorDate;
  final bool active;
  const RecurringTransfer({
    required this.id,
    required this.profileId,
    required this.name,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amountCents,
    required this.frequency,
    required this.anchorDate,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    map['from_account_id'] = Variable<int>(fromAccountId);
    map['to_account_id'] = Variable<int>(toAccountId);
    map['amount_cents'] = Variable<int>(amountCents);
    {
      map['frequency'] = Variable<String>(
        $RecurringTransfersTable.$converterfrequency.toSql(frequency),
      );
    }
    map['anchor_date'] = Variable<DateTime>(anchorDate);
    map['active'] = Variable<bool>(active);
    return map;
  }

  RecurringTransfersCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransfersCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      fromAccountId: Value(fromAccountId),
      toAccountId: Value(toAccountId),
      amountCents: Value(amountCents),
      frequency: Value(frequency),
      anchorDate: Value(anchorDate),
      active: Value(active),
    );
  }

  factory RecurringTransfer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransfer(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      fromAccountId: serializer.fromJson<int>(json['fromAccountId']),
      toAccountId: serializer.fromJson<int>(json['toAccountId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      frequency: $RecurringTransfersTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      anchorDate: serializer.fromJson<DateTime>(json['anchorDate']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'fromAccountId': serializer.toJson<int>(fromAccountId),
      'toAccountId': serializer.toJson<int>(toAccountId),
      'amountCents': serializer.toJson<int>(amountCents),
      'frequency': serializer.toJson<String>(
        $RecurringTransfersTable.$converterfrequency.toJson(frequency),
      ),
      'anchorDate': serializer.toJson<DateTime>(anchorDate),
      'active': serializer.toJson<bool>(active),
    };
  }

  RecurringTransfer copyWith({
    int? id,
    int? profileId,
    String? name,
    int? fromAccountId,
    int? toAccountId,
    int? amountCents,
    PayFrequency? frequency,
    DateTime? anchorDate,
    bool? active,
  }) => RecurringTransfer(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    fromAccountId: fromAccountId ?? this.fromAccountId,
    toAccountId: toAccountId ?? this.toAccountId,
    amountCents: amountCents ?? this.amountCents,
    frequency: frequency ?? this.frequency,
    anchorDate: anchorDate ?? this.anchorDate,
    active: active ?? this.active,
  );
  RecurringTransfer copyWithCompanion(RecurringTransfersCompanion data) {
    return RecurringTransfer(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransfer(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    name,
    fromAccountId,
    toAccountId,
    amountCents,
    frequency,
    anchorDate,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransfer &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.amountCents == this.amountCents &&
          other.frequency == this.frequency &&
          other.anchorDate == this.anchorDate &&
          other.active == this.active);
}

class RecurringTransfersCompanion extends UpdateCompanion<RecurringTransfer> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<int> fromAccountId;
  final Value<int> toAccountId;
  final Value<int> amountCents;
  final Value<PayFrequency> frequency;
  final Value<DateTime> anchorDate;
  final Value<bool> active;
  const RecurringTransfersCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.frequency = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.active = const Value.absent(),
  });
  RecurringTransfersCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required int fromAccountId,
    required int toAccountId,
    required int amountCents,
    required PayFrequency frequency,
    required DateTime anchorDate,
    this.active = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       fromAccountId = Value(fromAccountId),
       toAccountId = Value(toAccountId),
       amountCents = Value(amountCents),
       frequency = Value(frequency),
       anchorDate = Value(anchorDate);
  static Insertable<RecurringTransfer> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<int>? fromAccountId,
    Expression<int>? toAccountId,
    Expression<int>? amountCents,
    Expression<String>? frequency,
    Expression<DateTime>? anchorDate,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (frequency != null) 'frequency': frequency,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (active != null) 'active': active,
    });
  }

  RecurringTransfersCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<int>? fromAccountId,
    Value<int>? toAccountId,
    Value<int>? amountCents,
    Value<PayFrequency>? frequency,
    Value<DateTime>? anchorDate,
    Value<bool>? active,
  }) {
    return RecurringTransfersCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amountCents: amountCents ?? this.amountCents,
      frequency: frequency ?? this.frequency,
      anchorDate: anchorDate ?? this.anchorDate,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<int>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $RecurringTransfersTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<DateTime>(anchorDate.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransfersCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $TransferLogsTable extends TransferLogs
    with TableInfo<$TransferLogsTable, TransferLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _transferIdMeta = const VerificationMeta(
    'transferId',
  );
  @override
  late final GeneratedColumn<int> transferId = GeneratedColumn<int>(
    'transfer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurring_transfers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    transferId,
    date,
    amountCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
        _transferIdMeta,
        transferId.isAcceptableOrUnknown(data['transfer_id']!, _transferIdMeta),
      );
    } else if (isInserting) {
      context.missing(_transferIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {transferId, date},
  ];
  @override
  TransferLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      transferId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transfer_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
    );
  }

  @override
  $TransferLogsTable createAlias(String alias) {
    return $TransferLogsTable(attachedDatabase, alias);
  }
}

class TransferLog extends DataClass implements Insertable<TransferLog> {
  final int id;
  final int profileId;
  final int transferId;
  final DateTime date;
  final int amountCents;
  const TransferLog({
    required this.id,
    required this.profileId,
    required this.transferId,
    required this.date,
    required this.amountCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['transfer_id'] = Variable<int>(transferId);
    map['date'] = Variable<DateTime>(date);
    map['amount_cents'] = Variable<int>(amountCents);
    return map;
  }

  TransferLogsCompanion toCompanion(bool nullToAbsent) {
    return TransferLogsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      transferId: Value(transferId),
      date: Value(date),
      amountCents: Value(amountCents),
    );
  }

  factory TransferLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferLog(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      transferId: serializer.fromJson<int>(json['transferId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'transferId': serializer.toJson<int>(transferId),
      'date': serializer.toJson<DateTime>(date),
      'amountCents': serializer.toJson<int>(amountCents),
    };
  }

  TransferLog copyWith({
    int? id,
    int? profileId,
    int? transferId,
    DateTime? date,
    int? amountCents,
  }) => TransferLog(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    transferId: transferId ?? this.transferId,
    date: date ?? this.date,
    amountCents: amountCents ?? this.amountCents,
  );
  TransferLog copyWithCompanion(TransferLogsCompanion data) {
    return TransferLog(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      transferId: data.transferId.present
          ? data.transferId.value
          : this.transferId,
      date: data.date.present ? data.date.value : this.date,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferLog(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('transferId: $transferId, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, transferId, date, amountCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferLog &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.transferId == this.transferId &&
          other.date == this.date &&
          other.amountCents == this.amountCents);
}

class TransferLogsCompanion extends UpdateCompanion<TransferLog> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> transferId;
  final Value<DateTime> date;
  final Value<int> amountCents;
  const TransferLogsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.transferId = const Value.absent(),
    this.date = const Value.absent(),
    this.amountCents = const Value.absent(),
  });
  TransferLogsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int transferId,
    required DateTime date,
    required int amountCents,
  }) : profileId = Value(profileId),
       transferId = Value(transferId),
       date = Value(date),
       amountCents = Value(amountCents);
  static Insertable<TransferLog> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? transferId,
    Expression<DateTime>? date,
    Expression<int>? amountCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (transferId != null) 'transfer_id': transferId,
      if (date != null) 'date': date,
      if (amountCents != null) 'amount_cents': amountCents,
    });
  }

  TransferLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? transferId,
    Value<DateTime>? date,
    Value<int>? amountCents,
  }) {
    return TransferLogsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      transferId: transferId ?? this.transferId,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<int>(transferId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferLogsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('transferId: $transferId, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }
}

class $TransactionSplitsTable extends TransactionSplits
    with TableInfo<$TransactionSplitsTable, TransactionSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budget_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    entryId,
    category,
    amountCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSplit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSplit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
    );
  }

  @override
  $TransactionSplitsTable createAlias(String alias) {
    return $TransactionSplitsTable(attachedDatabase, alias);
  }
}

class TransactionSplit extends DataClass
    implements Insertable<TransactionSplit> {
  final int id;
  final int profileId;
  final int entryId;
  final String category;
  final int amountCents;
  const TransactionSplit({
    required this.id,
    required this.profileId,
    required this.entryId,
    required this.category,
    required this.amountCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['entry_id'] = Variable<int>(entryId);
    map['category'] = Variable<String>(category);
    map['amount_cents'] = Variable<int>(amountCents);
    return map;
  }

  TransactionSplitsCompanion toCompanion(bool nullToAbsent) {
    return TransactionSplitsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      entryId: Value(entryId),
      category: Value(category),
      amountCents: Value(amountCents),
    );
  }

  factory TransactionSplit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSplit(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      entryId: serializer.fromJson<int>(json['entryId']),
      category: serializer.fromJson<String>(json['category']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'entryId': serializer.toJson<int>(entryId),
      'category': serializer.toJson<String>(category),
      'amountCents': serializer.toJson<int>(amountCents),
    };
  }

  TransactionSplit copyWith({
    int? id,
    int? profileId,
    int? entryId,
    String? category,
    int? amountCents,
  }) => TransactionSplit(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    entryId: entryId ?? this.entryId,
    category: category ?? this.category,
    amountCents: amountCents ?? this.amountCents,
  );
  TransactionSplit copyWithCompanion(TransactionSplitsCompanion data) {
    return TransactionSplit(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      category: data.category.present ? data.category.value : this.category,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSplit(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('entryId: $entryId, ')
          ..write('category: $category, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, entryId, category, amountCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSplit &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.entryId == this.entryId &&
          other.category == this.category &&
          other.amountCents == this.amountCents);
}

class TransactionSplitsCompanion extends UpdateCompanion<TransactionSplit> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> entryId;
  final Value<String> category;
  final Value<int> amountCents;
  const TransactionSplitsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.category = const Value.absent(),
    this.amountCents = const Value.absent(),
  });
  TransactionSplitsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int entryId,
    required String category,
    required int amountCents,
  }) : profileId = Value(profileId),
       entryId = Value(entryId),
       category = Value(category),
       amountCents = Value(amountCents);
  static Insertable<TransactionSplit> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? entryId,
    Expression<String>? category,
    Expression<int>? amountCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (entryId != null) 'entry_id': entryId,
      if (category != null) 'category': category,
      if (amountCents != null) 'amount_cents': amountCents,
    });
  }

  TransactionSplitsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? entryId,
    Value<String>? category,
    Value<int>? amountCents,
  }) {
    return TransactionSplitsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      entryId: entryId ?? this.entryId,
      category: category ?? this.category,
      amountCents: amountCents ?? this.amountCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSplitsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('entryId: $entryId, ')
          ..write('category: $category, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $BillPaymentsTable billPayments = $BillPaymentsTable(this);
  late final $CreditScoreSnapshotsTable creditScoreSnapshots =
      $CreditScoreSnapshotsTable(this);
  late final $PaycheckSchedulesTable paycheckSchedules =
      $PaycheckSchedulesTable(this);
  late final $PaychecksTable paychecks = $PaychecksTable(this);
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $BudgetEntriesTable budgetEntries = $BudgetEntriesTable(this);
  late final $BudgetTargetsTable budgetTargets = $BudgetTargetsTable(this);
  late final $CategoryRulesTable categoryRules = $CategoryRulesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $NetWorthSnapshotsTable netWorthSnapshots =
      $NetWorthSnapshotsTable(this);
  late final $AccountBalanceSnapshotsTable accountBalanceSnapshots =
      $AccountBalanceSnapshotsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $PaycheckAllocationsTable paycheckAllocations =
      $PaycheckAllocationsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $BudgetEntryTagsTable budgetEntryTags = $BudgetEntryTagsTable(
    this,
  );
  late final $RecurringTransfersTable recurringTransfers =
      $RecurringTransfersTable(this);
  late final $TransferLogsTable transferLogs = $TransferLogsTable(this);
  late final $TransactionSplitsTable transactionSplits =
      $TransactionSplitsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    accounts,
    creditCards,
    loans,
    bills,
    billPayments,
    creditScoreSnapshots,
    paycheckSchedules,
    paychecks,
    importBatches,
    budgetEntries,
    budgetTargets,
    categoryRules,
    payments,
    netWorthSnapshots,
    accountBalanceSnapshots,
    goals,
    paycheckAllocations,
    tags,
    budgetEntryTags,
    recurringTransfers,
    transferLogs,
    transactionSplits,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bills',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bill_payments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'paychecks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bill_payments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('account_balance_snapshots', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'paychecks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('paycheck_allocations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'budget_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entry_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_entry_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurring_transfers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurring_transfers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recurring_transfers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transfer_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'budget_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transaction_splits', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> pinHash,
  Value<bool> isAdmin,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> pinHash,
  Value<bool> isAdmin,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'profiles__id__accounts__profile_id',
  );

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreditCardsTable, List<CreditCard>>
  _creditCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creditCards,
    aliasName: 'profiles__id__credit_cards__profile_id',
  );

  $$CreditCardsTableProcessedTableManager get creditCardsRefs {
    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creditCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoansTable, List<Loan>> _loansRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.loans,
    aliasName: 'profiles__id__loans__profile_id',
  );

  $$LoansTableProcessedTableManager get loansRefs {
    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BillsTable, List<Bill>> _billsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bills,
    aliasName: 'profiles__id__bills__profile_id',
  );

  $$BillsTableProcessedTableManager get billsRefs {
    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BillPaymentsTable, List<BillPayment>>
  _billPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billPayments,
    aliasName: 'profiles__id__bill_payments__profile_id',
  );

  $$BillPaymentsTableProcessedTableManager get billPaymentsRefs {
    final manager = $$BillPaymentsTableTableManager(
      $_db,
      $_db.billPayments,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CreditScoreSnapshotsTable,
    List<CreditScoreSnapshot>
  >
  _creditScoreSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creditScoreSnapshots,
        aliasName: 'profiles__id__credit_score_snapshots__profile_id',
      );

  $$CreditScoreSnapshotsTableProcessedTableManager
  get creditScoreSnapshotsRefs {
    final manager = $$CreditScoreSnapshotsTableTableManager(
      $_db,
      $_db.creditScoreSnapshots,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creditScoreSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaycheckSchedulesTable, List<PaycheckSchedule>>
  _paycheckSchedulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paycheckSchedules,
        aliasName: 'profiles__id__paycheck_schedules__profile_id',
      );

  $$PaycheckSchedulesTableProcessedTableManager get paycheckSchedulesRefs {
    final manager = $$PaycheckSchedulesTableTableManager(
      $_db,
      $_db.paycheckSchedules,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paycheckSchedulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaychecksTable, List<Paycheck>>
  _paychecksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paychecks,
    aliasName: 'profiles__id__paychecks__profile_id',
  );

  $$PaychecksTableProcessedTableManager get paychecksRefs {
    final manager = $$PaychecksTableTableManager(
      $_db,
      $_db.paychecks,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paychecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImportBatchesTable, List<ImportBatch>>
  _importBatchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.importBatches,
    aliasName: 'profiles__id__import_batches__profile_id',
  );

  $$ImportBatchesTableProcessedTableManager get importBatchesRefs {
    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_importBatchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'profiles__id__budget_entries__profile_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetTargetsTable, List<BudgetTarget>>
  _budgetTargetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetTargets,
    aliasName: 'profiles__id__budget_targets__profile_id',
  );

  $$BudgetTargetsTableProcessedTableManager get budgetTargetsRefs {
    final manager = $$BudgetTargetsTableTableManager(
      $_db,
      $_db.budgetTargets,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetTargetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CategoryRulesTable, List<CategoryRule>>
  _categoryRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categoryRules,
    aliasName: 'profiles__id__category_rules__profile_id',
  );

  $$CategoryRulesTableProcessedTableManager get categoryRulesRefs {
    final manager = $$CategoryRulesTableTableManager(
      $_db,
      $_db.categoryRules,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoryRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'profiles__id__payments__profile_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NetWorthSnapshotsTable, List<NetWorthSnapshot>>
  _netWorthSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.netWorthSnapshots,
        aliasName: 'profiles__id__net_worth_snapshots__profile_id',
      );

  $$NetWorthSnapshotsTableProcessedTableManager get netWorthSnapshotsRefs {
    final manager = $$NetWorthSnapshotsTableTableManager(
      $_db,
      $_db.netWorthSnapshots,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _netWorthSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AccountBalanceSnapshotsTable,
    List<AccountBalanceSnapshot>
  >
  _accountBalanceSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.accountBalanceSnapshots,
        aliasName: 'profiles__id__account_balance_snapshots__profile_id',
      );

  $$AccountBalanceSnapshotsTableProcessedTableManager
  get accountBalanceSnapshotsRefs {
    final manager = $$AccountBalanceSnapshotsTableTableManager(
      $_db,
      $_db.accountBalanceSnapshots,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accountBalanceSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goals,
    aliasName: 'profiles__id__goals__profile_id',
  );

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PaycheckAllocationsTable,
    List<PaycheckAllocation>
  >
  _paycheckAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paycheckAllocations,
        aliasName: 'profiles__id__paycheck_allocations__profile_id',
      );

  $$PaycheckAllocationsTableProcessedTableManager get paycheckAllocationsRefs {
    final manager = $$PaycheckAllocationsTableTableManager(
      $_db,
      $_db.paycheckAllocations,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paycheckAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TagsTable, List<Tag>> _tagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tags,
    aliasName: 'profiles__id__tags__profile_id',
  );

  $$TagsTableProcessedTableManager get tagsRefs {
    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringTransfersTable, List<RecurringTransfer>>
  _recurringTransfersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringTransfers,
        aliasName: 'profiles__id__recurring_transfers__profile_id',
      );

  $$RecurringTransfersTableProcessedTableManager get recurringTransfersRefs {
    final manager = $$RecurringTransfersTableTableManager(
      $_db,
      $_db.recurringTransfers,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringTransfersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransferLogsTable, List<TransferLog>>
  _transferLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transferLogs,
    aliasName: 'profiles__id__transfer_logs__profile_id',
  );

  $$TransferLogsTableProcessedTableManager get transferLogsRefs {
    final manager = $$TransferLogsTableTableManager(
      $_db,
      $_db.transferLogs,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transferLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionSplitsTable, List<TransactionSplit>>
  _transactionSplitsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionSplits,
        aliasName: 'profiles__id__transaction_splits__profile_id',
      );

  $$TransactionSplitsTableProcessedTableManager get transactionSplitsRefs {
    final manager = $$TransactionSplitsTableTableManager(
      $_db,
      $_db.transactionSplits,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionSplitsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> accountsRefs(
    Expression<bool> Function($$AccountsTableFilterComposer f) f,
  ) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creditCardsRefs(
    Expression<bool> Function($$CreditCardsTableFilterComposer f) f,
  ) {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loansRefs(
    Expression<bool> Function($$LoansTableFilterComposer f) f,
  ) {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> billsRefs(
    Expression<bool> Function($$BillsTableFilterComposer f) f,
  ) {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> billPaymentsRefs(
    Expression<bool> Function($$BillPaymentsTableFilterComposer f) f,
  ) {
    final $$BillPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creditScoreSnapshotsRefs(
    Expression<bool> Function($$CreditScoreSnapshotsTableFilterComposer f) f,
  ) {
    final $$CreditScoreSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditScoreSnapshots,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditScoreSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.creditScoreSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paycheckSchedulesRefs(
    Expression<bool> Function($$PaycheckSchedulesTableFilterComposer f) f,
  ) {
    final $$PaycheckSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paycheckSchedules,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaycheckSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.paycheckSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paychecksRefs(
    Expression<bool> Function($$PaychecksTableFilterComposer f) f,
  ) {
    final $$PaychecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableFilterComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> importBatchesRefs(
    Expression<bool> Function($$ImportBatchesTableFilterComposer f) f,
  ) {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetTargetsRefs(
    Expression<bool> Function($$BudgetTargetsTableFilterComposer f) f,
  ) {
    final $$BudgetTargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetTargets,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetTargetsTableFilterComposer(
            $db: $db,
            $table: $db.budgetTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> categoryRulesRefs(
    Expression<bool> Function($$CategoryRulesTableFilterComposer f) f,
  ) {
    final $$CategoryRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableFilterComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> netWorthSnapshotsRefs(
    Expression<bool> Function($$NetWorthSnapshotsTableFilterComposer f) f,
  ) {
    final $$NetWorthSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.netWorthSnapshots,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetWorthSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.netWorthSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountBalanceSnapshotsRefs(
    Expression<bool> Function($$AccountBalanceSnapshotsTableFilterComposer f) f,
  ) {
    final $$AccountBalanceSnapshotsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accountBalanceSnapshots,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccountBalanceSnapshotsTableFilterComposer(
                $db: $db,
                $table: $db.accountBalanceSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> goalsRefs(
    Expression<bool> Function($$GoalsTableFilterComposer f) f,
  ) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paycheckAllocationsRefs(
    Expression<bool> Function($$PaycheckAllocationsTableFilterComposer f) f,
  ) {
    final $$PaycheckAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paycheckAllocations,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaycheckAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paycheckAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tagsRefs(
    Expression<bool> Function($$TagsTableFilterComposer f) f,
  ) {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringTransfersRefs(
    Expression<bool> Function($$RecurringTransfersTableFilterComposer f) f,
  ) {
    final $$RecurringTransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringTransfers,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringTransfersTableFilterComposer(
            $db: $db,
            $table: $db.recurringTransfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transferLogsRefs(
    Expression<bool> Function($$TransferLogsTableFilterComposer f) f,
  ) {
    final $$TransferLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transferLogs,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransferLogsTableFilterComposer(
            $db: $db,
            $table: $db.transferLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionSplitsRefs(
    Expression<bool> Function($$TransactionSplitsTableFilterComposer f) f,
  ) {
    final $$TransactionSplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionSplits,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionSplitsTableFilterComposer(
            $db: $db,
            $table: $db.transactionSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<bool> get isAdmin =>
      $composableBuilder(column: $table.isAdmin, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($$AccountsTableAnnotationComposer a) f,
  ) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creditCardsRefs<T extends Object>(
    Expression<T> Function($$CreditCardsTableAnnotationComposer a) f,
  ) {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loansRefs<T extends Object>(
    Expression<T> Function($$LoansTableAnnotationComposer a) f,
  ) {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> billsRefs<T extends Object>(
    Expression<T> Function($$BillsTableAnnotationComposer a) f,
  ) {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> billPaymentsRefs<T extends Object>(
    Expression<T> Function($$BillPaymentsTableAnnotationComposer a) f,
  ) {
    final $$BillPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creditScoreSnapshotsRefs<T extends Object>(
    Expression<T> Function($$CreditScoreSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$CreditScoreSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creditScoreSnapshots,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreditScoreSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.creditScoreSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> paycheckSchedulesRefs<T extends Object>(
    Expression<T> Function($$PaycheckSchedulesTableAnnotationComposer a) f,
  ) {
    final $$PaycheckSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paycheckSchedules,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaycheckSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.paycheckSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> paychecksRefs<T extends Object>(
    Expression<T> Function($$PaychecksTableAnnotationComposer a) f,
  ) {
    final $$PaychecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableAnnotationComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> importBatchesRefs<T extends Object>(
    Expression<T> Function($$ImportBatchesTableAnnotationComposer a) f,
  ) {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetTargetsRefs<T extends Object>(
    Expression<T> Function($$BudgetTargetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetTargetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetTargets,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetTargetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> categoryRulesRefs<T extends Object>(
    Expression<T> Function($$CategoryRulesTableAnnotationComposer a) f,
  ) {
    final $$CategoryRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> netWorthSnapshotsRefs<T extends Object>(
    Expression<T> Function($$NetWorthSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$NetWorthSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.netWorthSnapshots,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NetWorthSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.netWorthSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> accountBalanceSnapshotsRefs<T extends Object>(
    Expression<T> Function($$AccountBalanceSnapshotsTableAnnotationComposer a)
    f,
  ) {
    final $$AccountBalanceSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accountBalanceSnapshots,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccountBalanceSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.accountBalanceSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
    Expression<T> Function($$GoalsTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paycheckAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaycheckAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaycheckAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paycheckAllocations,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaycheckAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paycheckAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> tagsRefs<T extends Object>(
    Expression<T> Function($$TagsTableAnnotationComposer a) f,
  ) {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringTransfersRefs<T extends Object>(
    Expression<T> Function($$RecurringTransfersTableAnnotationComposer a) f,
  ) {
    final $$RecurringTransfersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransfers,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransfersTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringTransfers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> transferLogsRefs<T extends Object>(
    Expression<T> Function($$TransferLogsTableAnnotationComposer a) f,
  ) {
    final $$TransferLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transferLogs,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransferLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.transferLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionSplitsRefs<T extends Object>(
    Expression<T> Function($$TransactionSplitsTableAnnotationComposer a) f,
  ) {
    final $$TransactionSplitsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionSplits,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionSplitsTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionSplits,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, $$ProfilesTableReferences),
          Profile,
          PrefetchHooks Function({
            bool accountsRefs,
            bool creditCardsRefs,
            bool loansRefs,
            bool billsRefs,
            bool billPaymentsRefs,
            bool creditScoreSnapshotsRefs,
            bool paycheckSchedulesRefs,
            bool paychecksRefs,
            bool importBatchesRefs,
            bool budgetEntriesRefs,
            bool budgetTargetsRefs,
            bool categoryRulesRefs,
            bool paymentsRefs,
            bool netWorthSnapshotsRefs,
            bool accountBalanceSnapshotsRefs,
            bool goalsRefs,
            bool paycheckAllocationsRefs,
            bool tagsRefs,
            bool recurringTransfersRefs,
            bool transferLogsRefs,
            bool transactionSplitsRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                pinHash: pinHash,
                isAdmin: isAdmin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> pinHash = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                pinHash: pinHash,
                isAdmin: isAdmin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountsRefs = false,
                creditCardsRefs = false,
                loansRefs = false,
                billsRefs = false,
                billPaymentsRefs = false,
                creditScoreSnapshotsRefs = false,
                paycheckSchedulesRefs = false,
                paychecksRefs = false,
                importBatchesRefs = false,
                budgetEntriesRefs = false,
                budgetTargetsRefs = false,
                categoryRulesRefs = false,
                paymentsRefs = false,
                netWorthSnapshotsRefs = false,
                accountBalanceSnapshotsRefs = false,
                goalsRefs = false,
                paycheckAllocationsRefs = false,
                tagsRefs = false,
                recurringTransfersRefs = false,
                transferLogsRefs = false,
                transactionSplitsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (accountsRefs) db.accounts,
                    if (creditCardsRefs) db.creditCards,
                    if (loansRefs) db.loans,
                    if (billsRefs) db.bills,
                    if (billPaymentsRefs) db.billPayments,
                    if (creditScoreSnapshotsRefs) db.creditScoreSnapshots,
                    if (paycheckSchedulesRefs) db.paycheckSchedules,
                    if (paychecksRefs) db.paychecks,
                    if (importBatchesRefs) db.importBatches,
                    if (budgetEntriesRefs) db.budgetEntries,
                    if (budgetTargetsRefs) db.budgetTargets,
                    if (categoryRulesRefs) db.categoryRules,
                    if (paymentsRefs) db.payments,
                    if (netWorthSnapshotsRefs) db.netWorthSnapshots,
                    if (accountBalanceSnapshotsRefs) db.accountBalanceSnapshots,
                    if (goalsRefs) db.goals,
                    if (paycheckAllocationsRefs) db.paycheckAllocations,
                    if (tagsRefs) db.tags,
                    if (recurringTransfersRefs) db.recurringTransfers,
                    if (transferLogsRefs) db.transferLogs,
                    if (transactionSplitsRefs) db.transactionSplits,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (accountsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          Account
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._accountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).accountsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creditCardsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          CreditCard
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._creditCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).creditCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loansRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          Loan
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._loansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).loansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (billsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          Bill
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._billsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).billsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (billPaymentsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          BillPayment
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._billPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).billPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creditScoreSnapshotsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          CreditScoreSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._creditScoreSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).creditScoreSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paycheckSchedulesRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          PaycheckSchedule
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._paycheckSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).paycheckSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paychecksRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          Paycheck
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._paychecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).paychecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (importBatchesRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          ImportBatch
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._importBatchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).importBatchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetTargetsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          BudgetTarget
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._budgetTargetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetTargetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (categoryRulesRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          CategoryRule
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._categoryRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (netWorthSnapshotsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          NetWorthSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._netWorthSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).netWorthSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (accountBalanceSnapshotsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          AccountBalanceSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._accountBalanceSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).accountBalanceSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          Goal
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._goalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).goalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paycheckAllocationsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          PaycheckAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._paycheckAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).paycheckAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tagsRefs)
                        await $_getPrefetchedData<Profile, $ProfilesTable, Tag>(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._tagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(db, table, p0).tagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringTransfersRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          RecurringTransfer
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._recurringTransfersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringTransfersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transferLogsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          TransferLog
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._transferLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).transferLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionSplitsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          TransactionSplit
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._transactionSplitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionSplitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, $$ProfilesTableReferences),
      Profile,
      PrefetchHooks Function({
        bool accountsRefs,
        bool creditCardsRefs,
        bool loansRefs,
        bool billsRefs,
        bool billPaymentsRefs,
        bool creditScoreSnapshotsRefs,
        bool paycheckSchedulesRefs,
        bool paychecksRefs,
        bool importBatchesRefs,
        bool budgetEntriesRefs,
        bool budgetTargetsRefs,
        bool categoryRulesRefs,
        bool paymentsRefs,
        bool netWorthSnapshotsRefs,
        bool accountBalanceSnapshotsRefs,
        bool goalsRefs,
        bool paycheckAllocationsRefs,
        bool tagsRefs,
        bool recurringTransfersRefs,
        bool transferLogsRefs,
        bool transactionSplitsRefs,
      })
    >;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required int profileId,
  required String name,
  Value<String?> institution,
  required AccountType type,
  Value<int> balanceCents,
  Value<int?> reconciledBalanceCents,
  Value<DateTime?> reconciledAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> name,
  Value<String?> institution,
  Value<AccountType> type,
  Value<int> balanceCents,
  Value<int?> reconciledBalanceCents,
  Value<DateTime?> reconciledAt,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('accounts__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ImportBatchesTable, List<ImportBatch>>
  _importBatchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.importBatches,
    aliasName: 'accounts__id__import_batches__account_id',
  );

  $$ImportBatchesTableProcessedTableManager get importBatchesRefs {
    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_importBatchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'accounts__id__budget_entries__account_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'accounts__id__payments__from_account_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.fromAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AccountBalanceSnapshotsTable,
    List<AccountBalanceSnapshot>
  >
  _accountBalanceSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.accountBalanceSnapshots,
        aliasName: 'accounts__id__account_balance_snapshots__account_id',
      );

  $$AccountBalanceSnapshotsTableProcessedTableManager
  get accountBalanceSnapshotsRefs {
    final manager = $$AccountBalanceSnapshotsTableTableManager(
      $_db,
      $_db.accountBalanceSnapshots,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accountBalanceSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goals,
    aliasName: 'accounts__id__goals__account_id',
  );

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reconciledBalanceCents => $composableBuilder(
    column: $table.reconciledBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reconciledAt => $composableBuilder(
    column: $table.reconciledAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> importBatchesRefs(
    Expression<bool> Function($$ImportBatchesTableFilterComposer f) f,
  ) {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.fromAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountBalanceSnapshotsRefs(
    Expression<bool> Function($$AccountBalanceSnapshotsTableFilterComposer f) f,
  ) {
    final $$AccountBalanceSnapshotsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accountBalanceSnapshots,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccountBalanceSnapshotsTableFilterComposer(
                $db: $db,
                $table: $db.accountBalanceSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> goalsRefs(
    Expression<bool> Function($$GoalsTableFilterComposer f) f,
  ) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reconciledBalanceCents => $composableBuilder(
    column: $table.reconciledBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reconciledAt => $composableBuilder(
    column: $table.reconciledAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reconciledBalanceCents => $composableBuilder(
    column: $table.reconciledBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reconciledAt => $composableBuilder(
    column: $table.reconciledAt,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> importBatchesRefs<T extends Object>(
    Expression<T> Function($$ImportBatchesTableAnnotationComposer a) f,
  ) {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.fromAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accountBalanceSnapshotsRefs<T extends Object>(
    Expression<T> Function($$AccountBalanceSnapshotsTableAnnotationComposer a)
    f,
  ) {
    final $$AccountBalanceSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accountBalanceSnapshots,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccountBalanceSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.accountBalanceSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
    Expression<T> Function($$GoalsTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool profileId,
            bool importBatchesRefs,
            bool budgetEntriesRefs,
            bool paymentsRefs,
            bool accountBalanceSnapshotsRefs,
            bool goalsRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<int?> reconciledBalanceCents = const Value.absent(),
                Value<DateTime?> reconciledAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                institution: institution,
                type: type,
                balanceCents: balanceCents,
                reconciledBalanceCents: reconciledBalanceCents,
                reconciledAt: reconciledAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                Value<String?> institution = const Value.absent(),
                required AccountType type,
                Value<int> balanceCents = const Value.absent(),
                Value<int?> reconciledBalanceCents = const Value.absent(),
                Value<DateTime?> reconciledAt = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                institution: institution,
                type: type,
                balanceCents: balanceCents,
                reconciledBalanceCents: reconciledBalanceCents,
                reconciledAt: reconciledAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                importBatchesRefs = false,
                budgetEntriesRefs = false,
                paymentsRefs = false,
                accountBalanceSnapshotsRefs = false,
                goalsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (importBatchesRefs) db.importBatches,
                    if (budgetEntriesRefs) db.budgetEntries,
                    if (paymentsRefs) db.payments,
                    if (accountBalanceSnapshotsRefs) db.accountBalanceSnapshots,
                    if (goalsRefs) db.goals,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$AccountsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$AccountsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (importBatchesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          ImportBatch
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._importBatchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).importBatchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (accountBalanceSnapshotsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          AccountBalanceSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._accountBalanceSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).accountBalanceSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Goal
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._goalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).goalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool profileId,
        bool importBatchesRefs,
        bool budgetEntriesRefs,
        bool paymentsRefs,
        bool accountBalanceSnapshotsRefs,
        bool goalsRefs,
      })
    >;
typedef $$CreditCardsTableCreateCompanionBuilder =
    CreditCardsCompanion Function({
      Value<int> id,
      required int profileId,
      required String name,
      Value<int> balanceCents,
      required int creditLimitCents,
      Value<double> apr,
      Value<int> annualFeeCents,
      Value<int> monthlyFeeCents,
      Value<int?> statementCloseDay,
      Value<int?> paymentDueDay,
      Value<int?> minimumPaymentDueCents,
      Value<DateTime?> annualFeeDate,
    });
typedef $$CreditCardsTableUpdateCompanionBuilder =
    CreditCardsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> name,
      Value<int> balanceCents,
      Value<int> creditLimitCents,
      Value<double> apr,
      Value<int> annualFeeCents,
      Value<int> monthlyFeeCents,
      Value<int?> statementCloseDay,
      Value<int?> paymentDueDay,
      Value<int?> minimumPaymentDueCents,
      Value<DateTime?> annualFeeDate,
    });

final class $$CreditCardsTableReferences
    extends BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCard> {
  $$CreditCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('credit_cards__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'credit_cards__id__budget_entries__card_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimitCents => $composableBuilder(
    column: $table.creditLimitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get apr => $composableBuilder(
    column: $table.apr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get annualFeeCents => $composableBuilder(
    column: $table.annualFeeCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyFeeCents => $composableBuilder(
    column: $table.monthlyFeeCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statementCloseDay => $composableBuilder(
    column: $table.statementCloseDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumPaymentDueCents => $composableBuilder(
    column: $table.minimumPaymentDueCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get annualFeeDate => $composableBuilder(
    column: $table.annualFeeDate,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimitCents => $composableBuilder(
    column: $table.creditLimitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get apr => $composableBuilder(
    column: $table.apr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get annualFeeCents => $composableBuilder(
    column: $table.annualFeeCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyFeeCents => $composableBuilder(
    column: $table.monthlyFeeCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statementCloseDay => $composableBuilder(
    column: $table.statementCloseDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumPaymentDueCents => $composableBuilder(
    column: $table.minimumPaymentDueCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get annualFeeDate => $composableBuilder(
    column: $table.annualFeeDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditLimitCents => $composableBuilder(
    column: $table.creditLimitCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get apr =>
      $composableBuilder(column: $table.apr, builder: (column) => column);

  GeneratedColumn<int> get annualFeeCents => $composableBuilder(
    column: $table.annualFeeCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyFeeCents => $composableBuilder(
    column: $table.monthlyFeeCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statementCloseDay => $composableBuilder(
    column: $table.statementCloseDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumPaymentDueCents => $composableBuilder(
    column: $table.minimumPaymentDueCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get annualFeeDate => $composableBuilder(
    column: $table.annualFeeDate,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditCardsTable,
          CreditCard,
          $$CreditCardsTableFilterComposer,
          $$CreditCardsTableOrderingComposer,
          $$CreditCardsTableAnnotationComposer,
          $$CreditCardsTableCreateCompanionBuilder,
          $$CreditCardsTableUpdateCompanionBuilder,
          (CreditCard, $$CreditCardsTableReferences),
          CreditCard,
          PrefetchHooks Function({bool profileId, bool budgetEntriesRefs})
        > {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<int> creditLimitCents = const Value.absent(),
                Value<double> apr = const Value.absent(),
                Value<int> annualFeeCents = const Value.absent(),
                Value<int> monthlyFeeCents = const Value.absent(),
                Value<int?> statementCloseDay = const Value.absent(),
                Value<int?> paymentDueDay = const Value.absent(),
                Value<int?> minimumPaymentDueCents = const Value.absent(),
                Value<DateTime?> annualFeeDate = const Value.absent(),
              }) => CreditCardsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                balanceCents: balanceCents,
                creditLimitCents: creditLimitCents,
                apr: apr,
                annualFeeCents: annualFeeCents,
                monthlyFeeCents: monthlyFeeCents,
                statementCloseDay: statementCloseDay,
                paymentDueDay: paymentDueDay,
                minimumPaymentDueCents: minimumPaymentDueCents,
                annualFeeDate: annualFeeDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                Value<int> balanceCents = const Value.absent(),
                required int creditLimitCents,
                Value<double> apr = const Value.absent(),
                Value<int> annualFeeCents = const Value.absent(),
                Value<int> monthlyFeeCents = const Value.absent(),
                Value<int?> statementCloseDay = const Value.absent(),
                Value<int?> paymentDueDay = const Value.absent(),
                Value<int?> minimumPaymentDueCents = const Value.absent(),
                Value<DateTime?> annualFeeDate = const Value.absent(),
              }) => CreditCardsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                balanceCents: balanceCents,
                creditLimitCents: creditLimitCents,
                apr: apr,
                annualFeeCents: annualFeeCents,
                monthlyFeeCents: monthlyFeeCents,
                statementCloseDay: statementCloseDay,
                paymentDueDay: paymentDueDay,
                minimumPaymentDueCents: minimumPaymentDueCents,
                annualFeeDate: annualFeeDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreditCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, budgetEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetEntriesRefs) db.budgetEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$CreditCardsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$CreditCardsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          CreditCard,
                          $CreditCardsTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CreditCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditCardsTable,
      CreditCard,
      $$CreditCardsTableFilterComposer,
      $$CreditCardsTableOrderingComposer,
      $$CreditCardsTableAnnotationComposer,
      $$CreditCardsTableCreateCompanionBuilder,
      $$CreditCardsTableUpdateCompanionBuilder,
      (CreditCard, $$CreditCardsTableReferences),
      CreditCard,
      PrefetchHooks Function({bool profileId, bool budgetEntriesRefs})
    >;
typedef $$LoansTableCreateCompanionBuilder = LoansCompanion Function({
  Value<int> id,
  required int profileId,
  required String name,
  required int balanceCents,
  required int originalAmountCents,
  Value<double> apr,
  Value<int> monthlyPaymentCents,
});
typedef $$LoansTableUpdateCompanionBuilder = LoansCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> name,
  Value<int> balanceCents,
  Value<int> originalAmountCents,
  Value<double> apr,
  Value<int> monthlyPaymentCents,
});

final class $$LoansTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTable, Loan> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('loans__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalAmountCents => $composableBuilder(
    column: $table.originalAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get apr => $composableBuilder(
    column: $table.apr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyPaymentCents => $composableBuilder(
    column: $table.monthlyPaymentCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalAmountCents => $composableBuilder(
    column: $table.originalAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get apr => $composableBuilder(
    column: $table.apr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyPaymentCents => $composableBuilder(
    column: $table.monthlyPaymentCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalAmountCents => $composableBuilder(
    column: $table.originalAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get apr =>
      $composableBuilder(column: $table.apr, builder: (column) => column);

  GeneratedColumn<int> get monthlyPaymentCents => $composableBuilder(
    column: $table.monthlyPaymentCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          Loan,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (Loan, $$LoansTableReferences),
          Loan,
          PrefetchHooks Function({bool profileId})
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<int> originalAmountCents = const Value.absent(),
                Value<double> apr = const Value.absent(),
                Value<int> monthlyPaymentCents = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                profileId: profileId,
                name: name,
                balanceCents: balanceCents,
                originalAmountCents: originalAmountCents,
                apr: apr,
                monthlyPaymentCents: monthlyPaymentCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required int balanceCents,
                required int originalAmountCents,
                Value<double> apr = const Value.absent(),
                Value<int> monthlyPaymentCents = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                balanceCents: balanceCents,
                originalAmountCents: originalAmountCents,
                apr: apr,
                monthlyPaymentCents: monthlyPaymentCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LoansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$LoansTableReferences._profileIdTable(
                          db,
                        ),
                        referencedColumn: $$LoansTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      Loan,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (Loan, $$LoansTableReferences),
      Loan,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$BillsTableCreateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  required int profileId,
  required String name,
  required int amountCents,
  required int dueDay,
  Value<BillFrequency> frequency,
  Value<PaymentSourceType?> paymentSourceType,
  Value<int?> paymentSourceId,
  Value<bool> autopay,
  Value<int?> dueMonth,
  Value<int?> dueYear,
  Value<String> category,
});
typedef $$BillsTableUpdateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> name,
  Value<int> amountCents,
  Value<int> dueDay,
  Value<BillFrequency> frequency,
  Value<PaymentSourceType?> paymentSourceType,
  Value<int?> paymentSourceId,
  Value<bool> autopay,
  Value<int?> dueMonth,
  Value<int?> dueYear,
  Value<String> category,
});

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, Bill> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('bills__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BillPaymentsTable, List<BillPayment>>
  _billPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billPayments,
    aliasName: 'bills__id__bill_payments__bill_id',
  );

  $$BillPaymentsTableProcessedTableManager get billPaymentsRefs {
    final manager = $$BillPaymentsTableTableManager(
      $_db,
      $_db.billPayments,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PaycheckAllocationsTable,
    List<PaycheckAllocation>
  >
  _paycheckAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paycheckAllocations,
        aliasName: 'bills__id__paycheck_allocations__bill_id',
      );

  $$PaycheckAllocationsTableProcessedTableManager get paycheckAllocationsRefs {
    final manager = $$PaycheckAllocationsTableTableManager(
      $_db,
      $_db.paycheckAllocations,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paycheckAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BillFrequency, BillFrequency, String>
  get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentSourceType?, PaymentSourceType, String>
  get paymentSourceType => $composableBuilder(
    column: $table.paymentSourceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get paymentSourceId => $composableBuilder(
    column: $table.paymentSourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autopay => $composableBuilder(
    column: $table.autopay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueMonth => $composableBuilder(
    column: $table.dueMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueYear => $composableBuilder(
    column: $table.dueYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> billPaymentsRefs(
    Expression<bool> Function($$BillPaymentsTableFilterComposer f) f,
  ) {
    final $$BillPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paycheckAllocationsRefs(
    Expression<bool> Function($$PaycheckAllocationsTableFilterComposer f) f,
  ) {
    final $$PaycheckAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paycheckAllocations,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaycheckAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paycheckAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentSourceType => $composableBuilder(
    column: $table.paymentSourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentSourceId => $composableBuilder(
    column: $table.paymentSourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autopay => $composableBuilder(
    column: $table.autopay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueMonth => $composableBuilder(
    column: $table.dueMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueYear => $composableBuilder(
    column: $table.dueYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BillFrequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentSourceType?, String>
  get paymentSourceType => $composableBuilder(
    column: $table.paymentSourceType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentSourceId => $composableBuilder(
    column: $table.paymentSourceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autopay =>
      $composableBuilder(column: $table.autopay, builder: (column) => column);

  GeneratedColumn<int> get dueMonth =>
      $composableBuilder(column: $table.dueMonth, builder: (column) => column);

  GeneratedColumn<int> get dueYear =>
      $composableBuilder(column: $table.dueYear, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> billPaymentsRefs<T extends Object>(
    Expression<T> Function($$BillPaymentsTableAnnotationComposer a) f,
  ) {
    final $$BillPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paycheckAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaycheckAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaycheckAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paycheckAllocations,
          getReferencedColumn: (t) => t.billId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaycheckAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paycheckAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillsTable,
          Bill,
          $$BillsTableFilterComposer,
          $$BillsTableOrderingComposer,
          $$BillsTableAnnotationComposer,
          $$BillsTableCreateCompanionBuilder,
          $$BillsTableUpdateCompanionBuilder,
          (Bill, $$BillsTableReferences),
          Bill,
          PrefetchHooks Function({
            bool profileId,
            bool billPaymentsRefs,
            bool paycheckAllocationsRefs,
          })
        > {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<BillFrequency> frequency = const Value.absent(),
                Value<PaymentSourceType?> paymentSourceType =
                    const Value.absent(),
                Value<int?> paymentSourceId = const Value.absent(),
                Value<bool> autopay = const Value.absent(),
                Value<int?> dueMonth = const Value.absent(),
                Value<int?> dueYear = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => BillsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                amountCents: amountCents,
                dueDay: dueDay,
                frequency: frequency,
                paymentSourceType: paymentSourceType,
                paymentSourceId: paymentSourceId,
                autopay: autopay,
                dueMonth: dueMonth,
                dueYear: dueYear,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required int amountCents,
                required int dueDay,
                Value<BillFrequency> frequency = const Value.absent(),
                Value<PaymentSourceType?> paymentSourceType =
                    const Value.absent(),
                Value<int?> paymentSourceId = const Value.absent(),
                Value<bool> autopay = const Value.absent(),
                Value<int?> dueMonth = const Value.absent(),
                Value<int?> dueYear = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => BillsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                amountCents: amountCents,
                dueDay: dueDay,
                frequency: frequency,
                paymentSourceType: paymentSourceType,
                paymentSourceId: paymentSourceId,
                autopay: autopay,
                dueMonth: dueMonth,
                dueYear: dueYear,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BillsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                billPaymentsRefs = false,
                paycheckAllocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (billPaymentsRefs) db.billPayments,
                    if (paycheckAllocationsRefs) db.paycheckAllocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$BillsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$BillsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (billPaymentsRefs)
                        await $_getPrefetchedData<
                          Bill,
                          $BillsTable,
                          BillPayment
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._billPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).billPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.billId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paycheckAllocationsRefs)
                        await $_getPrefetchedData<
                          Bill,
                          $BillsTable,
                          PaycheckAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._paycheckAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).paycheckAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.billId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillsTable,
      Bill,
      $$BillsTableFilterComposer,
      $$BillsTableOrderingComposer,
      $$BillsTableAnnotationComposer,
      $$BillsTableCreateCompanionBuilder,
      $$BillsTableUpdateCompanionBuilder,
      (Bill, $$BillsTableReferences),
      Bill,
      PrefetchHooks Function({
        bool profileId,
        bool billPaymentsRefs,
        bool paycheckAllocationsRefs,
      })
    >;
typedef $$BillPaymentsTableCreateCompanionBuilder =
    BillPaymentsCompanion Function({
      Value<int> id,
      required int profileId,
      required int billId,
      required DateTime periodStart,
      required DateTime paidAt,
    });
typedef $$BillPaymentsTableUpdateCompanionBuilder =
    BillPaymentsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> billId,
      Value<DateTime> periodStart,
      Value<DateTime> paidAt,
    });

final class $$BillPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $BillPaymentsTable, BillPayment> {
  $$BillPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('bill_payments__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('bill_payments__bill_id__bills__id');

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<int>('bill_id')!;

    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'bill_payments__id__budget_entries__source_bill_payment_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager($_db, $_db.budgetEntries)
        .filter(
          (f) => f.sourceBillPaymentId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.sourceBillPaymentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableOrderingComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.sourceBillPaymentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillPaymentsTable,
          BillPayment,
          $$BillPaymentsTableFilterComposer,
          $$BillPaymentsTableOrderingComposer,
          $$BillPaymentsTableAnnotationComposer,
          $$BillPaymentsTableCreateCompanionBuilder,
          $$BillPaymentsTableUpdateCompanionBuilder,
          (BillPayment, $$BillPaymentsTableReferences),
          BillPayment,
          PrefetchHooks Function({
            bool profileId,
            bool billId,
            bool budgetEntriesRefs,
          })
        > {
  $$BillPaymentsTableTableManager(_$AppDatabase db, $BillPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> billId = const Value.absent(),
                Value<DateTime> periodStart = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
              }) => BillPaymentsCompanion(
                id: id,
                profileId: profileId,
                billId: billId,
                periodStart: periodStart,
                paidAt: paidAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int billId,
                required DateTime periodStart,
                required DateTime paidAt,
              }) => BillPaymentsCompanion.insert(
                id: id,
                profileId: profileId,
                billId: billId,
                periodStart: periodStart,
                paidAt: paidAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BillPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, billId = false, budgetEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetEntriesRefs) db.budgetEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$BillPaymentsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$BillPaymentsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (billId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.billId,
                            referencedTable: $$BillPaymentsTableReferences
                                ._billIdTable(db),
                            referencedColumn: $$BillPaymentsTableReferences
                                ._billIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          BillPayment,
                          $BillPaymentsTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BillPaymentsTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillPaymentsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceBillPaymentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BillPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillPaymentsTable,
      BillPayment,
      $$BillPaymentsTableFilterComposer,
      $$BillPaymentsTableOrderingComposer,
      $$BillPaymentsTableAnnotationComposer,
      $$BillPaymentsTableCreateCompanionBuilder,
      $$BillPaymentsTableUpdateCompanionBuilder,
      (BillPayment, $$BillPaymentsTableReferences),
      BillPayment,
      PrefetchHooks Function({
        bool profileId,
        bool billId,
        bool budgetEntriesRefs,
      })
    >;
typedef $$CreditScoreSnapshotsTableCreateCompanionBuilder =
    CreditScoreSnapshotsCompanion Function({
      Value<int> id,
      required int profileId,
      required DateTime date,
      required int score,
      required double utilization,
      Value<int> derogatoryMarks,
      Value<int> accountAgeMonths,
      Value<int> hardInquiries,
    });
typedef $$CreditScoreSnapshotsTableUpdateCompanionBuilder =
    CreditScoreSnapshotsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<DateTime> date,
      Value<int> score,
      Value<double> utilization,
      Value<int> derogatoryMarks,
      Value<int> accountAgeMonths,
      Value<int> hardInquiries,
    });

final class $$CreditScoreSnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreditScoreSnapshotsTable,
          CreditScoreSnapshot
        > {
  $$CreditScoreSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) => db.profiles
      .createAlias('credit_score_snapshots__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreditScoreSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditScoreSnapshotsTable> {
  $$CreditScoreSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get utilization => $composableBuilder(
    column: $table.utilization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get derogatoryMarks => $composableBuilder(
    column: $table.derogatoryMarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountAgeMonths => $composableBuilder(
    column: $table.accountAgeMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hardInquiries => $composableBuilder(
    column: $table.hardInquiries,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditScoreSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditScoreSnapshotsTable> {
  $$CreditScoreSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get utilization => $composableBuilder(
    column: $table.utilization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get derogatoryMarks => $composableBuilder(
    column: $table.derogatoryMarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountAgeMonths => $composableBuilder(
    column: $table.accountAgeMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hardInquiries => $composableBuilder(
    column: $table.hardInquiries,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditScoreSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditScoreSnapshotsTable> {
  $$CreditScoreSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get utilization => $composableBuilder(
    column: $table.utilization,
    builder: (column) => column,
  );

  GeneratedColumn<int> get derogatoryMarks => $composableBuilder(
    column: $table.derogatoryMarks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountAgeMonths => $composableBuilder(
    column: $table.accountAgeMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hardInquiries => $composableBuilder(
    column: $table.hardInquiries,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditScoreSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditScoreSnapshotsTable,
          CreditScoreSnapshot,
          $$CreditScoreSnapshotsTableFilterComposer,
          $$CreditScoreSnapshotsTableOrderingComposer,
          $$CreditScoreSnapshotsTableAnnotationComposer,
          $$CreditScoreSnapshotsTableCreateCompanionBuilder,
          $$CreditScoreSnapshotsTableUpdateCompanionBuilder,
          (CreditScoreSnapshot, $$CreditScoreSnapshotsTableReferences),
          CreditScoreSnapshot,
          PrefetchHooks Function({bool profileId})
        > {
  $$CreditScoreSnapshotsTableTableManager(
    _$AppDatabase db,
    $CreditScoreSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditScoreSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditScoreSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CreditScoreSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<double> utilization = const Value.absent(),
                Value<int> derogatoryMarks = const Value.absent(),
                Value<int> accountAgeMonths = const Value.absent(),
                Value<int> hardInquiries = const Value.absent(),
              }) => CreditScoreSnapshotsCompanion(
                id: id,
                profileId: profileId,
                date: date,
                score: score,
                utilization: utilization,
                derogatoryMarks: derogatoryMarks,
                accountAgeMonths: accountAgeMonths,
                hardInquiries: hardInquiries,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required DateTime date,
                required int score,
                required double utilization,
                Value<int> derogatoryMarks = const Value.absent(),
                Value<int> accountAgeMonths = const Value.absent(),
                Value<int> hardInquiries = const Value.absent(),
              }) => CreditScoreSnapshotsCompanion.insert(
                id: id,
                profileId: profileId,
                date: date,
                score: score,
                utilization: utilization,
                derogatoryMarks: derogatoryMarks,
                accountAgeMonths: accountAgeMonths,
                hardInquiries: hardInquiries,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreditScoreSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$CreditScoreSnapshotsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$CreditScoreSnapshotsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreditScoreSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditScoreSnapshotsTable,
      CreditScoreSnapshot,
      $$CreditScoreSnapshotsTableFilterComposer,
      $$CreditScoreSnapshotsTableOrderingComposer,
      $$CreditScoreSnapshotsTableAnnotationComposer,
      $$CreditScoreSnapshotsTableCreateCompanionBuilder,
      $$CreditScoreSnapshotsTableUpdateCompanionBuilder,
      (CreditScoreSnapshot, $$CreditScoreSnapshotsTableReferences),
      CreditScoreSnapshot,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$PaycheckSchedulesTableCreateCompanionBuilder =
    PaycheckSchedulesCompanion Function({
      Value<int> id,
      required int profileId,
      required String name,
      required PayFrequency frequency,
      required DateTime anchorDate,
      required int amountCents,
      Value<bool> active,
    });
typedef $$PaycheckSchedulesTableUpdateCompanionBuilder =
    PaycheckSchedulesCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> name,
      Value<PayFrequency> frequency,
      Value<DateTime> anchorDate,
      Value<int> amountCents,
      Value<bool> active,
    });

final class $$PaycheckSchedulesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaycheckSchedulesTable,
          PaycheckSchedule
        > {
  $$PaycheckSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('paycheck_schedules__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaychecksTable, List<Paycheck>>
  _paychecksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paychecks,
    aliasName: 'paycheck_schedules__id__paychecks__schedule_id',
  );

  $$PaychecksTableProcessedTableManager get paychecksRefs {
    final manager = $$PaychecksTableTableManager(
      $_db,
      $_db.paychecks,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paychecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaycheckSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $PaycheckSchedulesTable> {
  $$PaycheckSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PayFrequency, PayFrequency, String>
  get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paychecksRefs(
    Expression<bool> Function($$PaychecksTableFilterComposer f) f,
  ) {
    final $$PaychecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableFilterComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaycheckSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $PaycheckSchedulesTable> {
  $$PaycheckSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaycheckSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaycheckSchedulesTable> {
  $$PaycheckSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PayFrequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paychecksRefs<T extends Object>(
    Expression<T> Function($$PaychecksTableAnnotationComposer a) f,
  ) {
    final $$PaychecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableAnnotationComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaycheckSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaycheckSchedulesTable,
          PaycheckSchedule,
          $$PaycheckSchedulesTableFilterComposer,
          $$PaycheckSchedulesTableOrderingComposer,
          $$PaycheckSchedulesTableAnnotationComposer,
          $$PaycheckSchedulesTableCreateCompanionBuilder,
          $$PaycheckSchedulesTableUpdateCompanionBuilder,
          (PaycheckSchedule, $$PaycheckSchedulesTableReferences),
          PaycheckSchedule,
          PrefetchHooks Function({bool profileId, bool paychecksRefs})
        > {
  $$PaycheckSchedulesTableTableManager(
    _$AppDatabase db,
    $PaycheckSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaycheckSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaycheckSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaycheckSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<PayFrequency> frequency = const Value.absent(),
                Value<DateTime> anchorDate = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => PaycheckSchedulesCompanion(
                id: id,
                profileId: profileId,
                name: name,
                frequency: frequency,
                anchorDate: anchorDate,
                amountCents: amountCents,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required PayFrequency frequency,
                required DateTime anchorDate,
                required int amountCents,
                Value<bool> active = const Value.absent(),
              }) => PaycheckSchedulesCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                frequency: frequency,
                anchorDate: anchorDate,
                amountCents: amountCents,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaycheckSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, paychecksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paychecksRefs) db.paychecks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$PaycheckSchedulesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$PaycheckSchedulesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paychecksRefs)
                    await $_getPrefetchedData<
                      PaycheckSchedule,
                      $PaycheckSchedulesTable,
                      Paycheck
                    >(
                      currentTable: table,
                      referencedTable: $$PaycheckSchedulesTableReferences
                          ._paychecksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PaycheckSchedulesTableReferences(
                            db,
                            table,
                            p0,
                          ).paychecksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.scheduleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PaycheckSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaycheckSchedulesTable,
      PaycheckSchedule,
      $$PaycheckSchedulesTableFilterComposer,
      $$PaycheckSchedulesTableOrderingComposer,
      $$PaycheckSchedulesTableAnnotationComposer,
      $$PaycheckSchedulesTableCreateCompanionBuilder,
      $$PaycheckSchedulesTableUpdateCompanionBuilder,
      (PaycheckSchedule, $$PaycheckSchedulesTableReferences),
      PaycheckSchedule,
      PrefetchHooks Function({bool profileId, bool paychecksRefs})
    >;
typedef $$PaychecksTableCreateCompanionBuilder = PaychecksCompanion Function({
  Value<int> id,
  required int profileId,
  required String name,
  required DateTime date,
  required int amountCents,
  Value<int> bonusCents,
  Value<bool> received,
  Value<bool> receivedIsManual,
  Value<bool> dismissed,
  Value<int?> scheduleId,
});
typedef $$PaychecksTableUpdateCompanionBuilder = PaychecksCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> name,
  Value<DateTime> date,
  Value<int> amountCents,
  Value<int> bonusCents,
  Value<bool> received,
  Value<bool> receivedIsManual,
  Value<bool> dismissed,
  Value<int?> scheduleId,
});

final class $$PaychecksTableReferences
    extends BaseReferences<_$AppDatabase, $PaychecksTable, Paycheck> {
  $$PaychecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('paychecks__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaycheckSchedulesTable _scheduleIdTable(_$AppDatabase db) => db
      .paycheckSchedules
      .createAlias('paychecks__schedule_id__paycheck_schedules__id');

  $$PaycheckSchedulesTableProcessedTableManager? get scheduleId {
    final $_column = $_itemColumn<int>('schedule_id');
    if ($_column == null) return null;
    final manager = $$PaycheckSchedulesTableTableManager(
      $_db,
      $_db.paycheckSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'paychecks__id__budget_entries__source_paycheck_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.sourcePaycheckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PaycheckAllocationsTable,
    List<PaycheckAllocation>
  >
  _paycheckAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paycheckAllocations,
        aliasName: 'paychecks__id__paycheck_allocations__paycheck_id',
      );

  $$PaycheckAllocationsTableProcessedTableManager get paycheckAllocationsRefs {
    final manager = $$PaycheckAllocationsTableTableManager(
      $_db,
      $_db.paycheckAllocations,
    ).filter((f) => f.paycheckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paycheckAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaychecksTableFilterComposer
    extends Composer<_$AppDatabase, $PaychecksTable> {
  $$PaychecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonusCents => $composableBuilder(
    column: $table.bonusCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get received => $composableBuilder(
    column: $table.received,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get receivedIsManual => $composableBuilder(
    column: $table.receivedIsManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaycheckSchedulesTableFilterComposer get scheduleId {
    final $$PaycheckSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.paycheckSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaycheckSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.paycheckSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.sourcePaycheckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paycheckAllocationsRefs(
    Expression<bool> Function($$PaycheckAllocationsTableFilterComposer f) f,
  ) {
    final $$PaycheckAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paycheckAllocations,
      getReferencedColumn: (t) => t.paycheckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaycheckAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paycheckAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaychecksTableOrderingComposer
    extends Composer<_$AppDatabase, $PaychecksTable> {
  $$PaychecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonusCents => $composableBuilder(
    column: $table.bonusCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get received => $composableBuilder(
    column: $table.received,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get receivedIsManual => $composableBuilder(
    column: $table.receivedIsManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaycheckSchedulesTableOrderingComposer get scheduleId {
    final $$PaycheckSchedulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.paycheckSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaycheckSchedulesTableOrderingComposer(
            $db: $db,
            $table: $db.paycheckSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaychecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaychecksTable> {
  $$PaychecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonusCents => $composableBuilder(
    column: $table.bonusCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get received =>
      $composableBuilder(column: $table.received, builder: (column) => column);

  GeneratedColumn<bool> get receivedIsManual => $composableBuilder(
    column: $table.receivedIsManual,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dismissed =>
      $composableBuilder(column: $table.dismissed, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaycheckSchedulesTableAnnotationComposer get scheduleId {
    final $$PaycheckSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.scheduleId,
          referencedTable: $db.paycheckSchedules,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaycheckSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.paycheckSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.sourcePaycheckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paycheckAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaycheckAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaycheckAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paycheckAllocations,
          getReferencedColumn: (t) => t.paycheckId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaycheckAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paycheckAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PaychecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaychecksTable,
          Paycheck,
          $$PaychecksTableFilterComposer,
          $$PaychecksTableOrderingComposer,
          $$PaychecksTableAnnotationComposer,
          $$PaychecksTableCreateCompanionBuilder,
          $$PaychecksTableUpdateCompanionBuilder,
          (Paycheck, $$PaychecksTableReferences),
          Paycheck,
          PrefetchHooks Function({
            bool profileId,
            bool scheduleId,
            bool budgetEntriesRefs,
            bool paycheckAllocationsRefs,
          })
        > {
  $$PaychecksTableTableManager(_$AppDatabase db, $PaychecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaychecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaychecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaychecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> bonusCents = const Value.absent(),
                Value<bool> received = const Value.absent(),
                Value<bool> receivedIsManual = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
                Value<int?> scheduleId = const Value.absent(),
              }) => PaychecksCompanion(
                id: id,
                profileId: profileId,
                name: name,
                date: date,
                amountCents: amountCents,
                bonusCents: bonusCents,
                received: received,
                receivedIsManual: receivedIsManual,
                dismissed: dismissed,
                scheduleId: scheduleId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required DateTime date,
                required int amountCents,
                Value<int> bonusCents = const Value.absent(),
                Value<bool> received = const Value.absent(),
                Value<bool> receivedIsManual = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
                Value<int?> scheduleId = const Value.absent(),
              }) => PaychecksCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                date: date,
                amountCents: amountCents,
                bonusCents: bonusCents,
                received: received,
                receivedIsManual: receivedIsManual,
                dismissed: dismissed,
                scheduleId: scheduleId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaychecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                scheduleId = false,
                budgetEntriesRefs = false,
                paycheckAllocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetEntriesRefs) db.budgetEntries,
                    if (paycheckAllocationsRefs) db.paycheckAllocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$PaychecksTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$PaychecksTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (scheduleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.scheduleId,
                            referencedTable: $$PaychecksTableReferences
                                ._scheduleIdTable(db),
                            referencedColumn: $$PaychecksTableReferences
                                ._scheduleIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          Paycheck,
                          $PaychecksTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PaychecksTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaychecksTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourcePaycheckId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paycheckAllocationsRefs)
                        await $_getPrefetchedData<
                          Paycheck,
                          $PaychecksTable,
                          PaycheckAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$PaychecksTableReferences
                              ._paycheckAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaychecksTableReferences(
                                db,
                                table,
                                p0,
                              ).paycheckAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.paycheckId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PaychecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaychecksTable,
      Paycheck,
      $$PaychecksTableFilterComposer,
      $$PaychecksTableOrderingComposer,
      $$PaychecksTableAnnotationComposer,
      $$PaychecksTableCreateCompanionBuilder,
      $$PaychecksTableUpdateCompanionBuilder,
      (Paycheck, $$PaychecksTableReferences),
      Paycheck,
      PrefetchHooks Function({
        bool profileId,
        bool scheduleId,
        bool budgetEntriesRefs,
        bool paycheckAllocationsRefs,
      })
    >;
typedef $$ImportBatchesTableCreateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<int> id,
      required int profileId,
      required String sourceFilename,
      required DateTime importedAt,
      required int rowCount,
      Value<int?> accountId,
      Value<int> balanceAdjustmentCents,
    });
typedef $$ImportBatchesTableUpdateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> sourceFilename,
      Value<DateTime> importedAt,
      Value<int> rowCount,
      Value<int?> accountId,
      Value<int> balanceAdjustmentCents,
    });

final class $$ImportBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $ImportBatchesTable, ImportBatch> {
  $$ImportBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('import_batches__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('import_batches__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'import_batches__id__budget_entries__import_batch_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.importBatchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFilename => $composableBuilder(
    column: $table.sourceFilename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rowCount => $composableBuilder(
    column: $table.rowCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAdjustmentCents => $composableBuilder(
    column: $table.balanceAdjustmentCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.importBatchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFilename => $composableBuilder(
    column: $table.sourceFilename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rowCount => $composableBuilder(
    column: $table.rowCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAdjustmentCents => $composableBuilder(
    column: $table.balanceAdjustmentCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceFilename => $composableBuilder(
    column: $table.sourceFilename,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rowCount =>
      $composableBuilder(column: $table.rowCount, builder: (column) => column);

  GeneratedColumn<int> get balanceAdjustmentCents => $composableBuilder(
    column: $table.balanceAdjustmentCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.importBatchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportBatchesTable,
          ImportBatch,
          $$ImportBatchesTableFilterComposer,
          $$ImportBatchesTableOrderingComposer,
          $$ImportBatchesTableAnnotationComposer,
          $$ImportBatchesTableCreateCompanionBuilder,
          $$ImportBatchesTableUpdateCompanionBuilder,
          (ImportBatch, $$ImportBatchesTableReferences),
          ImportBatch,
          PrefetchHooks Function({
            bool profileId,
            bool accountId,
            bool budgetEntriesRefs,
          })
        > {
  $$ImportBatchesTableTableManager(_$AppDatabase db, $ImportBatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> sourceFilename = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<int> rowCount = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int> balanceAdjustmentCents = const Value.absent(),
              }) => ImportBatchesCompanion(
                id: id,
                profileId: profileId,
                sourceFilename: sourceFilename,
                importedAt: importedAt,
                rowCount: rowCount,
                accountId: accountId,
                balanceAdjustmentCents: balanceAdjustmentCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String sourceFilename,
                required DateTime importedAt,
                required int rowCount,
                Value<int?> accountId = const Value.absent(),
                Value<int> balanceAdjustmentCents = const Value.absent(),
              }) => ImportBatchesCompanion.insert(
                id: id,
                profileId: profileId,
                sourceFilename: sourceFilename,
                importedAt: importedAt,
                rowCount: rowCount,
                accountId: accountId,
                balanceAdjustmentCents: balanceAdjustmentCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ImportBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                accountId = false,
                budgetEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetEntriesRefs) db.budgetEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$ImportBatchesTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$ImportBatchesTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$ImportBatchesTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$ImportBatchesTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetEntriesRefs)
                        await $_getPrefetchedData<
                          ImportBatch,
                          $ImportBatchesTable,
                          BudgetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ImportBatchesTableReferences
                              ._budgetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.importBatchId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ImportBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportBatchesTable,
      ImportBatch,
      $$ImportBatchesTableFilterComposer,
      $$ImportBatchesTableOrderingComposer,
      $$ImportBatchesTableAnnotationComposer,
      $$ImportBatchesTableCreateCompanionBuilder,
      $$ImportBatchesTableUpdateCompanionBuilder,
      (ImportBatch, $$ImportBatchesTableReferences),
      ImportBatch,
      PrefetchHooks Function({
        bool profileId,
        bool accountId,
        bool budgetEntriesRefs,
      })
    >;
typedef $$BudgetEntriesTableCreateCompanionBuilder =
    BudgetEntriesCompanion Function({
      Value<int> id,
      required int profileId,
      required DateTime date,
      Value<String> category,
      required int amountCents,
      required EntryType type,
      Value<String?> description,
      Value<String?> payee,
      Value<int?> accountId,
      Value<int?> cardId,
      Value<int?> sourcePaycheckId,
      Value<int?> sourceBillPaymentId,
      Value<int?> importBatchId,
    });
typedef $$BudgetEntriesTableUpdateCompanionBuilder =
    BudgetEntriesCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<DateTime> date,
      Value<String> category,
      Value<int> amountCents,
      Value<EntryType> type,
      Value<String?> description,
      Value<String?> payee,
      Value<int?> accountId,
      Value<int?> cardId,
      Value<int?> sourcePaycheckId,
      Value<int?> sourceBillPaymentId,
      Value<int?> importBatchId,
    });

final class $$BudgetEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetEntriesTable, BudgetEntry> {
  $$BudgetEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('budget_entries__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('budget_entries__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('budget_entries__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager? get cardId {
    final $_column = $_itemColumn<int>('card_id');
    if ($_column == null) return null;
    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaychecksTable _sourcePaycheckIdTable(_$AppDatabase db) => db
      .paychecks
      .createAlias('budget_entries__source_paycheck_id__paychecks__id');

  $$PaychecksTableProcessedTableManager? get sourcePaycheckId {
    final $_column = $_itemColumn<int>('source_paycheck_id');
    if ($_column == null) return null;
    final manager = $$PaychecksTableTableManager(
      $_db,
      $_db.paychecks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourcePaycheckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillPaymentsTable _sourceBillPaymentIdTable(_$AppDatabase db) => db
      .billPayments
      .createAlias('budget_entries__source_bill_payment_id__bill_payments__id');

  $$BillPaymentsTableProcessedTableManager? get sourceBillPaymentId {
    final $_column = $_itemColumn<int>('source_bill_payment_id');
    if ($_column == null) return null;
    final manager = $$BillPaymentsTableTableManager(
      $_db,
      $_db.billPayments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceBillPaymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ImportBatchesTable _importBatchIdTable(_$AppDatabase db) => db
      .importBatches
      .createAlias('budget_entries__import_batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager? get importBatchId {
    final $_column = $_itemColumn<int>('import_batch_id');
    if ($_column == null) return null;
    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_importBatchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetEntryTagsTable, List<BudgetEntryTag>>
  _budgetEntryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntryTags,
    aliasName: 'budget_entries__id__budget_entry_tags__entry_id',
  );

  $$BudgetEntryTagsTableProcessedTableManager get budgetEntryTagsRefs {
    final manager = $$BudgetEntryTagsTableTableManager(
      $_db,
      $_db.budgetEntryTags,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetEntryTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionSplitsTable, List<TransactionSplit>>
  _transactionSplitsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionSplits,
        aliasName: 'budget_entries__id__transaction_splits__entry_id',
      );

  $$TransactionSplitsTableProcessedTableManager get transactionSplitsRefs {
    final manager = $$TransactionSplitsTableTableManager(
      $_db,
      $_db.transactionSplits,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionSplitsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BudgetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EntryType, EntryType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaychecksTableFilterComposer get sourcePaycheckId {
    final $$PaychecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourcePaycheckId,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableFilterComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillPaymentsTableFilterComposer get sourceBillPaymentId {
    final $$BillPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBillPaymentId,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportBatchesTableFilterComposer get importBatchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importBatchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetEntryTagsRefs(
    Expression<bool> Function($$BudgetEntryTagsTableFilterComposer f) f,
  ) {
    final $$BudgetEntryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntryTags,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntryTagsTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionSplitsRefs(
    Expression<bool> Function($$TransactionSplitsTableFilterComposer f) f,
  ) {
    final $$TransactionSplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionSplits,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionSplitsTableFilterComposer(
            $db: $db,
            $table: $db.transactionSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaychecksTableOrderingComposer get sourcePaycheckId {
    final $$PaychecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourcePaycheckId,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableOrderingComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillPaymentsTableOrderingComposer get sourceBillPaymentId {
    final $$BillPaymentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBillPaymentId,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableOrderingComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportBatchesTableOrderingComposer get importBatchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importBatchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EntryType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaychecksTableAnnotationComposer get sourcePaycheckId {
    final $$PaychecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourcePaycheckId,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableAnnotationComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillPaymentsTableAnnotationComposer get sourceBillPaymentId {
    final $$BillPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBillPaymentId,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportBatchesTableAnnotationComposer get importBatchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importBatchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> budgetEntryTagsRefs<T extends Object>(
    Expression<T> Function($$BudgetEntryTagsTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntryTags,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionSplitsRefs<T extends Object>(
    Expression<T> Function($$TransactionSplitsTableAnnotationComposer a) f,
  ) {
    final $$TransactionSplitsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionSplits,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionSplitsTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionSplits,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BudgetEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetEntriesTable,
          BudgetEntry,
          $$BudgetEntriesTableFilterComposer,
          $$BudgetEntriesTableOrderingComposer,
          $$BudgetEntriesTableAnnotationComposer,
          $$BudgetEntriesTableCreateCompanionBuilder,
          $$BudgetEntriesTableUpdateCompanionBuilder,
          (BudgetEntry, $$BudgetEntriesTableReferences),
          BudgetEntry,
          PrefetchHooks Function({
            bool profileId,
            bool accountId,
            bool cardId,
            bool sourcePaycheckId,
            bool sourceBillPaymentId,
            bool importBatchId,
            bool budgetEntryTagsRefs,
            bool transactionSplitsRefs,
          })
        > {
  $$BudgetEntriesTableTableManager(_$AppDatabase db, $BudgetEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<EntryType> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int?> cardId = const Value.absent(),
                Value<int?> sourcePaycheckId = const Value.absent(),
                Value<int?> sourceBillPaymentId = const Value.absent(),
                Value<int?> importBatchId = const Value.absent(),
              }) => BudgetEntriesCompanion(
                id: id,
                profileId: profileId,
                date: date,
                category: category,
                amountCents: amountCents,
                type: type,
                description: description,
                payee: payee,
                accountId: accountId,
                cardId: cardId,
                sourcePaycheckId: sourcePaycheckId,
                sourceBillPaymentId: sourceBillPaymentId,
                importBatchId: importBatchId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required DateTime date,
                Value<String> category = const Value.absent(),
                required int amountCents,
                required EntryType type,
                Value<String?> description = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int?> cardId = const Value.absent(),
                Value<int?> sourcePaycheckId = const Value.absent(),
                Value<int?> sourceBillPaymentId = const Value.absent(),
                Value<int?> importBatchId = const Value.absent(),
              }) => BudgetEntriesCompanion.insert(
                id: id,
                profileId: profileId,
                date: date,
                category: category,
                amountCents: amountCents,
                type: type,
                description: description,
                payee: payee,
                accountId: accountId,
                cardId: cardId,
                sourcePaycheckId: sourcePaycheckId,
                sourceBillPaymentId: sourceBillPaymentId,
                importBatchId: importBatchId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                accountId = false,
                cardId = false,
                sourcePaycheckId = false,
                sourceBillPaymentId = false,
                importBatchId = false,
                budgetEntryTagsRefs = false,
                transactionSplitsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetEntryTagsRefs) db.budgetEntryTags,
                    if (transactionSplitsRefs) db.transactionSplits,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (cardId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._cardIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._cardIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (sourcePaycheckId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourcePaycheckId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._sourcePaycheckIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._sourcePaycheckIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (sourceBillPaymentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceBillPaymentId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._sourceBillPaymentIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._sourceBillPaymentIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (importBatchId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.importBatchId,
                            referencedTable: $$BudgetEntriesTableReferences
                                ._importBatchIdTable(db),
                            referencedColumn: $$BudgetEntriesTableReferences
                                ._importBatchIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetEntryTagsRefs)
                        await $_getPrefetchedData<
                          BudgetEntry,
                          $BudgetEntriesTable,
                          BudgetEntryTag
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetEntriesTableReferences
                              ._budgetEntryTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetEntryTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionSplitsRefs)
                        await $_getPrefetchedData<
                          BudgetEntry,
                          $BudgetEntriesTable,
                          TransactionSplit
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetEntriesTableReferences
                              ._transactionSplitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionSplitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BudgetEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetEntriesTable,
      BudgetEntry,
      $$BudgetEntriesTableFilterComposer,
      $$BudgetEntriesTableOrderingComposer,
      $$BudgetEntriesTableAnnotationComposer,
      $$BudgetEntriesTableCreateCompanionBuilder,
      $$BudgetEntriesTableUpdateCompanionBuilder,
      (BudgetEntry, $$BudgetEntriesTableReferences),
      BudgetEntry,
      PrefetchHooks Function({
        bool profileId,
        bool accountId,
        bool cardId,
        bool sourcePaycheckId,
        bool sourceBillPaymentId,
        bool importBatchId,
        bool budgetEntryTagsRefs,
        bool transactionSplitsRefs,
      })
    >;
typedef $$BudgetTargetsTableCreateCompanionBuilder =
    BudgetTargetsCompanion Function({
      Value<int> id,
      required int profileId,
      required String category,
      required int monthlyTargetCents,
    });
typedef $$BudgetTargetsTableUpdateCompanionBuilder =
    BudgetTargetsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> category,
      Value<int> monthlyTargetCents,
    });

final class $$BudgetTargetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetTargetsTable, BudgetTarget> {
  $$BudgetTargetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('budget_targets__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetTargetsTable> {
  $$BudgetTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyTargetCents => $composableBuilder(
    column: $table.monthlyTargetCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetTargetsTable> {
  $$BudgetTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyTargetCents => $composableBuilder(
    column: $table.monthlyTargetCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetTargetsTable> {
  $$BudgetTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get monthlyTargetCents => $composableBuilder(
    column: $table.monthlyTargetCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetTargetsTable,
          BudgetTarget,
          $$BudgetTargetsTableFilterComposer,
          $$BudgetTargetsTableOrderingComposer,
          $$BudgetTargetsTableAnnotationComposer,
          $$BudgetTargetsTableCreateCompanionBuilder,
          $$BudgetTargetsTableUpdateCompanionBuilder,
          (BudgetTarget, $$BudgetTargetsTableReferences),
          BudgetTarget,
          PrefetchHooks Function({bool profileId})
        > {
  $$BudgetTargetsTableTableManager(_$AppDatabase db, $BudgetTargetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetTargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> monthlyTargetCents = const Value.absent(),
              }) => BudgetTargetsCompanion(
                id: id,
                profileId: profileId,
                category: category,
                monthlyTargetCents: monthlyTargetCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String category,
                required int monthlyTargetCents,
              }) => BudgetTargetsCompanion.insert(
                id: id,
                profileId: profileId,
                category: category,
                monthlyTargetCents: monthlyTargetCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetTargetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$BudgetTargetsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$BudgetTargetsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetTargetsTable,
      BudgetTarget,
      $$BudgetTargetsTableFilterComposer,
      $$BudgetTargetsTableOrderingComposer,
      $$BudgetTargetsTableAnnotationComposer,
      $$BudgetTargetsTableCreateCompanionBuilder,
      $$BudgetTargetsTableUpdateCompanionBuilder,
      (BudgetTarget, $$BudgetTargetsTableReferences),
      BudgetTarget,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$CategoryRulesTableCreateCompanionBuilder =
    CategoryRulesCompanion Function({
      Value<int> id,
      required int profileId,
      required RuleField field,
      required String pattern,
      required String category,
      Value<int> priority,
    });
typedef $$CategoryRulesTableUpdateCompanionBuilder =
    CategoryRulesCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<RuleField> field,
      Value<String> pattern,
      Value<String> category,
      Value<int> priority,
    });

final class $$CategoryRulesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryRulesTable, CategoryRule> {
  $$CategoryRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('category_rules__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CategoryRulesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryRulesTable> {
  $$CategoryRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RuleField, RuleField, String> get field =>
      $composableBuilder(
        column: $table.field,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryRulesTable> {
  $$CategoryRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryRulesTable> {
  $$CategoryRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RuleField, String> get field =>
      $composableBuilder(column: $table.field, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryRulesTable,
          CategoryRule,
          $$CategoryRulesTableFilterComposer,
          $$CategoryRulesTableOrderingComposer,
          $$CategoryRulesTableAnnotationComposer,
          $$CategoryRulesTableCreateCompanionBuilder,
          $$CategoryRulesTableUpdateCompanionBuilder,
          (CategoryRule, $$CategoryRulesTableReferences),
          CategoryRule,
          PrefetchHooks Function({bool profileId})
        > {
  $$CategoryRulesTableTableManager(_$AppDatabase db, $CategoryRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<RuleField> field = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> priority = const Value.absent(),
              }) => CategoryRulesCompanion(
                id: id,
                profileId: profileId,
                field: field,
                pattern: pattern,
                category: category,
                priority: priority,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required RuleField field,
                required String pattern,
                required String category,
                Value<int> priority = const Value.absent(),
              }) => CategoryRulesCompanion.insert(
                id: id,
                profileId: profileId,
                field: field,
                pattern: pattern,
                category: category,
                priority: priority,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoryRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$CategoryRulesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$CategoryRulesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CategoryRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryRulesTable,
      CategoryRule,
      $$CategoryRulesTableFilterComposer,
      $$CategoryRulesTableOrderingComposer,
      $$CategoryRulesTableAnnotationComposer,
      $$CategoryRulesTableCreateCompanionBuilder,
      $$CategoryRulesTableUpdateCompanionBuilder,
      (CategoryRule, $$CategoryRulesTableReferences),
      CategoryRule,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int profileId,
  required PaymentAccountType accountType,
  required int accountId,
  required int amountCents,
  required DateTime date,
  Value<String?> note,
  Value<int?> fromAccountId,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<PaymentAccountType> accountType,
  Value<int> accountId,
  Value<int> amountCents,
  Value<DateTime> date,
  Value<String?> note,
  Value<int?> fromAccountId,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('payments__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _fromAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('payments__from_account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get fromAccountId {
    final $_column = $_itemColumn<int>('from_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentAccountType, PaymentAccountType, String>
  get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get fromAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get fromAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentAccountType, String>
  get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get fromAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool profileId, bool fromAccountId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<PaymentAccountType> accountType = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> fromAccountId = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                profileId: profileId,
                accountType: accountType,
                accountId: accountId,
                amountCents: amountCents,
                date: date,
                note: note,
                fromAccountId: fromAccountId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required PaymentAccountType accountType,
                required int accountId,
                required int amountCents,
                required DateTime date,
                Value<String?> note = const Value.absent(),
                Value<int?> fromAccountId = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                profileId: profileId,
                accountType: accountType,
                accountId: accountId,
                amountCents: amountCents,
                date: date,
                note: note,
                fromAccountId: fromAccountId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, fromAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$PaymentsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$PaymentsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (fromAccountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.fromAccountId,
                        referencedTable: $$PaymentsTableReferences
                            ._fromAccountIdTable(db),
                        referencedColumn: $$PaymentsTableReferences
                            ._fromAccountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool profileId, bool fromAccountId})
    >;
typedef $$NetWorthSnapshotsTableCreateCompanionBuilder =
    NetWorthSnapshotsCompanion Function({
      Value<int> id,
      required int profileId,
      required DateTime date,
      required int totalAssetsCents,
      required int totalDebtCents,
      required int netWorthCents,
    });
typedef $$NetWorthSnapshotsTableUpdateCompanionBuilder =
    NetWorthSnapshotsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<DateTime> date,
      Value<int> totalAssetsCents,
      Value<int> totalDebtCents,
      Value<int> netWorthCents,
    });

final class $$NetWorthSnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $NetWorthSnapshotsTable,
          NetWorthSnapshot
        > {
  $$NetWorthSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('net_worth_snapshots__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NetWorthSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAssetsCents => $composableBuilder(
    column: $table.totalAssetsCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDebtCents => $composableBuilder(
    column: $table.totalDebtCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netWorthCents => $composableBuilder(
    column: $table.netWorthCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NetWorthSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAssetsCents => $composableBuilder(
    column: $table.totalAssetsCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDebtCents => $composableBuilder(
    column: $table.totalDebtCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netWorthCents => $composableBuilder(
    column: $table.netWorthCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NetWorthSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalAssetsCents => $composableBuilder(
    column: $table.totalAssetsCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDebtCents => $composableBuilder(
    column: $table.totalDebtCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netWorthCents => $composableBuilder(
    column: $table.netWorthCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NetWorthSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NetWorthSnapshotsTable,
          NetWorthSnapshot,
          $$NetWorthSnapshotsTableFilterComposer,
          $$NetWorthSnapshotsTableOrderingComposer,
          $$NetWorthSnapshotsTableAnnotationComposer,
          $$NetWorthSnapshotsTableCreateCompanionBuilder,
          $$NetWorthSnapshotsTableUpdateCompanionBuilder,
          (NetWorthSnapshot, $$NetWorthSnapshotsTableReferences),
          NetWorthSnapshot,
          PrefetchHooks Function({bool profileId})
        > {
  $$NetWorthSnapshotsTableTableManager(
    _$AppDatabase db,
    $NetWorthSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NetWorthSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NetWorthSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NetWorthSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> totalAssetsCents = const Value.absent(),
                Value<int> totalDebtCents = const Value.absent(),
                Value<int> netWorthCents = const Value.absent(),
              }) => NetWorthSnapshotsCompanion(
                id: id,
                profileId: profileId,
                date: date,
                totalAssetsCents: totalAssetsCents,
                totalDebtCents: totalDebtCents,
                netWorthCents: netWorthCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required DateTime date,
                required int totalAssetsCents,
                required int totalDebtCents,
                required int netWorthCents,
              }) => NetWorthSnapshotsCompanion.insert(
                id: id,
                profileId: profileId,
                date: date,
                totalAssetsCents: totalAssetsCents,
                totalDebtCents: totalDebtCents,
                netWorthCents: netWorthCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NetWorthSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$NetWorthSnapshotsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$NetWorthSnapshotsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NetWorthSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NetWorthSnapshotsTable,
      NetWorthSnapshot,
      $$NetWorthSnapshotsTableFilterComposer,
      $$NetWorthSnapshotsTableOrderingComposer,
      $$NetWorthSnapshotsTableAnnotationComposer,
      $$NetWorthSnapshotsTableCreateCompanionBuilder,
      $$NetWorthSnapshotsTableUpdateCompanionBuilder,
      (NetWorthSnapshot, $$NetWorthSnapshotsTableReferences),
      NetWorthSnapshot,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$AccountBalanceSnapshotsTableCreateCompanionBuilder =
    AccountBalanceSnapshotsCompanion Function({
      Value<int> id,
      required int profileId,
      required int accountId,
      required DateTime date,
      required int balanceCents,
    });
typedef $$AccountBalanceSnapshotsTableUpdateCompanionBuilder =
    AccountBalanceSnapshotsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> accountId,
      Value<DateTime> date,
      Value<int> balanceCents,
    });

final class $$AccountBalanceSnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AccountBalanceSnapshotsTable,
          AccountBalanceSnapshot
        > {
  $$AccountBalanceSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) => db.profiles
      .createAlias('account_balance_snapshots__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) => db.accounts
      .createAlias('account_balance_snapshots__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AccountBalanceSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountBalanceSnapshotsTable> {
  $$AccountBalanceSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountBalanceSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountBalanceSnapshotsTable> {
  $$AccountBalanceSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountBalanceSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountBalanceSnapshotsTable> {
  $$AccountBalanceSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountBalanceSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountBalanceSnapshotsTable,
          AccountBalanceSnapshot,
          $$AccountBalanceSnapshotsTableFilterComposer,
          $$AccountBalanceSnapshotsTableOrderingComposer,
          $$AccountBalanceSnapshotsTableAnnotationComposer,
          $$AccountBalanceSnapshotsTableCreateCompanionBuilder,
          $$AccountBalanceSnapshotsTableUpdateCompanionBuilder,
          (AccountBalanceSnapshot, $$AccountBalanceSnapshotsTableReferences),
          AccountBalanceSnapshot,
          PrefetchHooks Function({bool profileId, bool accountId})
        > {
  $$AccountBalanceSnapshotsTableTableManager(
    _$AppDatabase db,
    $AccountBalanceSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountBalanceSnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AccountBalanceSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AccountBalanceSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
              }) => AccountBalanceSnapshotsCompanion(
                id: id,
                profileId: profileId,
                accountId: accountId,
                date: date,
                balanceCents: balanceCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int accountId,
                required DateTime date,
                required int balanceCents,
              }) => AccountBalanceSnapshotsCompanion.insert(
                id: id,
                profileId: profileId,
                accountId: accountId,
                date: date,
                balanceCents: balanceCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountBalanceSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable:
                            $$AccountBalanceSnapshotsTableReferences
                                ._profileIdTable(db),
                        referencedColumn:
                            $$AccountBalanceSnapshotsTableReferences
                                ._profileIdTable(db)
                                .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable:
                            $$AccountBalanceSnapshotsTableReferences
                                ._accountIdTable(db),
                        referencedColumn:
                            $$AccountBalanceSnapshotsTableReferences
                                ._accountIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AccountBalanceSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountBalanceSnapshotsTable,
      AccountBalanceSnapshot,
      $$AccountBalanceSnapshotsTableFilterComposer,
      $$AccountBalanceSnapshotsTableOrderingComposer,
      $$AccountBalanceSnapshotsTableAnnotationComposer,
      $$AccountBalanceSnapshotsTableCreateCompanionBuilder,
      $$AccountBalanceSnapshotsTableUpdateCompanionBuilder,
      (AccountBalanceSnapshot, $$AccountBalanceSnapshotsTableReferences),
      AccountBalanceSnapshot,
      PrefetchHooks Function({bool profileId, bool accountId})
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  required int profileId,
  required String name,
  required GoalType type,
  required int targetAmountCents,
  Value<int> currentAmountCents,
  Value<DateTime?> targetDate,
  Value<int?> accountId,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> name,
  Value<GoalType> type,
  Value<int> targetAmountCents,
  Value<int> currentAmountCents,
  Value<DateTime?> targetDate,
  Value<int?> accountId,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('goals__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('goals__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalType, GoalType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentAmountCents => $composableBuilder(
    column: $table.currentAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAmountCents => $composableBuilder(
    column: $table.currentAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GoalType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentAmountCents => $composableBuilder(
    column: $table.currentAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, $$GoalsTableReferences),
          Goal,
          PrefetchHooks Function({bool profileId, bool accountId})
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<GoalType> type = const Value.absent(),
                Value<int> targetAmountCents = const Value.absent(),
                Value<int> currentAmountCents = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                type: type,
                targetAmountCents: targetAmountCents,
                currentAmountCents: currentAmountCents,
                targetDate: targetDate,
                accountId: accountId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required GoalType type,
                required int targetAmountCents,
                Value<int> currentAmountCents = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                type: type,
                targetAmountCents: targetAmountCents,
                currentAmountCents: currentAmountCents,
                targetDate: targetDate,
                accountId: accountId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$GoalsTableReferences._profileIdTable(
                          db,
                        ),
                        referencedColumn: $$GoalsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$GoalsTableReferences._accountIdTable(
                          db,
                        ),
                        referencedColumn: $$GoalsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, $$GoalsTableReferences),
      Goal,
      PrefetchHooks Function({bool profileId, bool accountId})
    >;
typedef $$PaycheckAllocationsTableCreateCompanionBuilder =
    PaycheckAllocationsCompanion Function({
      Value<int> id,
      required int profileId,
      required int paycheckId,
      required String target,
      required int amountCents,
      Value<int?> billId,
    });
typedef $$PaycheckAllocationsTableUpdateCompanionBuilder =
    PaycheckAllocationsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> paycheckId,
      Value<String> target,
      Value<int> amountCents,
      Value<int?> billId,
    });

final class $$PaycheckAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaycheckAllocationsTable,
          PaycheckAllocation
        > {
  $$PaycheckAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('paycheck_allocations__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaychecksTable _paycheckIdTable(_$AppDatabase db) => db.paychecks
      .createAlias('paycheck_allocations__paycheck_id__paychecks__id');

  $$PaychecksTableProcessedTableManager get paycheckId {
    final $_column = $_itemColumn<int>('paycheck_id')!;

    final manager = $$PaychecksTableTableManager(
      $_db,
      $_db.paychecks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paycheckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('paycheck_allocations__bill_id__bills__id');

  $$BillsTableProcessedTableManager? get billId {
    final $_column = $_itemColumn<int>('bill_id');
    if ($_column == null) return null;
    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaycheckAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaycheckAllocationsTable> {
  $$PaycheckAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaychecksTableFilterComposer get paycheckId {
    final $$PaychecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paycheckId,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableFilterComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaycheckAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaycheckAllocationsTable> {
  $$PaycheckAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaychecksTableOrderingComposer get paycheckId {
    final $$PaychecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paycheckId,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableOrderingComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableOrderingComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaycheckAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaycheckAllocationsTable> {
  $$PaycheckAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaychecksTableAnnotationComposer get paycheckId {
    final $$PaychecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paycheckId,
      referencedTable: $db.paychecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaychecksTableAnnotationComposer(
            $db: $db,
            $table: $db.paychecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaycheckAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaycheckAllocationsTable,
          PaycheckAllocation,
          $$PaycheckAllocationsTableFilterComposer,
          $$PaycheckAllocationsTableOrderingComposer,
          $$PaycheckAllocationsTableAnnotationComposer,
          $$PaycheckAllocationsTableCreateCompanionBuilder,
          $$PaycheckAllocationsTableUpdateCompanionBuilder,
          (PaycheckAllocation, $$PaycheckAllocationsTableReferences),
          PaycheckAllocation,
          PrefetchHooks Function({bool profileId, bool paycheckId, bool billId})
        > {
  $$PaycheckAllocationsTableTableManager(
    _$AppDatabase db,
    $PaycheckAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaycheckAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaycheckAllocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaycheckAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> paycheckId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int?> billId = const Value.absent(),
              }) => PaycheckAllocationsCompanion(
                id: id,
                profileId: profileId,
                paycheckId: paycheckId,
                target: target,
                amountCents: amountCents,
                billId: billId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int paycheckId,
                required String target,
                required int amountCents,
                Value<int?> billId = const Value.absent(),
              }) => PaycheckAllocationsCompanion.insert(
                id: id,
                profileId: profileId,
                paycheckId: paycheckId,
                target: target,
                amountCents: amountCents,
                billId: billId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaycheckAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, paycheckId = false, billId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable:
                                $$PaycheckAllocationsTableReferences
                                    ._profileIdTable(db),
                            referencedColumn:
                                $$PaycheckAllocationsTableReferences
                                    ._profileIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (paycheckId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.paycheckId,
                            referencedTable:
                                $$PaycheckAllocationsTableReferences
                                    ._paycheckIdTable(db),
                            referencedColumn:
                                $$PaycheckAllocationsTableReferences
                                    ._paycheckIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (billId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.billId,
                            referencedTable:
                                $$PaycheckAllocationsTableReferences
                                    ._billIdTable(db),
                            referencedColumn:
                                $$PaycheckAllocationsTableReferences
                                    ._billIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PaycheckAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaycheckAllocationsTable,
      PaycheckAllocation,
      $$PaycheckAllocationsTableFilterComposer,
      $$PaycheckAllocationsTableOrderingComposer,
      $$PaycheckAllocationsTableAnnotationComposer,
      $$PaycheckAllocationsTableCreateCompanionBuilder,
      $$PaycheckAllocationsTableUpdateCompanionBuilder,
      (PaycheckAllocation, $$PaycheckAllocationsTableReferences),
      PaycheckAllocation,
      PrefetchHooks Function({bool profileId, bool paycheckId, bool billId})
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required int profileId,
  required String name,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<String> name,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('tags__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetEntryTagsTable, List<BudgetEntryTag>>
  _budgetEntryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntryTags,
    aliasName: 'tags__id__budget_entry_tags__tag_id',
  );

  $$BudgetEntryTagsTableProcessedTableManager get budgetEntryTagsRefs {
    final manager = $$BudgetEntryTagsTableTableManager(
      $_db,
      $_db.budgetEntryTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetEntryTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetEntryTagsRefs(
    Expression<bool> Function($$BudgetEntryTagsTableFilterComposer f) f,
  ) {
    final $$BudgetEntryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntryTagsTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> budgetEntryTagsRefs<T extends Object>(
    Expression<T> Function($$BudgetEntryTagsTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool profileId, bool budgetEntryTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> profileId = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => TagsCompanion(id: id, profileId: profileId, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int profileId,
            required String name,
          }) => TagsCompanion.insert(id: id, profileId: profileId, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, budgetEntryTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetEntryTagsRefs) db.budgetEntryTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$TagsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$TagsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetEntryTagsRefs)
                        await $_getPrefetchedData<
                          Tag,
                          $TagsTable,
                          BudgetEntryTag
                        >(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._budgetEntryTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).budgetEntryTagsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.tagId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool profileId, bool budgetEntryTagsRefs})
    >;
typedef $$BudgetEntryTagsTableCreateCompanionBuilder =
    BudgetEntryTagsCompanion Function({
      Value<int> id,
      required int entryId,
      required int tagId,
    });
typedef $$BudgetEntryTagsTableUpdateCompanionBuilder =
    BudgetEntryTagsCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<int> tagId,
    });

final class $$BudgetEntryTagsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BudgetEntryTagsTable, BudgetEntryTag> {
  $$BudgetEntryTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BudgetEntriesTable _entryIdTable(_$AppDatabase db) => db.budgetEntries
      .createAlias('budget_entry_tags__entry_id__budget_entries__id');

  $$BudgetEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('budget_entry_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetEntryTagsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetEntryTagsTable> {
  $$BudgetEntryTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$BudgetEntriesTableFilterComposer get entryId {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntryTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetEntryTagsTable> {
  $$BudgetEntryTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$BudgetEntriesTableOrderingComposer get entryId {
    final $$BudgetEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntryTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetEntryTagsTable> {
  $$BudgetEntryTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$BudgetEntriesTableAnnotationComposer get entryId {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntryTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetEntryTagsTable,
          BudgetEntryTag,
          $$BudgetEntryTagsTableFilterComposer,
          $$BudgetEntryTagsTableOrderingComposer,
          $$BudgetEntryTagsTableAnnotationComposer,
          $$BudgetEntryTagsTableCreateCompanionBuilder,
          $$BudgetEntryTagsTableUpdateCompanionBuilder,
          (BudgetEntryTag, $$BudgetEntryTagsTableReferences),
          BudgetEntryTag,
          PrefetchHooks Function({bool entryId, bool tagId})
        > {
  $$BudgetEntryTagsTableTableManager(
    _$AppDatabase db,
    $BudgetEntryTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetEntryTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetEntryTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetEntryTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
              }) => BudgetEntryTagsCompanion(
                id: id,
                entryId: entryId,
                tagId: tagId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required int tagId,
              }) => BudgetEntryTagsCompanion.insert(
                id: id,
                entryId: entryId,
                tagId: tagId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetEntryTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$BudgetEntryTagsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$BudgetEntryTagsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$BudgetEntryTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$BudgetEntryTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetEntryTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetEntryTagsTable,
      BudgetEntryTag,
      $$BudgetEntryTagsTableFilterComposer,
      $$BudgetEntryTagsTableOrderingComposer,
      $$BudgetEntryTagsTableAnnotationComposer,
      $$BudgetEntryTagsTableCreateCompanionBuilder,
      $$BudgetEntryTagsTableUpdateCompanionBuilder,
      (BudgetEntryTag, $$BudgetEntryTagsTableReferences),
      BudgetEntryTag,
      PrefetchHooks Function({bool entryId, bool tagId})
    >;
typedef $$RecurringTransfersTableCreateCompanionBuilder =
    RecurringTransfersCompanion Function({
      Value<int> id,
      required int profileId,
      required String name,
      required int fromAccountId,
      required int toAccountId,
      required int amountCents,
      required PayFrequency frequency,
      required DateTime anchorDate,
      Value<bool> active,
    });
typedef $$RecurringTransfersTableUpdateCompanionBuilder =
    RecurringTransfersCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> name,
      Value<int> fromAccountId,
      Value<int> toAccountId,
      Value<int> amountCents,
      Value<PayFrequency> frequency,
      Value<DateTime> anchorDate,
      Value<bool> active,
    });

final class $$RecurringTransfersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringTransfersTable,
          RecurringTransfer
        > {
  $$RecurringTransfersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('recurring_transfers__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _fromAccountIdTable(_$AppDatabase db) => db.accounts
      .createAlias('recurring_transfers__from_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get fromAccountId {
    final $_column = $_itemColumn<int>('from_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _toAccountIdTable(_$AppDatabase db) => db.accounts
      .createAlias('recurring_transfers__to_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get toAccountId {
    final $_column = $_itemColumn<int>('to_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransferLogsTable, List<TransferLog>>
  _transferLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transferLogs,
    aliasName: 'recurring_transfers__id__transfer_logs__transfer_id',
  );

  $$TransferLogsTableProcessedTableManager get transferLogsRefs {
    final manager = $$TransferLogsTableTableManager(
      $_db,
      $_db.transferLogs,
    ).filter((f) => f.transferId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transferLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurringTransfersTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransfersTable> {
  $$RecurringTransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PayFrequency, PayFrequency, String>
  get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get fromAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get toAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transferLogsRefs(
    Expression<bool> Function($$TransferLogsTableFilterComposer f) f,
  ) {
    final $$TransferLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transferLogs,
      getReferencedColumn: (t) => t.transferId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransferLogsTableFilterComposer(
            $db: $db,
            $table: $db.transferLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringTransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransfersTable> {
  $$RecurringTransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get fromAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get toAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringTransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransfersTable> {
  $$RecurringTransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PayFrequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get fromAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get toAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transferLogsRefs<T extends Object>(
    Expression<T> Function($$TransferLogsTableAnnotationComposer a) f,
  ) {
    final $$TransferLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transferLogs,
      getReferencedColumn: (t) => t.transferId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransferLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.transferLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringTransfersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringTransfersTable,
          RecurringTransfer,
          $$RecurringTransfersTableFilterComposer,
          $$RecurringTransfersTableOrderingComposer,
          $$RecurringTransfersTableAnnotationComposer,
          $$RecurringTransfersTableCreateCompanionBuilder,
          $$RecurringTransfersTableUpdateCompanionBuilder,
          (RecurringTransfer, $$RecurringTransfersTableReferences),
          RecurringTransfer,
          PrefetchHooks Function({
            bool profileId,
            bool fromAccountId,
            bool toAccountId,
            bool transferLogsRefs,
          })
        > {
  $$RecurringTransfersTableTableManager(
    _$AppDatabase db,
    $RecurringTransfersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringTransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringTransfersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> fromAccountId = const Value.absent(),
                Value<int> toAccountId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<PayFrequency> frequency = const Value.absent(),
                Value<DateTime> anchorDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => RecurringTransfersCompanion(
                id: id,
                profileId: profileId,
                name: name,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amountCents: amountCents,
                frequency: frequency,
                anchorDate: anchorDate,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required int fromAccountId,
                required int toAccountId,
                required int amountCents,
                required PayFrequency frequency,
                required DateTime anchorDate,
                Value<bool> active = const Value.absent(),
              }) => RecurringTransfersCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amountCents: amountCents,
                frequency: frequency,
                anchorDate: anchorDate,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringTransfersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                fromAccountId = false,
                toAccountId = false,
                transferLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transferLogsRefs) db.transferLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$RecurringTransfersTableReferences
                                ._profileIdTable(db),
                            referencedColumn:
                                $$RecurringTransfersTableReferences
                                    ._profileIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (fromAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fromAccountId,
                            referencedTable: $$RecurringTransfersTableReferences
                                ._fromAccountIdTable(db),
                            referencedColumn:
                                $$RecurringTransfersTableReferences
                                    ._fromAccountIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (toAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.toAccountId,
                            referencedTable: $$RecurringTransfersTableReferences
                                ._toAccountIdTable(db),
                            referencedColumn:
                                $$RecurringTransfersTableReferences
                                    ._toAccountIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transferLogsRefs)
                        await $_getPrefetchedData<
                          RecurringTransfer,
                          $RecurringTransfersTable,
                          TransferLog
                        >(
                          currentTable: table,
                          referencedTable: $$RecurringTransfersTableReferences
                              ._transferLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurringTransfersTableReferences(
                                db,
                                table,
                                p0,
                              ).transferLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transferId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringTransfersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringTransfersTable,
      RecurringTransfer,
      $$RecurringTransfersTableFilterComposer,
      $$RecurringTransfersTableOrderingComposer,
      $$RecurringTransfersTableAnnotationComposer,
      $$RecurringTransfersTableCreateCompanionBuilder,
      $$RecurringTransfersTableUpdateCompanionBuilder,
      (RecurringTransfer, $$RecurringTransfersTableReferences),
      RecurringTransfer,
      PrefetchHooks Function({
        bool profileId,
        bool fromAccountId,
        bool toAccountId,
        bool transferLogsRefs,
      })
    >;
typedef $$TransferLogsTableCreateCompanionBuilder =
    TransferLogsCompanion Function({
      Value<int> id,
      required int profileId,
      required int transferId,
      required DateTime date,
      required int amountCents,
    });
typedef $$TransferLogsTableUpdateCompanionBuilder =
    TransferLogsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> transferId,
      Value<DateTime> date,
      Value<int> amountCents,
    });

final class $$TransferLogsTableReferences
    extends BaseReferences<_$AppDatabase, $TransferLogsTable, TransferLog> {
  $$TransferLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('transfer_logs__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecurringTransfersTable _transferIdTable(_$AppDatabase db) => db
      .recurringTransfers
      .createAlias('transfer_logs__transfer_id__recurring_transfers__id');

  $$RecurringTransfersTableProcessedTableManager get transferId {
    final $_column = $_itemColumn<int>('transfer_id')!;

    final manager = $$RecurringTransfersTableTableManager(
      $_db,
      $_db.recurringTransfers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transferIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransferLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TransferLogsTable> {
  $$TransferLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringTransfersTableFilterComposer get transferId {
    final $$RecurringTransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.recurringTransfers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringTransfersTableFilterComposer(
            $db: $db,
            $table: $db.recurringTransfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransferLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransferLogsTable> {
  $$TransferLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringTransfersTableOrderingComposer get transferId {
    final $$RecurringTransfersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.recurringTransfers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringTransfersTableOrderingComposer(
            $db: $db,
            $table: $db.recurringTransfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransferLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransferLogsTable> {
  $$TransferLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringTransfersTableAnnotationComposer get transferId {
    final $$RecurringTransfersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.transferId,
          referencedTable: $db.recurringTransfers,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransfersTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringTransfers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$TransferLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransferLogsTable,
          TransferLog,
          $$TransferLogsTableFilterComposer,
          $$TransferLogsTableOrderingComposer,
          $$TransferLogsTableAnnotationComposer,
          $$TransferLogsTableCreateCompanionBuilder,
          $$TransferLogsTableUpdateCompanionBuilder,
          (TransferLog, $$TransferLogsTableReferences),
          TransferLog,
          PrefetchHooks Function({bool profileId, bool transferId})
        > {
  $$TransferLogsTableTableManager(_$AppDatabase db, $TransferLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransferLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransferLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransferLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> transferId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
              }) => TransferLogsCompanion(
                id: id,
                profileId: profileId,
                transferId: transferId,
                date: date,
                amountCents: amountCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int transferId,
                required DateTime date,
                required int amountCents,
              }) => TransferLogsCompanion.insert(
                id: id,
                profileId: profileId,
                transferId: transferId,
                date: date,
                amountCents: amountCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransferLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, transferId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$TransferLogsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$TransferLogsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (transferId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transferId,
                        referencedTable: $$TransferLogsTableReferences
                            ._transferIdTable(db),
                        referencedColumn: $$TransferLogsTableReferences
                            ._transferIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransferLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransferLogsTable,
      TransferLog,
      $$TransferLogsTableFilterComposer,
      $$TransferLogsTableOrderingComposer,
      $$TransferLogsTableAnnotationComposer,
      $$TransferLogsTableCreateCompanionBuilder,
      $$TransferLogsTableUpdateCompanionBuilder,
      (TransferLog, $$TransferLogsTableReferences),
      TransferLog,
      PrefetchHooks Function({bool profileId, bool transferId})
    >;
typedef $$TransactionSplitsTableCreateCompanionBuilder =
    TransactionSplitsCompanion Function({
      Value<int> id,
      required int profileId,
      required int entryId,
      required String category,
      required int amountCents,
    });
typedef $$TransactionSplitsTableUpdateCompanionBuilder =
    TransactionSplitsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> entryId,
      Value<String> category,
      Value<int> amountCents,
    });

final class $$TransactionSplitsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionSplitsTable,
          TransactionSplit
        > {
  $$TransactionSplitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('transaction_splits__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BudgetEntriesTable _entryIdTable(_$AppDatabase db) => db.budgetEntries
      .createAlias('transaction_splits__entry_id__budget_entries__id');

  $$BudgetEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTable> {
  $$TransactionSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetEntriesTableFilterComposer get entryId {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTable> {
  $$TransactionSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetEntriesTableOrderingComposer get entryId {
    final $$BudgetEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTable> {
  $$TransactionSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetEntriesTableAnnotationComposer get entryId {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionSplitsTable,
          TransactionSplit,
          $$TransactionSplitsTableFilterComposer,
          $$TransactionSplitsTableOrderingComposer,
          $$TransactionSplitsTableAnnotationComposer,
          $$TransactionSplitsTableCreateCompanionBuilder,
          $$TransactionSplitsTableUpdateCompanionBuilder,
          (TransactionSplit, $$TransactionSplitsTableReferences),
          TransactionSplit,
          PrefetchHooks Function({bool profileId, bool entryId})
        > {
  $$TransactionSplitsTableTableManager(
    _$AppDatabase db,
    $TransactionSplitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionSplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionSplitsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
              }) => TransactionSplitsCompanion(
                id: id,
                profileId: profileId,
                entryId: entryId,
                category: category,
                amountCents: amountCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int entryId,
                required String category,
                required int amountCents,
              }) => TransactionSplitsCompanion.insert(
                id: id,
                profileId: profileId,
                entryId: entryId,
                category: category,
                amountCents: amountCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionSplitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$TransactionSplitsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$TransactionSplitsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$TransactionSplitsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$TransactionSplitsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionSplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionSplitsTable,
      TransactionSplit,
      $$TransactionSplitsTableFilterComposer,
      $$TransactionSplitsTableOrderingComposer,
      $$TransactionSplitsTableAnnotationComposer,
      $$TransactionSplitsTableCreateCompanionBuilder,
      $$TransactionSplitsTableUpdateCompanionBuilder,
      (TransactionSplit, $$TransactionSplitsTableReferences),
      TransactionSplit,
      PrefetchHooks Function({bool profileId, bool entryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$BillPaymentsTableTableManager get billPayments =>
      $$BillPaymentsTableTableManager(_db, _db.billPayments);
  $$CreditScoreSnapshotsTableTableManager get creditScoreSnapshots =>
      $$CreditScoreSnapshotsTableTableManager(_db, _db.creditScoreSnapshots);
  $$PaycheckSchedulesTableTableManager get paycheckSchedules =>
      $$PaycheckSchedulesTableTableManager(_db, _db.paycheckSchedules);
  $$PaychecksTableTableManager get paychecks =>
      $$PaychecksTableTableManager(_db, _db.paychecks);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db, _db.importBatches);
  $$BudgetEntriesTableTableManager get budgetEntries =>
      $$BudgetEntriesTableTableManager(_db, _db.budgetEntries);
  $$BudgetTargetsTableTableManager get budgetTargets =>
      $$BudgetTargetsTableTableManager(_db, _db.budgetTargets);
  $$CategoryRulesTableTableManager get categoryRules =>
      $$CategoryRulesTableTableManager(_db, _db.categoryRules);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$NetWorthSnapshotsTableTableManager get netWorthSnapshots =>
      $$NetWorthSnapshotsTableTableManager(_db, _db.netWorthSnapshots);
  $$AccountBalanceSnapshotsTableTableManager get accountBalanceSnapshots =>
      $$AccountBalanceSnapshotsTableTableManager(
        _db,
        _db.accountBalanceSnapshots,
      );
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$PaycheckAllocationsTableTableManager get paycheckAllocations =>
      $$PaycheckAllocationsTableTableManager(_db, _db.paycheckAllocations);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$BudgetEntryTagsTableTableManager get budgetEntryTags =>
      $$BudgetEntryTagsTableTableManager(_db, _db.budgetEntryTags);
  $$RecurringTransfersTableTableManager get recurringTransfers =>
      $$RecurringTransfersTableTableManager(_db, _db.recurringTransfers);
  $$TransferLogsTableTableManager get transferLogs =>
      $$TransferLogsTableTableManager(_db, _db.transferLogs);
  $$TransactionSplitsTableTableManager get transactionSplits =>
      $$TransactionSplitsTableTableManager(_db, _db.transactionSplits);
}
