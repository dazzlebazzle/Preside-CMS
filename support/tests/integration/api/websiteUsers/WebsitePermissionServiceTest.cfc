component output="false" extends="tests.resources.HelperObjects.PresideTestCase" {

// tests
	function test01_listPermissionKeys_shouldReturnAllConfiguredPermissionKeys() output=false {
		var userService = _getPermService();
		var expected    = [ "assets.access", "pages.access" ];
		var actual      = userService.listPermissionKeys();

		super.assertEquals( expected, actual.sort( "textnocase" ) );
	}

	function test02_listPermissionKeys_shouldReturnEmptyArray_whenPassedBenefitHasNoAssociatedPermissions() output=false {
		var permsService = _getPermService();
		var testBenefit  = "somebenefit";

		mockAppliedPermDao.$( "selectData" ).$args(
			  selectFields = [ "granted", "permission_key" ]
			, filter       = { "benefit.id" = testBenefit }
			, forceJoins   = "inner"
		).$results( QueryNew( 'granted,permission_key' ) );

		super.assertEquals( [], permsService.listPermissionKeys( benefit=testBenefit ) );
	}

	function test03_listPermissionKeys_shouldReturnListOfGrantedPermissionsAssociatedWithPassedInBenefit() output=false {
		var permsService = _getPermService();
		var testBenefit  = "somebenefit";
		var testRecords  = QueryNew( 'granted,permission_key', 'bit,varchar', [[1,"some.key"],[0,"denied.key"],[0,"another.key"],[1,"another.key"],[1,"test.key"],[0, "test.key"]] );
		var expected     = [ "some.key", "another.key" ];
		var actual       = "";

		mockAppliedPermDao.$( "selectData" ).$args(
			  selectFields = [ "granted", "permission_key" ]
			, filter       = { "benefit.id" = testBenefit }
			, forceJoins   = "inner"
		).$results( testRecords );

		actual = permsService.listPermissionKeys( benefit=testBenefit );

		super.assertEquals( expected, actual );
	}

	function test04_listPermissionKeys_shouldReturnAListOfPermissionsThatHaveBeenFilteredByThePassedFilter() output=false {
		var permsService = _getPermService( permissionsConfig={
			  cms          = [ "login" ]
			, sitetree     = [ "navigate", "read", "add", "edit", "delete" ]
			, assetmanager = {
				  folders = [ "navigate", "read", "add", "edit", "delete" ]
				, assets  = [ "navigate", "read", "add", "edit", "delete" ]
				, blah    = {
					  test = [ "meh", "doh", "blah" ]
					, test2 = [ "tehee" ]
				}
			 }
			, groupmanager = [ "navigate", "read", "add", "edit", "delete" ]
		} );

		var actual       = permsService.listPermissionKeys( filter=[ "assetmanager.folders.*", "!*.delete", "*.edit" ] );
		var expected     = [
			  "sitetree.edit"
			, "assetmanager.folders.navigate"
			, "assetmanager.folders.read"
			, "assetmanager.folders.add"
			, "assetmanager.folders.edit"
			, "assetmanager.assets.edit"
			, "groupmanager.edit"
		];

		super.assertEquals( expected.sort( "textnocase" ), actual.sort( "textnocase" ) );
	}

// private helpers
	private any function _getPermService( permissionsConfig=_getDefaultPermsConfig() ) output=false {
		mockWebsiteUserService = getMockbox().createEmptyMock( "preside.system.services.websiteUsers.WebsiteUserService" );
		mockBenefitsDao        = getMockbox().createStub();
		mockUserDao            = getMockbox().createStub();
		mockAppliedPermDao     = getMockbox().createStub();
		mockCacheProvider      = getMockbox().createStub();

		return getMockBox().createMock( object= new preside.system.services.websiteUsers.WebsitePermissionService(
			  websiteUserService = mockWebsiteUserService
			, cacheProvider      = mockCacheProvider
			, permissionsConfig  = arguments.permissionsConfig
			, benefitsDao        = mockBenefitsDao
			, userDao            = mockUserDao
			, appliedPermDao     = mockAppliedPermDao
		) );
	}

	private struct function _getDefaultPermsConfig() output=false {
		return {
			  pages  = [ "access" ]
			, assets = [ "access" ]
		};
	}

}