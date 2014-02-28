{literal}
<div class='wizard' id='dataSubmissionWizardContainer'>
    <h1>Data Submission Wizard</h1>

    <!-- Upload Your Dataset Step -->

    <div class='wizard-card' data-cardname='UploadOptionStepCard' id="UploadOptionStepCardId">
        <h3 style="display: inline;">Upload your dataset</h3>        
        <div class='wizard-input-section'>
            <p>
                To import a new dataset, please choose one of the following sources:
            </p>
            <div class='control-group'>
                <div class="datasetTypeWrapper">
                    <label class="radio">
                        <input id='computer' type='radio' name='place' value="computer" /> From this computer 
                        <img src='help.png' width='15' height='15' title='Select this option if you want to upload the data stored on your compuper in a data file (e.g., Excel file, CSV, or database dump file).'/>
                    </label>
                    
                    <div id='divFromComputer' >
                        <form class='upload-form' name='upload_form[]' id='upload_form' action='http://localhost:8080/ColFusionServer/Wizard/acceptFileFromWizard' method='post' enctype='multipart/form-data'> 
                            
                            <input type='hidden' name='sid' id="uploadFormSid" data-bind="value: uploadFormSid">
                            <input type='hidden' name='uploadTimestamp' id="uploadTimestamp" data-bind="value: uploadTimestamp">
                            
                            
                            <div class="form-horizontal" >
                                <div class="control-group">
                                    <label class="control-label" for="open-wizard">File Type:</label>
                                    <div class="controls">
                                        <select name="fileType" id="uploadFileType" data-bind="options: $root.uploadFileTypes, value: selectedFileType, optionsText: 'fileTypeDescripiton'"></select>

                                        <select name="fileMode" id="fileMode" data-bind="options: $root.fileModes, value: selectedFileMode, optionsText: 'fileModeDescripiton'" style="display: none;"></select>
                                                    
                                    </div>
                                </div>

                                <div id="fromComputerDatabaseDump" class="control-group" data-bind="visible: selectedFileType().fileType == 'dbDump'">
                                    <label id="dbTypeLabel" class="control-label" for="dbType">Data store:</label>
                                    <div class="controls">
                                       <select name="dbType" id="dbType" data-bind="options: $root.databaseDumpEngines, value: selectedDatabaseDumpEngine, optionsText: 'dbEngineDescripiton'"></select> 
                                    </div>
                                </div>

                             
                                <div class="control-group">
                                    <label class="control-label" for="upload_file">Select file:</label>
                                    <div class="controls">
                                        <input name='upload_file' type='file' multiple/> 
                                        <span id='uploadWidgetCover' data-bind='visible: fileInfos().length > 0'>&nbsp;</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div id="filenameListContainer">
                                <table data-bind="foreach: fileInfos" class="filenameList">                                   
                                    <tr>
                                        <td data-bind="text: $data.files[0].name"></td>
                                        <td><i data-bind="click: $parent.removeFileInfo.bind($data, $index)" class="icon-remove-sign" style="margin-left: 10px;"></i></td>
                                    </tr>
                                </table>
                            </div>
                            <div id='uploadPanel' data-bind='visible: fileInfos().length > 0'>
                                <div class='progress' id='uploadProgressBar' style='display: none;'>
                                    <div class='bar'></div>                             
                                </div>                      
                                <button type='button' name='Submit' id='uploadBtn' data-bind='click: submitFiles, visible: fileInfos().length > 0' class='btn btn-primary'>Upload</button>
                                <span id='uploadProgressText' data-bind="text: uploadProgressText"></span>
                            </div>
                            <p id='uploadMessage' data-bind="text: uploadMessage, style: { color: isUploadSuccessful() ? 'green' : 'red' }"></p>
                        </form>
                    </div>
                </div>

                <!-- DONT DELETE THIS, just do more testing and then uncomment 
                <div class="datasetTypeWrapper">
                    <label class="radio"><input id='internet' type='radio' name='place' value="internet" /> Internet accessable resource </label>
                    <img src='help.png' width='15' height='15' title='Type in a valid url'/>
                    <div id='divFromInternet'>
                        <input type='text' id='in_url'/>
                        <br/>
                        <input type='button' name='checkAv' value='check availability' id='checkAv' class='btn btn-primary' onClick='wizardFromFile.validateUrl();'/>
                    </div>
                </div>

                <div class="datasetTypeWrapper">
                    <label class="radio"><input id='database' type='radio' name='place' value="database" /> From database</label> 
                    <img src='help.png' width='15' height='15' title='More help coming'/>
                    <div id='divFromDatabase'>
                        <table >
                            <tr>
                                <td>DB server:</td>
                                <td>
                                    <select id ='selectDBServer' onchange="wizardFromDB.setDefaultAdvancedSettingsByServerName($('#dbServerPort'), this.value)">
                                        <option value='MySQL'>MySQL</option>
                                        <option value='MSSQL'>Microsoft SQL</option>
                                        <option value='PostgreSQL'>PostgreSQL</option>
                                    </select>							
                                </td>                             
                            </tr>                        
                            <tr>
                                <td>Server address:</td>
                                <td><input type='text' id='dbServerName'/></td>
                            </tr>
                            <tr>
                                <td>Port:</td>
                                <td><input type='text' id='dbServerPort' value="3306"/></td>
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
                -->
            </div>

            <div id='result' >
                
            </div>
        </div>
    </div>

    <!-- End of Upload Your Dataset Step -->

    <!-- =============================================================================================== -->

    <!-- Source Options: for excel files user specifies which sheets, for database what tables to import -->

    <div class='wizard-card' data-cardname='displayOptionsStepCard' style='overflow: hidden;' id='opt'>
        <h3 style="display: inline-block; margin-bottom: 0;">Source Selection</h3> 
        <a href='#' id='help2' style="display: inline;margin-left: 10px;">Click here for help</a>
        <div id='h2'>
            <br/>
            <p class='hlp'> Select the number of sheets for which you need to get headers. Then, for each sheet, provide the sheet name, the row and column where the header starts.</p>
            <a href='#' id='hd2' style='color:green;'>hide help</a>
        </div>
        <span style="margin-left: 10px;" id="loadingProgressContainer">
            <img src="images/ajax-loader.gif"/>
            <span class="loadingText">Loading...</span>
        </span>
        <div id="displayOptoinsStepCardFromFile">                    
            <div>
                <ul id="sourceSettingNavList" class="nav nav-list">
                    <li id="liDataRangeSettingsDataSourceStep" title="Data Range Settings" onclick="wizardFromFile.toggleSourceSelectionPanel(this, '#dataRangeSettingsTabContent')">
                        <i class="icon-caret-right" id="iconCaretNextToWrenchDataSourceStep"></i>
                        <i class="icon-wrench" id="iconWrenchDataSourceStep"></i>
                    </li>
                    <li  title="Data Preview" onclick="wizardFromFile.toggleSourceSelectionPanel(this, '#dataPreviewTabContent')">
                        <i class="icon-caret-right" style="visibility: hidden;" id="iconCaretNextTableDataSourceStep"></i>
                        <i class="icon-table" id="iconTableDataSourceStep"></i>
                    </li>
                </ul>

                <div id="sourceSelectionNavContents">
                    <div class="nav-content" id="dataRangeSettingsTabContent">
                        <form id="displayOptoinsStepCardFromFileForm">
                            <div data-bind="foreach: sourceWorksheetSettings" id="sourceSelectionWrapper">
                                <div class="sourceWorksheetSettingsWrapper">
                                    <p data-bind="text: sourceName" class="sourceName"></p>
                                    <div>
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
                                    </div>
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
                                                                options: $parent.worksheets, 
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
                                    </div>
                                </div>
                            </div>              
                        </form>                            
                    </div>

                    <div class="nav-content" id="dataPreviewTabContent" style="display:none;">   
                        <div id="showFilePreviewButtonContainer">
                            <button class="btn wizard-back" type="button" onclick="return wizardFromFile.showExcelFile();">Show File(s) Preview</button>
                            
                        </div>
                        <div data-bind="foreach: previewFiles" id="previewFiles" style="display:none;">
                            <p data-bind="text: filename" class="sourceName" style="margin-top: 10px;"></p>
                            <div class="previewFileContainer">
                                <div data-bind="visible: progressBarViewModel().isProgressing()" id="loadingProgressContainer">
                                    <div class="loadingTextWrapper" style="margin-top: 60px;">
                                        <span class="loadingText">Preview is loading...</span>
                                        <span data-bind="text: progressBarViewModel().loadingProgressPercent() + '%'" style="float: right;" class='percentText'></span>
                                    </div>
                                    <div class="progress" id="previewProgressBar">
                                        <div data-bind="style: {width: progressBarViewModel().loadingProgressPercent() + '%'}" class="bar"></div>
                                    </div>                  
                                </div>
                                <div data-bind="visible: !progressBarViewModel().isProgressing()" id="sheetExcelWrapper">
                                    <div id ='sheetExcel'>
                                        <ul data-bind="foreach: worksheetPreviewTables" class="nav nav-tabs">
                                            <li data-bind="attr: { class: $index() == 0 ? 'active' : '' }">
                                                <a data-bind="attr: { href: '#' + sheetName() }, 
                                                   text: sheetName"  href="#Sheet1" data-toggle="tab">Sheet1</a>
                                            </li>
                                        </ul>
                                        <div data-bind="foreach: worksheetPreviewTables" class="tab-content previewTables">
                                            <div data-bind="previewTable: cells,                                       
                                                 attr: { id: sheetName(), class: $index() == 0 ? 'tab-pane active previewTable' : 'tab-pane previewTable' }">
                                            </div>
                                        </div>
                                    </div>
                                    <i class="icon-arrow-left previewNavBtn" id="prevBtn" data-bind="visible: previewPage() > 1, click: loadPreviewPreviousPage" title="Previous Page"></i>
                                    <i class="icon-arrow-right previewNavBtn" id="nextBtn" data-bind="visible: hasMoreData(), click: loadPreviewNextPage" title="Next Page" style="margin-left: 5px;"></i>
                                </div>
                            </div>
                        </div>

                    </div>            
                </div>
            </div>
        </div>
        <div id="displayOptoinsStepCardFromDB" style="height: 100%;">
        </div>
    </div>

    <!-- End of Source Opitons -->

    <!-- =============================================================================================== -->

    <!-- Data Matching Step -->

    <div class='wizard-card' data-cardname='dataMatchingStepCard' id="dataMatchingStepCard" style=' overflow: hidden; '>
        <h3 style="display: inline;">Data Matching
            <img src='help.png' width='15' height='15' title='Verify the dname or type yours in the proper type box if not correct and then click submit. You can remove undesired dnames by checking the boxes in fornt of them.'/>
        </h3>
        <img id="dataMatchingStepInProgress"  src="templates/wistie/images/ajax-loader_cp.gif" style="width: 35px; vertical-align: middle;margin-left: 20px;"/>

        <div data-bind="visible: progressBarViewModel().isProgressing()" id="dataMatchingLoadingProgressContainer">
            <div class="loadingTextWrapper" style="margin-top: 60px;">
                <span class="loadingText">Preview is loading...</span>
                <span data-bind="text: progressBarViewModel().loadingProgressPercent() + '%'" style="float: right;" class='percentText'></span>
            </div>
            <div class="progress" id="dataMatchingPreviewProgressBar">
                <div data-bind="style: {width: progressBarViewModel().loadingProgressPercent() + '%'}" class="bar"></div>
            </div>                  
        </div>

        <div data-bind="visible: !progressBarViewModel().isProgressing()" class='wizard-input-section' style='position: relative; width: 100%; height: 100%; overflow: auto;'>
            <label><input type='checkbox' id='toggleAllColumns'/>toggle all</label>

            <div id='dataMatchingTable' data-bind="foreach: files">
                <div>
                    <div data-bind="foreach: worksheets">
                        <div>
                            <label> Variables from <span data-bind="text: $parent.fileName"></span> file - <span data-bind="text: sheetName"></span> table/sheet.</label>

                            <table class="table table-hover">
                                <tr>
                                    <th></th>
                                    <th>Original Variable Name</th>
                                    <th>Selected Variable Name</th>
                                    <th></th>
                                </tr>
                                <tbody data-bind="foreach: variables">
                                    <tr>
                                        <td>
                                            <input type="checkbox" data-bind="checked: checked"/>
                                        </td>
                                        <td>
                                            <span data-bind="text: originalName"></span>
                                        </td>
                                        <td><input data-bind="value: chosenName"/></td>
                                        <td><i class="icon-wrench" data-bind="click: toggleSettingsRowVisibility"></i></td>
                                    </tr>
                                    <tr data-bind="visible: isSettingRowVisible">
                                        <td></td>
                                        <td colspan="3">
                                            <table class="table">
                                                <tr>
                                                    <td>Data Type: <select data-bind='options: variableDataTypes, optionsText: "name", optionsCaption: " ", value: variableValueType'> </select>
                                                    </td>
                                                    <td data-bind="with: variableValueType">
                                                        <div data-bind="visible: units.length > 0">
                                                            Data Unit: <select data-bind='options: units, optionsCaption: " ", value: $parent.variableMeasuringUnit'> </select>
                                                        </div>
                                                        <div data-bind="visible: format.length > 0">
                                                            Format: <select data-bind='options: format, optionsCaption: " ", value: $parent.variableValueFormat'> </select>
                                                        </div>
                                                    
                                                    </td>                                                    
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        Description: 
                                                        <textarea class="input-block-level" data-bind="value: description"> </textarea>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>    
                                </tbody>                    
                            </table>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </div>

    <!-- End of Data Matching Step -->
    <!-- =============================================================================================== -->

    <div class='wizard-error'>
        <div class='alert alert-error'><strong>There was a problem</strong> during your submission. Please report this to <a href='mailto:karataev.evgeny@gmail.com?subject=ErrorReported from Colfusion importing wizard'>Colfusion</a> and restart the wizard again from the main page.
            <p id='messageContainer'></p>
        </div>
    </div>

    <div class='wizard-failure'>
        <div class='alert alert-error'><strong>There was a problem</strong> submitting the form.Please try again in a minute.
        </div>
    </div>

    <div class='wizard-success'>
        <div class='alert alert-success'>
            <p id='exe' value=''> You have completed the wizard successfully. Your dataset is being processed now. Please click on the finish button to close the wizard and go to the original submit new data page to finish up your submission.  You might the message that there is no data in your submission. Don't worry about it, your data is loading in background and will appear on the screen after every 1000 records are processed. You will have to refresh the page to see it though.
            </p>
            <p id='exe'></p>
        </div>
        <a id='done' class='btn im-done'>Complete Wizard</a> 
    </div>

</div>
{/literal}