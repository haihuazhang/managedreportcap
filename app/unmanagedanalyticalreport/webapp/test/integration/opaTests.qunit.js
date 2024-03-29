sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'unmanagedanalyticalreport/test/integration/FirstJourney',
		'unmanagedanalyticalreport/test/integration/pages/OrdersUnmanagedList',
		'unmanagedanalyticalreport/test/integration/pages/OrdersUnmanagedObjectPage'
    ],
    function(JourneyRunner, opaJourney, OrdersUnmanagedList, OrdersUnmanagedObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('unmanagedanalyticalreport') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheOrdersUnmanagedList: OrdersUnmanagedList,
					onTheOrdersUnmanagedObjectPage: OrdersUnmanagedObjectPage
                }
            },
            opaJourney.run
        );
    }
);