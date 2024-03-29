using managedreport from '../db/data-model';

service CatalogService {
    @readonly
    entity Books           as projection on managedreport.Books;

    @readonly
    @title: 'Authors'
    entity Authors         as projection on managedreport.Authors;

    @readonly
    @title: 'Orders'
    entity Orders          as projection on managedreport.Orders;

    @readonly
    @title: 'Order Items'
    entity OrderItems      as projection on managedreport.OrderItems;

    @readonly
    @title: 'All Entity Information'
    entity AllEntities     as projection on managedreport.AllEntities;

    @readonly
    // @cds.persistence.skip
    entity OrderUnmanaged as projection on managedreport.OrderUnmanaged;
}

service QueryService {
    @readonly
    entity AllEntities2    as projection on managedreport.AllEntities;

    // entity OrderQuery as select from managedreport.Orders{
    //     ID,
    //     OrderNo,
    //     buyer,
    //     total,
    //     currency,
    //     sum(Items.quantity) as SumQuantity
    // } group by ID,OrderNo,buyer,total,currency;

    entity AllEntities3    as projection on managedreport.AllEntities;
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
        LineItem                     : [
            {Value: ID},
            {Value: book_ID},
            {Value: quantity},
            {Value: amount}

        ],
        SelectionFields              : [book_ID],
        PresentationVariant #table   : {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem'],
            Text          : 'Table'
        },

        Chart #chart1                : {
            $Type     : 'UI.ChartDefinitionType',
            ChartType : #Column,
            Dimensions: [book_ID],
            Measures  : [
                quantity,
                amount
            ]
        },
        Chart #chart2                : {
            $Type     : 'UI.ChartDefinitionType',
            ChartType : #Bar,
            Dimensions: [book_ID],
            Measures  : [quantity
                                 // amount
                        ]
        },
        Chart #sumQtyChart           : {
            $Type    : 'UI.ChartDefinitionType',
            ChartType: #Bar,
            // Dimensions: [book_ID],
            Measures : [quantity]
        },
        PresentationVariant #chart   : {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.Chart#chart1', ],
            Text          : 'Chart'
        },
        PresentationVariant #sumQtyPV: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: [
                             // '@UI.LineItem',
                            '@UI.Chart#sumQtyChart'],
            Text          : 'Qty Sum'
        },
        DataPoint #sumQtyDP          : {
            $Type: 'UI.DataPointType',
            Value: quantity
        },
        KPI #KPIQuantity             : {
            $Type           : 'UI.KPIType',
            SelectionVariant: {
                $Type        : 'UI.SelectionVariantType',
                SelectOptions: [{
                    PropertyName: book_ID,
                    Ranges      : [{
                        Sign  : #I,
                        Option: #NE,
                        Low   : ''
                    }]
                }]
            },
            DataPoint       : ![@UI.DataPoint#sumQtyDP],
            Detail          : {
                DefaultPresentationVariant: ![@UI.PresentationVariant#sumQtyPV],
                SemanticObject            : 'test',
                Action                    : 'display'
            }
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
            ],
            Transformations       : [
                'aggregate',
                // 'topcount',
                // 'bottomcount',
                'identity',
                'concat',
                'groupby',
                'filter',
                'search'
            ]
        },
        CustomAggregate #amount  : 'Edm.Decimal',
        CustomAggregate #quantity: 'Edm.Int'
    },
    Analytics  : {
        AggregatedProperty #quantity: {
            $Type               : 'Analytics.AggregatedPropertyType',
            Name                : 'SumQTY',
            AggregationMethod   : 'sum',
            AggregatableProperty: quantity
        },
        AggregatedProperty #amount  : {
            $Type               : 'Analytics.AggregatedPropertyType',
            Name                : 'SumAmount',
            AggregationMethod   : 'sum',
            AggregatableProperty: amount
        }
    }
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


annotate CatalogService.OrderUnmanaged with @(
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
