// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ppln_segment_status_g.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetPplnSegmentStatusGCollection on Isar {
  IsarCollection<int, PplnSegmentStatusG> get pplnSegmentStatusGs =>
      this.collection();
}

const PplnSegmentStatusGSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'PplnSegmentStatusG',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'pplnSegmentStatus',
        type: IsarType.json,
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, PplnSegmentStatusG>(
    serialize: serializePplnSegmentStatusG,
    deserialize: deserializePplnSegmentStatusG,
    deserializeProperty: deserializePplnSegmentStatusGProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializePplnSegmentStatusG(IsarWriter writer, PplnSegmentStatusG object) {
  IsarCore.writeString(writer, 1, isarJsonEncode(object.pplnSegmentStatus));
  return object.id;
}

@isarProtected
PplnSegmentStatusG deserializePplnSegmentStatusG(IsarReader reader) {
  final dynamic _pplnSegmentStatus;
  {
    final json = isarJsonDecode(IsarCore.readString(reader, 1) ?? 'null');
    if (json is Map<String, dynamic>) {
      _pplnSegmentStatus = PplnSegmentStatus.fromJson(json);
    } else {
      _pplnSegmentStatus = PplnSegmentStatus(
        recordStatus: RecordStatus(
          id: -9223372036854775808,
          filePath: '',
          startTime:
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal(),
        ),
      );
    }
  }
  final object = PplnSegmentStatusG(
    _pplnSegmentStatus,
  );
  return object;
}

@isarProtected
dynamic deserializePplnSegmentStatusGProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      {
        final json = isarJsonDecode(IsarCore.readString(reader, 1) ?? 'null');
        if (json is Map<String, dynamic>) {
          return PplnSegmentStatus.fromJson(json);
        } else {
          return PplnSegmentStatus(
            recordStatus: RecordStatus(
              id: -9223372036854775808,
              filePath: '',
              startTime:
                  DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal(),
            ),
          );
        }
      }
    case 0:
      return IsarCore.readId(reader);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

extension PplnSegmentStatusGQueryFilter
    on QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QFilterCondition> {
  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterFilterCondition>
      idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterFilterCondition>
      idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterFilterCondition>
      idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension PplnSegmentStatusGQueryObject
    on QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QFilterCondition> {}

extension PplnSegmentStatusGQuerySortBy
    on QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QSortBy> {
  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      sortByPplnSegmentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      sortByPplnSegmentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }
}

extension PplnSegmentStatusGQuerySortThenBy
    on QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QSortThenBy> {
  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      thenByPplnSegmentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      thenByPplnSegmentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }
}

extension PplnSegmentStatusGQueryWhereDistinct
    on QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QDistinct> {
  QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QAfterDistinct>
      distinctByPplnSegmentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }
}

extension PplnSegmentStatusGQueryProperty1
    on QueryBuilder<PplnSegmentStatusG, PplnSegmentStatusG, QProperty> {
  QueryBuilder<PplnSegmentStatusG, dynamic, QAfterProperty>
      pplnSegmentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PplnSegmentStatusG, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }
}

extension PplnSegmentStatusGQueryProperty2<R>
    on QueryBuilder<PplnSegmentStatusG, R, QAfterProperty> {
  QueryBuilder<PplnSegmentStatusG, (R, dynamic), QAfterProperty>
      pplnSegmentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PplnSegmentStatusG, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }
}

extension PplnSegmentStatusGQueryProperty3<R1, R2>
    on QueryBuilder<PplnSegmentStatusG, (R1, R2), QAfterProperty> {
  QueryBuilder<PplnSegmentStatusG, (R1, R2, dynamic), QOperations>
      pplnSegmentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PplnSegmentStatusG, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }
}
