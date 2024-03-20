using managedreport from '../db/data-model';

service CatalogService {
    @readonly
    entity Books      as projection on managedreport.Books;

    @readonly
    entity Authors    as projection on managedreport.Authors;

    @readonly
    entity Orders     as projection on managedreport.Orders;

    @readonly
    entity OrderItems as projection on managedreport.OrderItems;
}


annotate CatalogService.Books with @UI: {
    LineItem       : [
        {Value: title},
        {Value: descr},
        {Value: genre_ID},
        {Value: author_ID},
        {Value: stock},
        {Value: price},
        {Value: currency_code}
    ],
    SelectionFields: [
        title,
        stock,
        genre_ID,
        price,
        currency_code,
        author_ID
    ],
};

annotate CatalogService.Books with {
    author_ID @Common: {
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Authors',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: 'author_ID',
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                },
            ]
        },
        Text           : author.name,
        TextArrangement: #TextOnly,
    }
};


// annotate CatalogService.Books with ;

annotate CatalogService.Orders with @(
    UI         : {
        LineItem       : [
            {Value: OrderNo},
            {Value: buyer},
            {Value: total}
        ],
        SelectionFields: [
            OrderNo,
            buyer
        ],
    },
    Aggregation: {
        ApplySupported        : {
            $Type              : 'Aggregation.ApplySupportedType',
            GroupableProperties: [
                buyer,
                OrderNo
            ]
        },
        CustomAggregate #total: 'Edm.Decimal'
    }
)


{
    total  @Analytics.Measure  @Aggregation.default: #SUM  @Measures.ISOCurrency: currency_code
};


annotate CatalogService.OrderItems with @(
    UI         : {
        LineItem                  : [
            {Value: ID},
            {Value: book_ID},
            {Value: quantity},
            {Value: amount}

        ],
        SelectionFields           : [book_ID],
        PresentationVariant #table: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem'],
            Text          : 'Table'
        },

        Chart #chart1             : {
            $Type     : 'UI.ChartDefinitionType',
            ChartType : #Column,
            Dimensions: [book_ID],
            Measures  : [
                quantity,
                amount
            ]
        },
        PresentationVariant #chart: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.Chart#chart1'],
            Text          : 'Chart'
        }
    },
    Aggregation: {
        ApplySupported           : {
            $Type                 : 'Aggregation.ApplySupportedType',
            GroupableProperties   : [
                ID,
                book_ID
            ],
            AggregatableProperties: [
                {Property: quantity},
                {Property: amount}
            ]
        },
        CustomAggregate #amount  : 'Edm.Decimal',
        CustomAggregate #quantity: 'Edm.Int'
    }
    // Analytics: {
    //     // AggregatedProperty : {
    //     //     $Type : 'Analytics.AggregatedPropertyType',
    //     //     Name : 'SumQTY',
    //     //     AggregationMethod : 'sum',
    //     //     AggregatableProperty : quantity
    //     // },
    //     // AnalyticalContext : [
    //     //     {
    //     //         $Type : 'Analytics.AnalyticalContextType',
    //     //         Measure: true,
                
    //     //     },
    //     // ],
    // }
) {
    amount    @Analytics.Measure        @Aggregation.default: #SUM  @Measures.ISOCurrency: currency_code;
    quantity  @Analytics.Measure        @Aggregation.default: #SUM;
    book      @Common.Text: book.title  @Common.ValueList   : {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Books',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: book_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'title'
            },
        ]
    }
};

annotate CatalogService.Books with {
    ID @(Common: {Text: title})
};
