<?php 
	//include('getColumns.php');
	include('../config.php');	
	include('../'.mnminclude.'html1.php');
	include('../'.mnminclude.'link.php');
	include('../'.mnminclude.'tags.php');
	include('../'.mnminclude.'user.php');
	include('../'.mnminclude.'smartyvariables.php');
	include('Canvas.php');
	
?>

<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Visualization | Col*Fusion</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">

		<!-- styles and functions for dashboard-->
		<link rel="stylesheet" href="css/bootstrap.css">
		<link rel="stylesheet" href="css/bootstrap-responsive.css">
		<link rel="stylesheet" href="css/jquery.ui.all.css">	
		<link rel="stylesheet" href="css/dashboard.css">	
		<script type="text/javascript" src="js/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="js/bootstrap.js"></script>	
		<script type="text/javascript" src="js/jquery-ui.js"></script>	
		<script type="text/javascript" src="js/jquery.ui.core.js"></script>
		<script type="text/javascript" src="js/jquery.ui.widget.js"></script>
		<script type="text/javascript" src="js/jquery.ui.mouse.js"></script>
		<script type="text/javascript" src="js/jquery.ui.resizable.js"></script>
		<script type="text/javascript" src="js/jquery.ui.draggable.js"></script>
	    <script type="text/javascript" src="js/dashboardJS.js"></script>		
		<script type="text/javascript" src="js/test.js"></script>
		<script type="text/javascript" src="js/ContentResponse.js"></script>
		<!-- styles and functions for table -->
	    <link rel="stylesheet" href="css/googleTableCSS.css" />
	    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
	    <script type="text/javascript" src="js/tableJS.js"></script>

	    <!-- styles and functions for geo chart -->
	    <script type="text/javascript" src="js/mapJS.js"></script>

		<!-- styles and functions for pie chart -->
	    <script type="text/javascript" src="js/pieJS.js"></script>
		<script type="text/javascript" src="js/json2.js"></script>

		<!-- styles and functions for column chart -->
		<script type="text/javascript" src="js/columnJS.js"></script>

	    <!-- styles and functions for combo chart -->
		<script type="text/javascript" src="js/comboJS.js"></script>

		<!-- styles and functions for motion chart -->
		<script type="text/javascript" src="js/motionJS.js"></script>
	</head>
	<body onload="loadTables();loadMotions();loadColumns();loadPies();loadCombos();">
	<input type="hidden" id="hiddenJoinQuery" value="<?php echo $_POST['joinQuery'] ?>"/>
	<input type="hidden" id="hiddenSidsWithColumns" value="<?php echo $_POST['sisToSearch'] ?>"/>

		<!-- Navigation bar -->
		<div class="navbar navbar-inverse navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container">
					<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<div class="brand" id="brand">Col*Fusion Visualization</div>
					<div class="nav-collapse collapse">
						<ul class="nav">
							<li class="dropdown" id="file-dropdown">
								<a href="#visualization" class="dropdown-toggle" data-toggle="dropdown">File <b class="caret"></b></a>
								<ul class="dropdown-menu">
									<li><a href="#newCanvas" data-toggle="modal">New</a></li>
									<li><a href="#open" data-toggle="modal">Open</a></li>
									<li><a href="#share" data-toggle="modal">Share</a></li>
								</ul>
							</li>
							<li class="dropdown" id="chart-dropdown">
								<a href="#visualization" class="dropdown-toggle" data-toggle="dropdown">Add <b class="caret"></b></a>
								<ul class="dropdown-menu">
									<!--<li><a href="#addTable" data-toggle="modal">Add Table</a></li>-->
									<li><a href="#addPie" data-toggle="modal">Add Pie Chart</a></li>
									<!--<li><a href="#addMotion" data-toggle="modal">Add Motion Chart</a></li>
									<li><a href="#addColumn" data-toggle="modal">Add Column Chart</a></li>
									<li><a href="#addCombo" data-toggle="modal">Add Combo Chart</a></li>
									<li><a href="#addMap" data-toggle="modal">Add Map</a></li>-->
								</ul>
							</li>			
							<li class="dropdown" id="view-dropdown">
								<a href="#view" class="dropdown-toggle" data-toggle="dropdown">View <b class="caret"></b></a>
								<ul class="dropdown-menu" id="chartview">
									<?php if(!$visGadgets){ ?>
									<li id="viewnone"><a data-toggle="modal">None</a></li>
									<?php }else{ foreach($visGadgets as $vis) { ?>
									<li class="view" id="view<?=$vis->vid?>">
										<a href="#" data-toggle="modal"><?=$vis->type?> <?=$vis->vid?></a>
									</li>
									<?php } } ?>
								</ul>
							</li>
						</ul>
						<!--<button class="btn" name="save" id="save">Save</button>-->
						<button class="btn" name="testSave" id="testSave" onclick="saveCanvas()">Save</button>
						<input type="hidden" id="titleNo" value="<?php echo $titleNum ?>"/>
						<input type="hidden" id="where" value="<?php echo $where ?>"/>
						<input type="hidden" id="userid" value="<?php echo $current_user->user_id;?>">
						<!--<a class="pull-right btn" href="../index.php">Go Back</a>-->
						<div class="pull-right welcome">Welcome, <?php echo $current_user->user_login; ?></div>
					</div><!--/.nav-collapse -->
				</div>
			</div>
		</div>

		<!--New Canvas -->
		<div id="newCanvas" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="motionAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="motionAddModalLabel">Create a new canvas</h3>
			</div>
			<div class="modal-body">
				Name : <input type="text" class="span2" id="createCanvasName">
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addMotionSave" onclick="createNewCanvas()">Create</button>
			</div>
		</div>
		
		<!-- Add Table Modal -->
		<div id="addTable" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="tableAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="tableAddModalLabel">Add Table</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#columns" data-toggle="tab">Columns</a></li>
					<li><a href="#page" data-toggle="tab">Pages</a></li>
					<li><a href="#style" data-toggle="tab">Style</a></li>
				</ul>		 
				<div class="tab-content">
					<div class="tab-pane active" id="columns">
						<label class="tabContentTitle">Select from following columns</label>
						<div class="columnSelection">
							<?php foreach($columns as $name) { ?>
							<label class="checkbox">
								<input type="checkbox" name="tableColumns" value="<?=$name?>" checked /> <?php echo $name; ?>
							</label>
							<?php } ?>
						</div>
					</div>
					<div class="tab-pane" id="page">
						<label class="tabContentTitle">Number of tuples per page</label>
						<label class="radio"><input type="radio" name="page" id="optionsRadios1" value="20"> 20 per page</label>
						<label class="radio"><input type="radio" name="page" id="optionsRadios2" value="50" checked> 50 per page</label>
						<label class="radio"><input type="radio" name="page" id="optionsRadios3" value="100"> 100 per page</label>
					</div>
					<input type="hidden" name="currentPage" value="1" />
					<div class="tab-pane" id="style">
						<label class="tabContentTitle">Table Color-Themes</label>
						<label class="radio">
							<input type="radio" name="color" id="themeRadios1" value="blue" checked> Blue Theme
							<img src="img/tableThemes/blueTheme.png" alt="Blue Theme" />
						</label>
						<label class="radio">
							<input type="radio" name="color" id="themeRadios2" value="purple"> Purple Theme
							<img src="img/tableThemes/purpleTheme.png" alt="Purple Theme" />
						</label>
						<label class="radio">
							<input type="radio" name="color" id="themeRadios3" value="green"> Green Theme
							<img src="img/tableThemes/greenTheme.png" alt="Green Theme" />
						</label>
						<label class="radio">
							<input type="radio" name="color" id="themeRadios4" value="orange"> Orange Theme
							<img src="img/tableThemes/orangeTheme.png" alt="Orange Theme" />
						</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addTableSave" onclick="loadTableData(1,0);">Save changes</button>
			</div>
		</div>


		<!-- Edit Table Modal -->
		<div id="editTable" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="tableEditModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="tableEditModalLabel">Edit Table</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li id="columnEditTab" class="active"><a href="#columnsEdit" data-toggle="tab">Columns</a></li>
					<li id="pageEditTab"><a href="#pageEdit" data-toggle="tab">Pages</a></li>
					<li id="styleEditTab"><a href="#styleEdit" data-toggle="tab">Style</a></li>
				</ul>		 
				<div class="tab-content">
					<div class="tab-pane active" id="columnsEdit">
						<label class="tabContentTitle">Select from following columns</label>
						<div class="columnSelection">
							<?php foreach($columns as $name) { ?>
							<label class="checkbox">
								<input type="checkbox" name="tableColumnsEdit" value="<?=$name?>" checked /> <?php echo $name; ?>
							</label>
							<?php } ?>
						</div>
					</div>
					<div class="tab-pane" id="pageEdit">
						<label class="tabContentTitle">Number of tuples per page</label>
						<label class="radio"><input type="radio" name="pageEdit" id="optionsEditRadios1" value="20"> 20 per page</label>
						<label class="radio"><input type="radio" name="pageEdit" id="optionsEditRadios2" value="50" checked> 50 per page</label>
						<label class="radio"><input type="radio" name="pageEdit" id="optionsEditRadios3" value="100"> 100 per page</label>			
					</div>
					<input type="hidden" name="currentPage" value="1" />
					<div class="tab-pane" id="styleEdit">
						<label class="tabContentTitle">Table color-themes</label>
						<label class="radio">
							<input type="radio" name="colorEdit" id="themeEditRadios1" value="blue" checked> Blue Theme
							<img src="img/tableThemes/blueTheme.png" alt="Blue Theme" />
						</label>
						<label class="radio">
							<input type="radio" name="colorEdit" id="themeEditRadios2" value="purple"> Purple Theme
							<img src="img/tableThemes/purpleTheme.png" alt="Purple Theme" />
						</label>
						<label class="radio">
							<input type="radio" name="colorEdit" id="themeEditRadios3" value="green"> Green Theme
							<img src="img/tableThemes/greenTheme.png" alt="Green Theme" />
						</label>
						<label class="radio">
							<input type="radio" name="colorEdit" id="themeEditRadios4" value="orange">
							Orange Theme
							<img src="img/tableThemes/orangeTheme.png" alt="Orange Theme" />
						</label><br />
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="editTableSave">Save changes</button>
			</div>
		</div>	

		<!-- Add Motion Chart Modal-->
		<div id="addMotion" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="motionAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="motionAddModalLabel">Add Motion Chart</h3>
			</div>
			<div class="modal-body">
				<label class="tabContentTitle">Select one column as CATEGORY (string)</label>
				<select id="motionFirstColumn">
					<?php foreach($columns as $col_name) { ?>
					<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
					<?php } ?>
				</select>
				<label class="tabContentTitle">Select one column as DATE (year)</label>
				<select id="motionDate" size=3 multiple>
					<?php foreach($columns as $date) { ?>
					<option value="<?=$date?>"><?php echo $date; ?></option>
					<?php } ?>
				</select>
				<label class="tabContentTitle">Select at least one from the following columns (number)</label>
					<?php foreach($columns as $col_name) { ?>
					<label class="checkbox">
						<input type="checkbox" name="motionOtherColumn[]" value="<?=$col_name?>"> <?php echo $col_name; ?>
					</label>
					<?php } ?>
				
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addMotionSave" onclick="drawMotion(1,0)">Save changes</button>
			</div>
		</div>
		

		<!-- Edit Motion Chart Modal-->
		<div id="editMotion" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="motionEditModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="motionEditModalLabel">Edit Motion Chart</h3>
			</div>
			<div class="modal-body">
				<label class="tabContentTitle">Select one column as CATEGORY</label>
				<select id="motionFirstColumnEdit">
					<?php foreach($columns as $col_name) { ?>
					<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
					<?php } ?>
				</select>
				<label class="tabContentTitle">Select one column as DATE</label>
				<select id="motionDateEdit" size=3 multiple>
					<?php foreach($columns as $date) { ?>
					<option value="<?=$date?>"><?php echo $date; ?></option>
					<?php } ?>
				</select>
				<label class="tabContentTitle">Select at least one from the following columns</label>
					<?php foreach($columns as $col_name) { ?>
					<label class="checkbox">
						<input type="checkbox" name="motionOtherColumnEdit[]" value="<?=$col_name?>"> <?php echo $col_name; ?>
					</label>
					<?php } ?>			

			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="editMotionSave">Save changes</button>
			</div>
		</div>

		
		<!-- Add Map Modal-->
		<div id="addMap" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="mapAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="mapAddModalLabel">Add Map</h3>
			</div>
			<div class="modal-body">
				<label class="tabContentTitle">Location</label>
				<label>Latitude:</label>
				<select id="latitude">
					<?php foreach($columns as $name) { ?>
						<option value="<?=$name?>"><?php echo $name; ?></option>
					<?php } ?>
				</select><br>
				<label>Longitude:</label>
				<select id="longitude">
					<?php foreach($columns as $name) { ?>
						<option value="<?=$name?>"><?php echo $name; ?></option>
					<?php } ?>
				</select>
				<label class="tabContentTitle">Tooltip Fields</label>
				<?php foreach($columns as $name) { ?>
					<label class="checkbox">
						<input type="checkbox" name="mapTooltip" value="<?=$name?>" /> <?php echo $name; ?>
					</label>
				<?php } ?>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addMapSave" onclick="loadMap(1,0)">Save changes</button>
			</div>
		</div>

		<!-- Edit Map Modal-->
		<div id="editMap" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="mapAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="mapAddModalLabel">Edit geo chart</h3>
			</div>
			<div class="modal-body">
				<label class="tabContentTitle">Location</label>
				<label>Latitude:</label>
				<select id="latitudeEdit">
					<?php foreach($columns as $name) { ?>
						<option value="<?=$name?>"><?php echo $name; ?></option>
					<?php } ?>
				</select><br>
				<label>Longitude:</label>
				<select id="longitudeEdit">
					<?php foreach($columns as $name) { ?>
						<option value="<?=$name?>"><?php echo $name; ?></option>
					<?php } ?>
				</select>
				<label class="tabContentTitle">Tooltip Fields</label>
				<?php foreach($columns as $name) { ?>
					<label class="checkbox">
						<input type="checkbox" name="mapTooltipEdit" value="<?=$name?>" /> <?php echo $name; ?>
					</label>
				<?php } ?>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="editMapSave">Save changes</button>
			</div>
		</div>
		
		<!-- Add Pie Chart Modal -->
		<div id="addPie" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="pieAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="myPieLabel">Add Pie Chart</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#pcolumn" data-toggle="tab">Columns</a></li>		  
					<li><a href="#ptype" data-toggle="tab">Aggregation</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="pcolumn">
						<label class="tabContentTitle">Select one column as CATEGORY</label>
						<select id="pieColumnCat">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
						<label class="tabContentTitle">Select one column for aggregation</label>
						<select id="pieColumnAgg">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>							
					</div>
					<div class="tab-pane" id="ptype">
						<label class="tabContentTitle">Select from following aggregation types</label>
						<label class="radio"><input type="radio" value="Count" name="pieAggType" checked> Count</label>
						<label class="radio"><input type="radio" value="Sum" name="pieAggType"/> Sum</label>
						<label class="radio"><input type="radio" value="Avg" name="pieAggType"/> Avg</label>
						<label class="radio"><input type="radio" value="Min" name="pieAggType"/> Min</label>
						<label class="radio"><input type="radio" value="Max" name="pieAggType"/> Max</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addPieSave" onclick="addPieChart()">Save changes</button>
			</div>
		</div>


        <!-- Edit Pie Chart Modal -->
		<div id="editPie" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="pieEditModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="myPieLabel">Edit Pie Chart</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#pcolumnEdit" data-toggle="tab">Column</a></li>		  
					<li><a href="#ptypeEdit" data-toggle="tab">Aggregation</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="pcolumnEdit">
						<label class="tabContentTitle">Select one column as CATEGORY</label>
						<select id="pieColumnCatEdit">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
						<label class="tabContentTitle">Select one column for aggregation</label>
						<select id="pieColumnAggEdit">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>	
					</div>
					<div class="tab-pane" id="ptypeEdit">
						<label class="tabContentTitle">Select from following aggregation types</label>
						<label class="radio"><input type="radio" value="Count" name="pieAggTypeEdit" checked> Count</label>
						<label class="radio"><input type="radio" value="Sum" name="pieAggTypeEdit"/> Sum</label>
						<label class="radio"><input type="radio" value="Avg" name="pieAggTypeEdit"/> Avg</label>
						<label class="radio"><input type="radio" value="Min" name="pieAggTypeEdit"/> Min</label>
						<label class="radio"><input type="radio" value="Max" name="pieAggTypeEdit"/> Max</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="editPieSave">Save changes</button>
			</div>
		</div>


        <!--Add Column Chart Modal -->
		<div id="addColumn" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="columnAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="columnAddModalLabel">Add Column Chart</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#column" data-toggle="tab">Columns</a></li>
					<li><a href="#ctype" data-toggle="tab">Aggregation</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="column">
						<label class="tabContentTitle">Select one column as CATEGORY</label>
						<select id="columnCat">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
						<label class="tabContentTitle">Select one column for aggregation</label>
						<select id="columnAgg">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
					</div>
					<div class="tab-pane" id="ctype">
						<label class="tabContentTitle">Select from following aggregation types</label>
						<label class="radio"><input type="radio" value="Count" name="columnAggType" checked>Count</label>
						<label class="radio"><input type="radio" value="Sum" name="columnAggType" /> Sum</label>
						<label class="radio"><input type="radio" value="Avg" name="columnAggType" /> Avg</label>
						<label class="radio"><input type="radio" value="Min" name="columnAggType" /> Min</label>
						<label class="radio"><input type="radio" value="Max" name="columnAggType" /> Max</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addColumnSave" onclick="drawColumn(1,0)">Save changes</button>
			</div>
		</div>

		<!-- Edit Column Chart Modal-->
		<div id="editColumn" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="columnEditModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="columnEditModalLabel">Edit Column Chart</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#columnEdit" data-toggle="tab">Column</a></li>
					<li><a href="#ctypeEdit" data-toggle="tab">Aggregation</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="columnEdit">
						<label class="tabContentTitle">Select one column as CATEGORY</label>
						<select id="columnCatEdit">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
						<label class="tabContentTitle">Select one column for aggregation</label>
						<select id="columnAggEdit">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
					</div>
					<div class="tab-pane" id="ctypeEdit">
						<label class="tabContentTitle">Select from following aggregation types</label>
						<label class="radio"><input type="radio" value="Count" name="columnAggTypeEdit" checked>Count</label>
						<label class="radio"><input type="radio" value="Sum" name="columnAggTypeEdit" /> Sum</label>
						<label class="radio"><input type="radio" value="Avg" name="columnAggTypeEdit" /> Avg</label>
						<label class="radio"><input type="radio" value="Min" name="columnAggTypeEdit" /> Min</label>
						<label class="radio"><input type="radio" value="Max" name="columnAggTypeEdit" /> Max</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="editColumnSave">Save changes</button>
			</div>
		</div>
		
		<!--Open Canvas-->
		<div id="open" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="tableAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="tableAddModalLabel">Open Canvases</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#Canvas" data-toggle="tab">Canvas</a></li>
					<li><a href="#Chart" data-toggle="tab">Chart</a></li>
				</ul>		 
				<div class="tab-content">
					<div class="tab-pane active" id="Canvas">
						<div class="seachArea"> 
						     <label class = "tabContentTitle" style = "float:left">Search Canvas By Name:   </label>
						     <input type="text"  name="searchText" onfocus = "showHint(this.value)" onkeyup = "showHint(this.value)" style = "width:auto"></input>
						</div>
						
						<div id="pickArea"> 
						     
						</div>
						
					</div>
				
					<div class="tab-pane" id="Chart">
						
					</div>
				</div>
			</div>
			<!--
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addTableSave" onclick="loadTableData(1,0);">Save changes</button>
			</div>
			-->
		</div>


		<!-- Add Combo Chart Modal-->
		<div id="addCombo" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="comboAddModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="comboAddModalLabel">Add Combo Chart</h3>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#combocolumn" data-toggle="tab">Columns</a></li>
					<li><a href="#combotype" data-toggle="tab">Aggregation</a></li>
				</ul>			
				<div class="tab-content">
					<div class="tab-pane active" id="combocolumn">
						<label class="tabContentTitle">Select one column as CATEGORY</label>
						<select id="comboColumnCat">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
						<label class="tabContentTitle">Select one column for aggregation</label>
						<select id="comboColumnAgg">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
					</div>
				
					<div class="tab-pane" id="combotype">
						<label class="tabContentTitle">Select from following aggregation types</label>
						<label class="checkbox"><input type="checkbox" value="Count" name="comboAggType">Count</label>
						<label class="checkbox"><input type="checkbox" value="Sum" name="comboAggType" /> Sum</label>
						<label class="checkbox"><input type="checkbox" value="Avg" name="comboAggType" /> Avg</label>
						<label class="checkbox"><input type="checkbox" value="Min" name="comboAggType" /> Min</label>
						<label class="checkbox"><input type="checkbox" value="Max" name="comboAggType" /> Max</label>
					</div>
				</div>					
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="addComboSave" onclick="drawCombo(1,0)">Save changes</button>
			</div>
		</div>


		<!-- Edit Combo Chart Modal-->
		<div id="editCombo" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="comboEditModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i></button>
				<h3 id="comboEditModalLabel">Edit Combo Chart</h3>
			</div>
			<div class="modal-body">
				<div class="tab-content">
					<div class="tab-pane active" id="combocolumnEdit">
						<label class="tabContentTitle">Select one column as CATEGORY</label>
						<select id="comboColumnCatEdit">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
						<label class="tabContentTitle">Select one column for aggregation</label>
						<select id="comboColumnAggEdit">
						<?php foreach($columns as $col_name) { ?>
							<option value="<?=$col_name?>"><?php echo $col_name; ?></option>
						<?php } ?>
						</select>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				<button class="btn btn-primary" id="editComboSave">Save changes</button>
			</div>
		</div>


		<!-- Chart Results -->
		<div class="container">
                    <input type="hidden" id="vid" value=""/>
                    <input type="hidden" id="canvasName" value=""/>
                    <input type="hidden" id="privilege" value=""/>
                    <input type="hidden" id="authorization" value=""/>
                    <input type="hidden" id="mdate" value=""/>
                    <input type="hidden" id="cdate" value=""/>
                    <input type="hidden" id="note" value=""/>
                    <div class="chart-area">
                        
                    </div>

		</div> <!-- /container -->
	</body>
</html>