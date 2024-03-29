using CatalogService as service from '../../srv/cat-service';

annotate service.AllEntities with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'entityName',
            Value : entityName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : Description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'service',
            Value : service,
        },
        {
            $Type : 'UI.DataField',
            Label : 'namespace',
            Value : namespace,
        },
    ]
);
annotate service.AllEntities with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'entityName',
                Value : entityName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : Description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'service',
                Value : service,
            },
            {
                $Type : 'UI.DataField',
                Label : 'namespace',
                Value : namespace,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
    ]
);
