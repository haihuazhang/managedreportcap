using CatalogService as service from '../../srv/cat-service';

// annotate service.Books with @(
//     UI.LineItem : [
//         {
//             $Type : 'UI.DataField',
//             Label : 'title',
//             Value : title,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'descr',
//             Value : descr,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'genre_ID',
//             Value : genre_ID,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'stock',
//             Value : stock,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'price',
//             Value : price,
//         },
//     ]
// );
// annotate service.Books with @(
//     UI.FieldGroup #GeneratedGroup1 : {
//         $Type : 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'title',
//                 Value : title,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'descr',
//                 Value : descr,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'genre_ID',
//                 Value : genre_ID,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'stock',
//                 Value : stock,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'price',
//                 Value : price,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'currency_code',
//                 Value : currency_code,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'rating',
//                 Value : rating,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'ISBN',
//                 Value : ISBN,
//             },
//         ],
//     },
//     UI.Facets : [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID : 'GeneratedFacet1',
//             Label : 'General Information',
//             Target : '@UI.FieldGroup#GeneratedGroup1',
//         },
//     ]
// );
