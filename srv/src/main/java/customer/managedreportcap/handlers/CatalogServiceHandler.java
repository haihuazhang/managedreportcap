package customer.managedreportcap.handlers;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.sap.cds.Result;
import com.sap.cds.ResultBuilder;
import com.sap.cds.ql.CQL;
import com.sap.cds.ql.Predicate;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.StructuredType;
import com.sap.cds.ql.cqn.AnalysisResult;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.ql.cqn.CqnPredicate;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.ql.cqn.CqnStructuredTypeRef;
import com.sap.cds.ql.cqn.Modifier;
import com.sap.cds.reflect.CdsEntity;
import com.sap.cds.reflect.CdsModel;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
// import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;

import cds.gen.catalogservice.CatalogService_;
import cds.gen.catalogservice.OrderUnmanaged;
import cds.gen.catalogservice.OrderUnmanaged_;
import cds.gen.catalogservice.Orders;
import cds.gen.catalogservice.Orders_;
// import cds.gen.catalogservice.OrdersUnmanaged_;
// import cds.gen.managedreport.OrderUnmanaged_;
// import cds.gen.managedreport.Orders_;
import customer.managedreportcap.utils.CheckDataVisitor;
import customer.managedreportcap.utils.UnmanagedReportUtils;
import cds.gen.catalogservice.AllEntities;
import cds.gen.catalogservice.AllEntities_;
// import cds.gen.catalogservice.Books;

@Component
@ServiceName(CatalogService_.CDS_NAME)
public class CatalogServiceHandler implements EventHandler {

	@Autowired
	CdsModel cdsModel;

	@Autowired
	@Qualifier(CatalogService_.CDS_NAME)
	CqnService catalogService;

	@On(event = CqnService.EVENT_READ, entity = AllEntities_.CDS_NAME)
	public void getAllEntities(CdsReadEventContext context) {

		List<AllEntities> results = new ArrayList<AllEntities>();

		// get SELECT CQN object
		CqnSelect cqnSelect = context.getCqn();

		/** CqnVisitor */
		// filter
		// sort

		// get data and filter
		cdsModel.services().forEach((service) -> {
			String serviceName = service.getName();
			Stream<CdsEntity> entities = service.entities();
			entities.forEach((entity) -> {

				AllEntities entityResult = AllEntities.create();
				entityResult.setEntityName(entity.getName());
				entityResult.setDescription(entity.getAnnotationValue("title", null));
				entityResult.setService(serviceName);

				// filter
				CheckDataVisitor checkDataVisitor = new CheckDataVisitor(entityResult);
				// cqnSelect.where().get().accept(checkDataVisitor);
				try {
					CqnPredicate cqnPredicate = cqnSelect.where().get();
					cqnPredicate.accept(checkDataVisitor);
					if (checkDataVisitor.matches()) {
						results.add(entityResult);
					}
				} catch (Exception e) {
					// No where conditions
					results.add(entityResult);
				}

			});
		});

		// sort
		UnmanagedReportUtils.sort(cqnSelect.orderBy(), results);

		// inlineCount
		long inlineCount = results.size();

		/** CqnAnalyzer */
		// CqnAnalyzer
		// CqnAnalyzer cqnAnalyzer = CqnAnalyzer.create(cdsModel);
		// CqnStructuredTypeRef cqnStructuredTypeRef = context.getCqn().ref();

		/** Top/Skip */
		// top skip
		// var context.getCqn().top();
		// context.getCqn().skip();
		List<? extends Map<String, ?>> results2 = UnmanagedReportUtils.getTopSkip(context.getCqn().top(),
				context.getCqn().skip(), results);

		Result result = ResultBuilder.selectedRows(results2).inlineCount(inlineCount).result();

		context.setResult(result);

	}

	@On(event = CqnService.EVENT_READ, entity = OrderUnmanaged_.CDS_NAME)
	public void getUnmanagedOrder(CdsReadEventContext context) {
		// CqnSelect select = context.getCqn();

		// CqnSelect selectCopy = CQL.copy(select, new Modifier() {
		// @Override
		// public CqnStructuredTypeRef ref(CqnStructuredTypeRef ref) {
		// // return CQL.to(Orders_.CDS_NAME).asRef();
		// return CQL.entity(Orders_.class).asRef();
		// }
		// });
		// Result result = catalogService.run(selectCopy);
		// context.setResult(result);

		List<OrderUnmanaged> resultList = new ArrayList<OrderUnmanaged>();

		// get SELECT CQN object
		CqnSelect cqnSelect = context.getCqn();

		CqnSelect select = Select.from(Orders_.class);
		Result result = catalogService.run(select);
		result.forEach((row) -> {
			OrderUnmanaged resultRow = OrderUnmanaged.create();

			resultRow.setOrderNo(row.get("OrderNo").toString());
			resultRow.setBuyer(row.get("buyer").toString());
			resultRow.setCurrencyCode(row.get("currency_code").toString());
			resultRow.setTotal(new BigDecimal(row.get("total").toString()));

			// filter
			CheckDataVisitor checkDataVisitor = new CheckDataVisitor(resultRow);
			try {
				CqnPredicate cqnPredicate = cqnSelect.where().get();
				cqnPredicate.accept(checkDataVisitor);
				if (checkDataVisitor.matches()) {
					resultList.add(resultRow);
				}
			} catch (Exception e) {
				// No where conditions
				resultList.add(resultRow);
			}
		});

		// check if param has $apply

		// set aggregation

		if (context.getParameterInfo().getQueryParameter("$apply") != null) {

		} else {
			// sort
			UnmanagedReportUtils.sort(cqnSelect.orderBy(), resultList);

			// inlineCount
			long inlineCount = resultList.size();
			List<? extends Map<String, ?>> results2 = UnmanagedReportUtils.getTopSkip(context.getCqn().top(),
					context.getCqn().skip(), resultList);

			Result resultFinal = ResultBuilder.selectedRows(results2).inlineCount(inlineCount).result();

			context.setResult(resultFinal);
		}

	}

}