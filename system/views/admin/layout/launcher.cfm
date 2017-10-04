<cfscript>
	launcherPlaceholder = htmlEditFormat( translateResource( "cms:laucher.search.placeholder" ) );
</cfscript>

<cfoutput>
	<div class="navbar-header pull-left">
		<ul class="nav ace-nav">
			<li class="launcher-menu clearfix">
				<label for="preside-launcher-input" class="launcher-menu-icon"><i class="fa fa-fw fa-bolt"></i></label>
				<input name="preside-launcher-input" id="preside-launcher-input" class="launcher-menu-input compact" placeholder="#launcherPlaceholder#" />

				<div class="launcher-results-box">
					<div class="launcher-results-results">
						<dl>
							<dt>
								<i class="fa fa-fw fa-heart red"></i> Favourites
							<dt>
							<dd><i class="fa fa-fw"></i> Add release notes page</dd>
							<dd><i class="fa fa-fw"></i> Do something else</dd>
							<dd><i class="fa fa-fw"></i> Google analytics<br><br></dd>

							<dt>
								<i class="fa fa-fw fa-puzzle-piece blue"></i> Data manager
							</dt>
							<dd><i class="fa fa-fw"></i> Contacts</dd>
							<dd><i class="fa fa-fw"></i> Organisations</dd>
							<dd><i class="fa fa-fw"></i> Countries</dd>
							<dd><i class="fa fa-fw"></i> Categories</dd>
							<dd><i class="fa fa-fw"></i> Tags</dd>
						</dl>
					</div>
					<div class="launcher-results-footer">
						<p class="text-right grey"><em>#translateResource( uri="cms:launcher.keyboard.help", data=[ "<code>/</code>" ] )#</em></p>
					</div>
				</div>
			</li>
		</ul>
	</div>
</cfoutput>