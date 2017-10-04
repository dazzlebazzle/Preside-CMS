( function( $ ){

	var $searchInput = $( "#preside-launcher-input" )
	  , $launcherContainer = $searchInput.closest( ".launcher-menu" )
	  , initializeSearch, abandonSearch;


	initializeSearch = function(){
		$launcherContainer.addClass( "active" );
	};

	abandonSearch = function(){
		$launcherContainer.removeClass( "active" );
	};


	$searchInput.on( "focus", initializeSearch );
	$searchInput.on( "blur", abandonSearch );


} )( presideJQuery );