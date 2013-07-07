<?php ?>
<script src="javascripts/knockout_models/WizardExcelPreviewViewModel.js"></script>
<div class='wizard' id='wizard-demo'>
    <h1>Data Submission Wizard</h1>
    <div class='wizard-card' data-onValidated='setServerName' data-cardname='UploadOptionStepCard'>
        <h3 style="display: inline;">Upload your dataset</h3>        
        <div class='wizard-input-section'>
            <p>To import a new dataset, please choose one of the following sources:
                <img src='help.png' width='15' height='15' title='When the upload process completed successfully, you can go forward (next button will be actived)'/>
            </p>
            <div class='control-group'>
                <label style="display: inline;"><input id='computer' type='radio' name='place' value="computer" /> From this computer </label>
                <img src='help.png' width='15' height='15' title='Select a valid file (.xls,.xlsx, .csv)'/>
                <br/>
                <br/>
                <div id='divFromComputer' >
                    <form class='upload-form' name='upload_form' id='upload_form' action='DataImportWizard/acceptFileFromWizard.php' method='post' enctype='multipart/form-data'> <input type='hidden' name='phase' value='0'> 
                        <p id='tohide' style="margin-bottom: 0;"> 
                            <label for='upload_file'>
                                <b>Select file:</b>
                            </label> 
                            <input name='upload_file' type='file' size='15' multiple/>
                            <span id='uploadWidgetCover'>No file chosen</span>
                            <br/>
                            <select name="fileType" id="uploadFileType">
                                <option value="dataFile">CSV, Excel File</option>
                                <option value="dbDump">Database Dump File</option>
                            </select>
                            <select name="dbType" id="dbType" style="display:none;">
                                <option value="MySQL">MySQL</option>
                                <option value="MSSQL">MS SQL Server</option>
                                <option value="PostgreSQL">PostgreSQL</option>
                                <option value="Oracle">Oracle</option>
                            </select>
                        </p>
                        <div id='uploadPanel'>
                            <div class='progress' id='uploadProgressBar' style='display: none;'>
                                <div class='bar'></div>                             
                            </div>                      
                            <input type='button' name='Submit' value='Upload' id='uploadBtn' style='display:none;' class='btn btn-primary' />
                            <span id='uploadProgressText'></span>
                        </div>
                        <p id='uploadMessage'></p>
                    </form>
                </div>

                <label style="display: inline;"><input id='internet' type='radio' name='place' value="internet" /> Internet accessable resource </label>
                <img src='help.png' width='15' height='15' title='Type in a valid url'/>
                <br/>
                <br/>
                <div id='divFromInternet'>
                    <input type='text' id='in_url'/>
                    <br/>
                    <input type='button' name='checkAv' value='check availability' id='checkAv' class='btn btn-primary' onClick='wizardFromFile.validateUrl();'/>
                </div>

                <label style="display: inline;"><input id='database' type='radio' name='place' value="database" /> From database</label> 
                <img src='help.png' width='15' height='15' title='More help coming'/>
                <br/>
                <div id='divFromDatabase'>
                    <table >
                        <tr>
                            <td>DB server:</td>
                            <td>
                                <select id ='selectDBServer' onchange="wizardFromDB.setDefaultAdvancedSettingsByServerName($('#dbServerPort'), this.value)">
                                    <option value='MySQL'>MySQL</option>
                                    <option value='MSSQL'>Microsoft SQL</option>
                                </select>							
                            </td>
                            <td><span id='showHideAdvancedOptionsFromDatabase' style='cursor: pointer;' onclick="wizardFromDB.togglePort()">Show Advanced Options</span></td>
                        </tr>                        
                        <tr>
                            <td>Server address:</td>
                            <td><input type='text' id='dbServerName'/></td>
                        </tr>
                        <tr>
                            <td>Port:</td>
                            <td><input type='text' id='dbServerPort'/></td>
                        </tr>
                        <tr>
                            <td>User name:</td>
                            <td><input type='text' id='dbServerUserName'/></td>
                        </tr>
                        <tr>
                            <td>Password:</td>
                            <td><input type='password' id='dbServerPassword'/></td>
                        </tr>
                        <tr>
                            <td>Database:</td>
                            <td>
                                <input type='text' id='dbServerDatabase'/>
                                <input type="hidden" id="isImport" value="false"/>
                            </td>		
                            <td><input type='button' value='Test Connection' id='buttonTestDBConnection' class='btn btn-primary' onClick="wizardFromDB.TestDBConnection('divFromDatabase', $('#dbServerName').val(), $('#dbServerUserName').val(), $('#dbServerPassword').val(), $('#dbServerPort').val(), $('#selectDBServer').val(), $('#dbServerDatabase').val(), $('#isImport').val())"/></td>
                            <td><span id='testDBConnectionResultMsg'/></td>								
                        </tr>
                    </table>					
                </div>
            </div>

            <div id='result' />
            <a href='#' id='help1'>Click here for help</a>
            <div id='h1'>Step 1 help:<br/>
                <p class='hlp'>Select from this computer option, if you have the dataset locally in your machine. Be sure that you upload only valid files (.xls, .xlsx). Otherwise, Type a valid url when choosing the second option.<br/>When the upload process completed successfully, you can go forward (next button will be actived) </p>
                <a href='#' id='hd1' style='color:green;'>hide help</a>
            </div>
        </div>
    </div>

    <div class='wizard-card' data-cardname='displayOptionsStepCard' style='overflow: hidden;' id='opt'>
        <h3 style="display: inline;">Source Selection</h3> 
        <div id="displayOptoinsStepCardFromFile">
            <form id="displayOptoinsStepCardFromFileForm">
                <a href='#' id='help2'>Click here for help</a>
                <div id='h2'>Step 2 help:
                    <br/>
                    <p class='hlp'> Select the number of sheets you need to get their headers.<br/> Then, for each sheet, provide the sheet name, the row and column where the header starts.</p>
                    <a href='#' id='hd2' style='color:green;'>hide help</a>
                </div>
                <div class='wizard-input-section' id='second'>
                    <p style="margin-bottom: 0;">How many table sheets you want?
                        <span id='star'>*</span>
                        <select data-bind="
                                options: numOfWorksheetsOptions, 
                                optionsCaption: 'Number of worksheets', 
                                value: numOfWorksheets,
                                event: { change: chooseNumOfWorsheets}" 
                                data-required="true"
                                id ='selectNumberOfSheets' name='customers'>               
                        </select>
                    </p>
                    <div id='sheetRowColumnsTable'>
                        <table border="1" style="table">             
                            <tr data-bind="visible: worksheetSettings().length > 0">
                                <th>sheet name</th>
                                <th>header row</th>
                                <th>start column</th>
                            </tr>
                            <tbody data-bind="foreach: worksheetSettings">
                                <tr style="height:40px;">
                                    <td>
                                        <select data-bind="
                                                options: $root.worksheets, 
                                                optionsCaption: 'Select a worksheet', 
                                                value: sheetName"
                                                data-required="true"
                                                class='sheetNameSelect'
                                                style="margin-bottom: 0;"> 
                                        </select>             
                                    </td>
                                    <td>
                                        <input data-bind="value: startRow" data-required="true" data-min="1" style="width: 100px; margin: 0 10px 0 10px;"/>
                                    </td>
                                    <td>
                                        <input data-bind="value: startColumn" data-required="true" data-excelcol="true" style="width: 100px; margin: 0 10px 0 10px;"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <button data-bind="click: loadPreview" style="margin-top: 5px;display:none;" class="btn btn-primary" id="loadExcelPreviewBtn">
                            Load Excel File
                        </button>
                    </div>
            </form>
            <div data-bind="visible: !isPreviewLoadingComplete()" id ="loadingProgressContainer">
                <div class="loadingTextWrapper" style="margin-top: 60px;">
                    <span class="loadingText">Preview is loading...</span>
                    <span data-bind="text: loadingProgressPercent() + '%'" style="float: right;" class='percentText'></span>
                </div>
                <div class="progress" id="previewProgressBar">
                    <div data-bind="style: {width: loadingProgressPercent() + '%'}" class="bar"></div>
                </div>                  
            </div>
            <div data-bind="visible: $root.isPreviewLoadingComplete()" id="sheetExcelWrapper">
                <div id ='sheetExcel'>
                    <ul data-bind="foreach: previewTables" class="nav nav-tabs">
                        <li data-bind="attr: { class: $index() == 0 ? 'active' : '' }">
                            <a data-bind="attr: { href: '#' + sheetName() }, 
                               text: sheetName"  href="#Sheet1" data-toggle="tab">Sheet1</a>
                        </li>
                    </ul>
                    <div data-bind="foreach: previewTables" class="tab-content previewTables">
                        <div data-bind="previewTable: cells,                                       
                             attr: { id: sheetName(), class: $index() == 0 ? 'tab-pane active' : 'tab-pane' }"
                             class="previewTable">

                        </div>
                    </div>
                </div>
                <i class="icon-arrow-left previewNavBtn" id="prevBtn" data-bind="visible: previewPage() > 1, click: loadPreviewPreviousPage" title="Previous Page"></i>
                <i class="icon-arrow-right previewNavBtn" id="nextBtn" data-bind="visible: hasMoreData(), click: loadPreviewNextPage" title="Next Page" style="margin-left: 5px;"></i>              
            </div>
            <input id='sid' type='hidden' value=''/>
        </div>
        <div id='csv' style='display: block; position: relative; width: 100%; height: 100%; overflow: auto;' ></div>
    </div>
    <div id="displayOptoinsStepCardFromDB" style="height: 100%;">
    </div>

    <div class='wizard-card' data-cardname='schemaMatchinStepCard'>
        <h3 style="display: inline;">Schema Matching
            <img src='help.png' width='15' height='15' title='Either choose a value from the option box or select other to put your own input'/>
        </h3>
        <span id="schemaMatchinStepInProgressWrapper">
            <img id="schemaMatchinStepInProgress"  src="templates/wistie/images/ajax-loader_cp.gif" style="width: 35px; vertical-align: middle;margin-left: 5px;"/>
            <span style="margin-left: 5px;" id="schemaMatchinStepInProgressText">
                Loading... 0%
            </span>
        </span>
        <div id='schemaMatchinTable'></div>
        <a href='#' id='help3'>Click here for help</a>
        <div id='h3'>Step 3 help:<br/>
            <p class='hlp'> Either choose a value from the option box or select other to put your own input.<br/>Fields with (*) must have values, so you can go to the next step.</p>
            <a href='#' id='hd3' style='color:green;'>hide help</a>
        </div>
    </div>


    <div class='wizard-card' data-cardname='dataMatchingStepCard' style=' width:600px; overflow: hidden; '><!--"+//style='width: 720px; overflow: hidden; '>-->
        <h3 style="display: inline;">Data Matching
            <img src='help.png' width='15' height='15' title='Verify the dname or type yours in the proper type box if not correct and then click submit. You can remove undesired dnames by checking the boxes in fornt of them.'/>
        </h3>
        <img id="dataMatchingStepInProgress"  src="templates/wistie/images/ajax-loader_cp.gif" style="width: 35px; vertical-align: middle;margin-left: 20px;"/>

        <div class='wizard-input-section' style='position: relative; width: 100%; height: 100%; overflow: auto;'>
            <!--style='position: relative; width: 780px; height: 100%; overflow: auto;'>-->
            <div id='tools'></div>

            <a href='#' id='help4' >Show help</a>
            <div id='h4'>Step 4 help:<br/>
                <p class='hlp'> In this step, for each Dname, you can match your its name and the related information either by accepting the default match or by giving your own definition (the left column). Also, you can help our system by providing you suggestions to some fileds (the right column).<br/>The left part, Type your own name in box if you want to redefine the dnanme and then click the ... button to complete your new definition like the type, unit, etc...<br/> The right section, Click inside this box to suggest some mathces to the data name.<br/>If the name contains any of the given fields, plase type it box and check the front of it. Also, you can add a new suggestions by choosing other and complete that section.</br/>After you are done completing the suggested matches part, click the add suggestion button to allow us to add your entries to the system.<br/>You can remove undesired dnames by checking the boxes in fornt of them.
                </p>
                <a href='#' id='hd4' style='color:green;'>hide help</a>
            </div>
            <br/>

            <label><input type='checkbox' id='toggleAllColumns'/>toggle all</label>

            <div id='dataMatchingTable'></div>
            <br/><br/><br/><br/>

        </div>
    </div>


    <div class='wizard-error'>
        <div class='alert alert-error'><strong>There was a problem</strong> with your completing your submission. Please report this to <a href='mailto:radwanfatima@gmail.com?subject=ErrorReported from Colfusion importing wizard'>Colfusion</a> and restart the wizard again from the main page.
            <p id='exe'></p>
        </div>
    </div>
    <div class='wizard-failure'>
        <div class='alert alert-error'><strong>There was a problem</strong> submitting the form.Please try again in a minute.
        </div>
    </div>
    <div class='wizard-success'>
        <div class='alert alert-success'>
            <p id='exe' value=''> Your dataset has been imported successfully. Please click on the finish button to close the wizard and go to the original submit new data page to finish up your submission.</p>
            <p id='exe'></p>
        </div>
        <a id='done' class='btn im-done'>Finish</a> 
    </div>
</div>