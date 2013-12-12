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
                <div class="datasetTypeWrapper">
                    <label style="display: inline;"><input id='computer' type='radio' name='place' value="computer" /> From this computer </label>
                    <img src='help.png' width='15' height='15' title='Select a valid file (.xls,.xlsx, .csv)'/>
                    <div id='divFromComputer' >
                        <form class='upload-form' name='upload_form[]' id='upload_form' action='DataImportWizard/acceptFileFromWizard.php' method='post' enctype='multipart/form-data'> 
                            <input type='hidden' name='phase' value='0'> 
                            <input type='hidden' name='sid' id="uploadFormSid" value='0'>
                            <input type='hidden' name='uploadTimestamp' id="uploadTimestamp" value='0'>
                            <p id='tohide' style="margin-bottom: 0;"> 
                                <select name="fileType" id="uploadFileType">
                                    <option value="dataFile">CSV, Excel File</option>
                                    <option value="dbDump">Database Dump File</option>
                                </select>                              
                                <select name="excelFileMode" id="excelFileMode" style="display: none;">
                                    <option value="append">Append data into one table</option>
                                    <option value="join">View each file as a table</option>
                                </select>
                                <select name="dbType" id="dbType" style="display:none;">
                                    <option value="MySQL">MySQL</option>
                                    <option value="PostgreSQL">PostgreSQL</option>
                                    
                            <!--    <option value="MSSQL">MS SQL Server</option>    
                                    <option value="Oracle">Oracle</option>
                            -->
                                </select>
                                <label for='upload_file'>
                                    <b>Select file:</b>
                                </label>
                                <input name='upload_file' type='file' size='15' style="color:white;" multiple/>
                                <!--<span id='uploadWidgetCover'>No file chosen</span> -->                        
                            </p>
                            <div id="filenameListContainer">
                                <table data-bind="foreach: fileInfos" class="filenameList">                                   
                                    <tr>
                                        <td data-bind="text: $data.files[0].name"></td>
                                        <td><i data-bind="click: $parent.removeFileInfo.bind($data, $index)" class="icon-remove-sign" style="margin-left: 10px;"></i></td>
                                    </tr>
                                </table>
                            </div>
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
                </div>
                <div  class="datasetTypeWrapper">
                    <label style="display: inline;"><input id='internet' type='radio' name='place' value="internet" /> Internet accessable resource </label>
                    <img src='help.png' width='15' height='15' title='Type in a valid url'/>
                    <div id='divFromInternet'>
                        <input type='text' id='in_url'/>
                        <br/>
                        <input type='button' name='checkAv' value='check availability' id='checkAv' class='btn btn-primary' onClick='wizardFromFile.validateUrl();'/>
                    </div>
                </div>

                <div class="datasetTypeWrapper">
                    <label style="display: inline;"><input id='database' type='radio' name='place' value="database" /> From database</label> 
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
            </div>

            <div id='result' >
                <a href='#' id='help1'>Click here for help</a>
                <div id='h1'>Step 1 help:<br/>
                    <p class='hlp'>Select from this computer option, if you have the dataset locally in your machine. Be sure that you upload only valid files (.xls, .xlsx). Otherwise, Type a valid url when choosing the second option.<br/>When the upload process completed successfully, you can go forward (next button will be actived) </p>
                    <a href='#' id='hd1' style='color:green;'>hide help</a>
                </div>
            </div>
        </div>
    </div>

    <div class='wizard-card' data-cardname='displayOptionsStepCard' style='overflow: hidden;' id='opt'>
        <h3 style="display: inline-block; margin-bottom: 0;">Source Selection</h3> 
        <a href='#' id='help2' style="display: inline;margin-left: 10px;">Click here for help</a>
        <div id='h2'>Step 2 help:
            <br/>
            <p class='hlp'> Select the number of sheets you need to get their headers.<br/> Then, for each sheet, provide the sheet name, the row and column where the header starts.</p>
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


    <div class='wizard-card' data-cardname='dataMatchingStepCard' id="dataMatchingStepCard" style=' width:600px; overflow: hidden; '><!--"+//style='width: 720px; overflow: hidden; '>-->
        <h3 style="display: inline;">Data Matching
            <img src='help.png' width='15' height='15' title='Verify the dname or type yours in the proper type box if not correct and then click submit. You can remove undesired dnames by checking the boxes in fornt of them.'/>
        </h3>
        <img id="dataMatchingStepInProgress"  src="templates/wistie/images/ajax-loader_cp.gif" style="width: 35px; vertical-align: middle;margin-left: 20px;"/>

        <div data-bind="visible: isProgressing()" id="dataMatchingLoadingProgressContainer">
            <div class="loadingTextWrapper" style="margin-top: 60px;">
                <span class="loadingText">Preview is loading...</span>
                <span data-bind="text: loadingProgressPercent() + '%'" style="float: right;" class='percentText'></span>
            </div>
            <div class="progress" id="dataMatchingPreviewProgressBar">
                <div data-bind="style: {width: loadingProgressPercent() + '%'}" class="bar"></div>
            </div>                  
        </div>

        <div data-bind="visible: !isProgressing()" class='wizard-input-section' style='position: relative; width: 100%; height: 100%; overflow: auto;'>
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
        </div>
    </div>

    <div class='wizard-error'>
        <div class='alert alert-error'><strong>There was a problem</strong> during your submission. Please report this to <a href='mailto:karataev.evgeny@gmail.com?subject=ErrorReported from Colfusion importing wizard'>Colfusion</a> and restart the wizard again from the main page.
            <p id='exe'></p>
        </div>
    </div>

    <div class='wizard-failure'>
        <div class='alert alert-error'><strong>There was a problem</strong> submitting the form.Please try again in a minute.
        </div>
    </div>

    <div class='wizard-success'>
        <div class='alert alert-success'>
            <p id='exe' value=''> You have complited the wizard successfully. Your dataset is being processed now. Please click on the finish button to close the wizard and go to the original submit new data page to finish up your submission. 
            <br/>
            You might the message that there is no data in your submission. Don't worry about it, your data is loading in background and will appear on the screen after every 1000 records are processed. You will have to refresh the page to see it though.

            </p>
            <p id='exe'></p>
        </div>
        <a id='done' class='btn im-done'>Finish</a> 
    </div>

</div>