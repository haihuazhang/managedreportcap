sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'alpreport/test/integration/FirstJourney',
		'alpreport/test/integration/pages/OrderItemsList',
		'alpreport/test/integration/pages/OrderItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, OrderItemsList, OrderItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('alpreport') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheOrderItemsList: OrderItemsList,
					onTheOrderItemsObjectPage: OrderItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);