namespace managedreport;

using {
  Currency,
  sap,
  managed,
  User,
  cuid
} from '@sap/cds/common';


type TechnicalBooleanFlag : Boolean @(
  UI.Hidden,
  Core.Computed
);

@fiori.draft.enabled
entity Books : cuid, managed {
  title        : localized String(111);
  descr        : localized String(1111);
  // author       : Association to Authors;
  author_ID    : UUID;
  genre        : Association to Genres;
  stock        : Integer;
  price        : Decimal(9, 2);
  currency     : Currency;
  rating       : Decimal(2, 1);
  ISBN         : String(50);
  isReviewable : TechnicalBooleanFlag not null default true;
  author       : Association to Authors
                   on author.ID = author_ID;
}


entity Authors : cuid, managed {
  @assert.format: '^\p{Lu}.*' // assert that name starts with a capital letter
  name         : String(111);
  dateOfBirth  : Date;
  dateOfDeath  : Date;
  placeOfBirth : String;
  placeOfDeath : String;
  books        : Association to many Books
                   on books.author = $self;
}


// annotations for Data Privacy
annotate Authors with
@PersonalData                      : {
  DataSubjectRole: 'Author',
  EntitySemantics: 'DataSubject'
} {
  ID   @PersonalData.FieldSemantics: 'DataSubjectID';
  name @PersonalData.IsPotentiallySensitive;
}

/**
 * Hierarchically organized Code List for Genres
 */
entity Genres : sap.common.CodeList {
  key ID       : Integer;
      parent   : Association to Genres;
      children : Composition of many Genres
                   on children.parent = $self;
}


entity Orders : cuid, managed {
  OrderNo  : String        @title: '{i18n>OrderNumber}'  @mandatory; //> readable key
  Items    : Composition of many OrderItems
               on Items.parent = $self;
  buyer    : User;

  @Semantics.amount.currencyCode: 'currency_code'
  total    : Decimal(9, 2) @readonly;

  @Semantics.currencyCode
  currency : Currency;
}

entity OrderItems : cuid {
  parent   : Association to Orders;
  book     : Association to Books  @mandatory  @assert.target;
  quantity : Integer;
  @Semantics.amount.currencyCode: 'currency_code'
  amount   : Decimal(9, 2);
  @Semantics.currencyCode
  currency : Currency;
}
