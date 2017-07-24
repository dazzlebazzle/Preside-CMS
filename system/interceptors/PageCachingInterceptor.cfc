component extends="coldbox.system.Interceptor" {

	property name="cache"                         inject="cachebox:template";
	property name="delayedViewletRendererService" inject="delayedInjector:delayedViewletRendererService";

// PUBLIC
	public void function configure() {}

	public void function onRequestCapture( event ) {
		if ( event.cachePage() ) {
			var cacheKey = _getCacheKey( event );
			var cached   = cache.get( cacheKey );

			if ( !IsNull( cached ) ) {
				content reset=true;
				echo( delayedViewletRendererService.renderDelayedViewlets( cached ) );
				abort;
			}

		}
	}

	public void function preRender( event, interceptData ) {
		var content = interceptData.renderedContent ?: "";

		if ( event.cachePage() ) {
			var cacheKey = _getCacheKey( event );
			cache.set( cacheKey, content )
		}

		interceptData.renderedContent = delayedViewletRendererService.renderDelayedViewlets( content );
	}

	public void function postUpdateObjectData( event, interceptData ) {
		_clearCaches( argumentCollection=arguments );
	}

	public void function postInsertObjectData( event, interceptData ) {
		_clearCaches( argumentCollection=arguments );
	}

	public void function postDeleteObjectData( event, interceptData ) {
		_clearCaches( argumentCollection=arguments );
	}


// PRIVATE HELPERS
	private string function _getCacheKey( event ) {
		return "pagecache" & event.getCurrentUrl();
	}

	private void function _clearCaches( event, interceptData ) {
		if ( ( interceptData.objectName ?: "" ) == "page" ) {
			cache.clearAll();
		}
	}
}