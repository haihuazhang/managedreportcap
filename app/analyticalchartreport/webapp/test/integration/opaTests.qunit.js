sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'analyticalchartreport/test/integration/FirstJourney',
		'analyticalchartreport/test/integration/pages/OrderItemsList',
		'analyticalchartreport/test/integration/pages/OrderItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, OrderItemsList, OrderItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('analyticalchartreport') + '/index.html'
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