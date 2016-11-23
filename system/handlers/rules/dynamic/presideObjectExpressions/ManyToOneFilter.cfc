/**
 * Dynamic expression handler for checking whether or not a preside object
 * many-to-one property's value matches the selected related records
 *
 */
component {

	property name="presideObjectService" inject="presideObjectService";
	property name="filterService"        inject="rulesEngineFilterService";

	private boolean function evaluateExpression(
		  required string  objectName
		, required string  propertyName
		,          string  value = ""
	) {
		var recordId = payload[ objectName ].id ?: "";

		return presideObjectService.dataExists(
			  objectName   = objectName
			, id           = recordId
			, extraFilters = prepareFilters( argumentCollection=arguments )
		);
	}

	private array function prepareFilters(
		  required string  objectName
		, required string  propertyName
		, required string  relatedTo
		,          string  filterPrefix = ""
		,          string  value        = ""
	){
		var expressionArray = filterService.getExpressionArrayForSavedFilter( arguments.value );
		if ( !expressionArray.len() ) {
			return [];
		}

		return [ filterService.prepareFilter(
			  objectName      = arguments.relatedTo
			, expressionArray = expressionArray
			, filterPrefix    = filterPrefix.listAppend( arguments.propertyName, "$" )
		) ];
	}

	private string function getLabel(
		  required string  objectName
		, required string  propertyName
		, required string  relatedTo
	) {
		var relatedToBaseUri    = presideObjectService.getResourceBundleUriRoot( relatedTo );
		var relatedToTranslated = translateResource( relatedToBaseUri & "title", relatedTo );
		var propNameTranslated = translateObjectProperty( objectName, propertyName );

		return translateResource( uri="rules.dynamicExpressions:manyToOneFilter.label", data=[ propNameTranslated, relatedToTranslated ] );
	}

	private string function getText(
		  required string objectName
		, required string propertyName
		, required string relatedTo
	){
		var relatedToBaseUri    = presideObjectService.getResourceBundleUriRoot( relatedTo );
		var relatedToTranslated = translateResource( relatedToBaseUri & "title", relatedTo );
		var propNameTranslated = translateObjectProperty( objectName, propertyName );

		return translateResource( uri="rules.dynamicExpressions:manyToOneFilter.text", data=[ propNameTranslated, relatedToTranslated ] );
	}

}