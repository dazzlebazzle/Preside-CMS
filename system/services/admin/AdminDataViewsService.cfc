/**
 * Provides logic for dealing with admin views of preside
 * object records such as calculating what renderer to use
 * for fields, locating renderer viewlets and record URLs.
 *
 * @singleton      true
 * @presideService true
 * @autodoc
 */
component {

// CONSTRUCTOR
	/**
	 * @contentRendererService.inject contentRendererService
	 * @dataManagerService.inject     dataManagerService
	 */
	public any function init( required any contentRendererService, required any dataManagerService ) {
		_setContentRendererService( arguments.contentRendererService );
		_setDataManagerService( arguments.dataManagerService );
		_setLocalCache( {} );

		return this;
	}

// PUBLIC API METHODS
	/**
	 * Renders a field in the context of an admin data view
	 *
	 * @autodoc true
	 * @autodoc           true
	 * @objectName.hint   Name of the object whose property for which you are rendering content
	 * @propertyName.hint Name of the property for which you are rendering content
	 * @recordId.hint     ID of the record to whose content this belongs
	 * @value.hint        Value to render (if any)
	 * @renderer.hint     Renderer to use (will default to calculating the renderer using [[admindataviewsservice-getrendererforfield]])
	 */
	public string function renderField(
		  required string objectName
		, required string propertyName
		, required string recordId
		,          any    value    = ""
		,          string renderer = getRendererForField( objectName=arguments.objectName, propertyName=arguments.propertyName )
	) {

		return _getContentRendererService().render(
			  renderer = arguments.renderer
			, context  = [ "adminview", "admin" ]
			, data     = arguments.value
			, args     = { objectName=arguments.objectName, propertyName=arguments.propertyName, recordId=arguments.recordId }
		);
	}

	/**
	 * Returns either the defined or default admin renderer for the given preside object
	 * property for rendering in an admin record view.
	 *
	 * @autodoc           true
	 * @objectName.hint   Name of the object whose property you wish to get the renderer for
	 * @propertyName.hint Name of the property you wish to get the renderer for
	 */
	public string function getRendererForField( required string objectName, required string propertyName ) {
		var args = arguments;

		return _simpleLocalCache( "getRendererForField_#arguments.objectName#_#arguments.propertyName#", function(){
			var prop = $getPresideObjectService().getObjectProperty(
				  objectName   = args.objectName
				, propertyName = args.propertyName
			);
			var adminRenderer   = prop.adminRenderer ?: "";
			var generalRenderer = prop.renderer      ?: "";
			var type            = prop.type          ?: "";
			var dbType          = prop.dbType        ?: "";
			var relationship    = prop.relationship  ?: "";

			if ( adminRenderer.trim().len() ) {
				return adminRenderer.trim();
			}

			if ( generalRenderer.trim().len() ) {
				return generalRenderer.trim();
			}

			switch( relationship ) {
				case "many-to-one":
					var relatedTo = prop.relatedTo ?: "";
					switch( relatedTo ) {
						case "asset":
						case "link":
							return relatedTo;
					}
					return "manyToOne";

				case "many-to-many":
				case "one-to-many":
					return "objectRelatedRecords";
			}

			switch( dbtype ) {
				case "text":
				case "mediumtext":
				case "longtext":
					return "richeditor";

				case "boolean":
				case "bit":
					return "boolean";

				case "date":
					return "date";

				case "datetime":
				case "timestamp":
					return "datetime";
			}


			return "plaintext";
		} );
	}

	/**
	 * Returns the viewlet to use to render an entire view
	 * of the given object
	 *
	 * @autodoc    true
	 * @objectName Name of the object whose viewlet you wish to get
	 */
	public string function getViewletForObjectRender( required string objectName ) {
		var args = arguments;

		return _simpleLocalCache( "getViewletForObjectRender_#arguments.objectName#", function(){
			var defaultViewlet  = "admin.dataHelpers.viewRecord";
			var specificViewlet = $getPresideObjectService().getObjectAttribute(
				  objectName    = args.objectName
				, attributeName = "adminViewRecordViewlet"
			);

			return specificViewlet.trim().len() ? specificViewlet : defaultViewlet;
		} );
	}

	/**
	 * Returns the handler to use in order to build an admin view record link
	 * for an object record
	 *
	 * @autodoc    true
	 * @objectName Name of the object whose admin view record link handler you wish to get
	 */
	public string function getBuildAdminLinkHandlerForObject( required string objectName ) {
		var args = arguments;

		return _simpleLocalCache( "getBuildAdminLinkHandlerForObject_#arguments.objectName#", function(){
			var definedHandler = $getPresideObjectService().getObjectAttribute(
				  objectName    = args.objectName
				, attributeName = "adminBuildViewLinkHandler"
			);

			if ( definedHandler.len() ) {
				return definedHandler;
			}

			if ( _getDataManagerService().isObjectAvailableInDataManager( objectName=args.objectName ) ) {
				return "admin.dataHelpers.getViewRecordLink";
			}

			return "";
		} )
	}

	/**
	 * Returns whether or not the given object has a corresponding view record link generator
	 *
	 * @autodoc true
	 * @objectName Name of the object to check
	 *
	 */
	public boolean function doesObjectHaveBuildAdminLinkHandler( required string objectName ) {
		return getBuildAdminLinkHandlerForObject( objectName=arguments.objectName ).trim().len() > 0;
	}

	/**
	 * Builds an admin view link for the given object, record ID
	 * and any other arbitrary arguments
	 *
	 * @autodoc    true
	 * @objectName Name of the object for whose record you wish to build a link
	 * @recordId   ID of the record for whom to build a link
	 */
	public string function buildViewObjectRecordLink( required string objectName, required string recordId ) {
		if ( doesObjectHaveBuildAdminLinkHandler( objectName=arguments.objectName ) ) {
			return $getColdbox().runEvent(
				  event          = getBuildAdminLinkHandlerForObject( objectName=arguments.objectName )
				, eventArguments = {}.append( arguments )
				, private        = true
				, prePostExempt  = true
			);
		}

		return "";
	}

// PRIVATE HELPERS
	private any function _simpleLocalCache( required string cacheKey, required any generator ) {
		var cache = _getLocalCache();

		if ( !cache.keyExists( cacheKey ) ) {
			cache[ cacheKey ] = generator();
		}

		return cache[ cacheKey ] ?: NullValue();
	}


// GETTERS/SETTERS
	private any function _getContentRendererService() {
		return _contentRendererService;
	}
	private void function _setContentRendererService( required any contentRendererService ) {
		_contentRendererService = arguments.contentRendererService;
	}

	private struct function _getLocalCache() {
		return _localCache;
	}
	private void function _setLocalCache( required struct localCache ) {
		_localCache = arguments.localCache;
	}

	private any function _getDataManagerService() {
		return _dataManagerService;
	}
	private void function _setDataManagerService( required any dataManagerService ) {
		_dataManagerService = arguments.dataManagerService;
	}
}