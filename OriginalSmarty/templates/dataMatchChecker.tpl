 <html>
    <head>
        <meta charset="UTF-8">
        <title>DataMatchChecker</title>
        <link type="text/css" href="{$appRootPath}/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="{$appRootPath}/css/font-awesome.css">
        <link rel="stylesheet" href="{$appRootPath}/css/dataTables/css/jquery.dataTables.css">
        <link rel="stylesheet" href="{$appRootPath}/css/dataMatchChecker.css">

        <script type="text/javascript" src="{$appRootPath}/javascripts/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/bootstrap.min.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/dataTables/jquery.jeditable.min.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/dataTables/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/dataTables/jquery.dataTables.editable.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/persist-min.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/knockout-2.3.0.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/dataMatchChecker.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/knockout_models/dataTableModel.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/knockout_models/RelationshipModel.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/knockout_models/DataMatchCheckerViewModel.js"></script>
    </head>
    <body>
        <input type="hidden" id="fromSidInput" value="{$fromSid}" />
        <input type="hidden" id="toSidInput" value="{$toSid}" />
        <input type="hidden" id="fromTableInput" value="{$fromTable}" />
        <input type="hidden" id="toTableInput" value="{$toTable}" />
        <input type="hidden" id="relSerializedString" value='{$relSerializedString}' />
        {literal}
            <div id="relInfoWrapper">
                <div id="relInfoHeader">
                    Relationship Information
                </div>
                <div id="relInfoContainer" class="row">
                    <div class="span4">
                        <table class="relProfile">
                            <tbody>
                                <tr>
                                    <td class="profileHeader">Name:</td>
                                    <td data-bind="text: name() || 'empty'" class="profileContent">Ccode</td>
                                </tr>                            
                                <tr>
                                    <td class="profileHeader">Description:</td><td data-bind="text: description() || 'empty'" class="profileContent">This description is long enough. This description is long enough. This description is long enough.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="span4">
                        <div data-bind="template: { name: 'linkProfile-template', data: fromDataset }" class="fromProfile linkProfile">
                        </div>
                    </div>
                    <div class="span4">
                        <div data-bind="template: { name: 'linkProfile-template', data: toDataset }" class="toProfile linkProfile">
                        </div>
                    </div>
                </div>
            </div>
            <script id="linkProfile-template" type="text/html">
                <table class="linkProfileTable">
                <tbody>
                <tr>
                <td data-bind="text: ($data == $parent.fromDataset()) ? 'From:' : 'To:'" style="font-weight: bold; width: 50px;"></td>
                </tr>
                <tr>
                <td class="linkProfileHeader">Dataset:</td>
                <td class="linkProfileContent">
                <a data-bind="text: name, attr: {href: '{/literal}{$appRootPath}{literal}/story.php?title=' + sid}">abc</a>
                </td>
                </tr>
                <tr>
                <td class="linkProfileHeader">Table:</td>
                <td class="linkProfileContent" data-bind="text: shownTableName">small.xls</td>
                </tr>
                </tbody>
                </table>
            </script>
        {/literal}
        <div id="navListContainer">
            <ul data-bind="foreach: links" class="nav nav-list" style="padding: 0">
                <!-- ko if: $index() == 0 -->
                <li class="nav-header"><span style="margin-left: 15px;">Links</span></li>
                <!-- /ko -->               
                <li class="linkLi">
                    <a data-bind="click: $root.loadLinkData">
                        <table class="link">
                            <tr>
                                <td data-bind="text: fromLinkPart.transInput" class="fromPart linkPart linkPartText">
                                </td>
                                <td data-bind="text: toLinkPart.transInput" class="toPart linkPart linkPartText">
                                </td>
                            </tr>
                        </table>
                    </a>
                </li>            
            </ul>
        </div>
        <div id="tableContainer">
            <div data-bind="visible: !currentLink()" style="color: grey;font-weight: bold; font-size: 20px;margin-top: 20%;margin-left: 29%;padding-bottom: 20%;">
                Please Choose a Link To View Data
            </div>
            <div data-bind="visible: isLoadingData()">
                <img src="../images/ajax-loader.gif" style="margin-top: 20%;margin-left: 45%;"/>
            </div>
            <div data-bind="visible: currentLink() && !isLoadingData()" id="dataTableWrapper">
                <div class="addSynonymPanel">
                    <div class="addSynonymInputWrapper">
                        Value 
                        <input data-bind="value: synFrom" type="text" class="synonymInput fromSynonymInput"/>
                        in <span style="font-weight: bold;">From</span> part is equal to value 
                        <input data-bind="value: synTo" type="text" class="synonymInput toSynonymInput"/>
                        in <span style="font-weight: bold;">To</span> part.
                        <button data-bind="click: saveSynonym" class="btn addSynonymBtn">Add</button>
                        <img data-bind="visible: isAddingSynonym" src="../images/ajax-loader.gif" style="margin: -8px 0 0 5px;"/>
                        <div style="color:red;">
                            <i data-bind="visible: addingSynonymMessage" class="icon-remove-sign" style="padding-right: 3px;"></i>
                            <span data-bind="text: addingSynonymMessage" ></span>
                        </div>
                    </div>
                </div>
                <div class="accordionWrapper">
                    <div class="accordion" id="diffDataAccordion">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle" data-toggle="collapse" data-parent="#diffDataAccordion" href="#diffDataCollapse">
                                    Table of Different Values
                                </a>
                            </div>
                            <div id="diffDataCollapse" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <div>
                                        <span class="matchPercent">Proportion of matched value: <span data-bind="text: matchPercent" class="matchPercentText"></span>%</span>
                                        <span style="float:right;"><input data-bind="checked: isDistinctTablesShown" type="checkbox" style="margin: 0 5px 0 0;" /><span>Show all distinct values</span></span>
                                    </div>                                 
                                    <div data-bind="visible: isDistinctTablesShown()" id="distinctTableWrapper">
                                        <div data-bind="jqueryPagedEditable: distinctFromTableParams" style="float:left; width: 45%;" class="linkDataContainer">                                
                                        </div>
                                        <div data-bind="jqueryPagedEditable: distinctToTableParams" style="float:right; width: 45%;" class="linkDataContainer">                                
                                        </div>
                                    </div>
                                    <div data-bind="visible: !isDistinctTablesShown()" id="valueTableWrapper">
                                        <div data-bind="jqueryEditable: differentValueFromTable" style="float:left; width: 45%;" class="linkDataContainer">                                
                                        </div>
                                        <div data-bind="jqueryEditable: differentValueToTable" style="float:right; width: 45%;" class="linkDataContainer">                                
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>  
                <div class="accordionWrapper" style="display:none;">
                    <div class="accordion" id="sameDataAccordion">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle" data-toggle="collapse" data-parent="#sameDataAccordion" href="#sameDataCollapse">
                                    Table of Same Values
                                </a>
                            </div>
                            <div id="sameDataCollapse" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <div  data-bind="jqueryEditable: sameValueTable" class="linkDataContainer">                               
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
                <!--
                <div class="accordionWrapper">
                    <div class="accordion" id="partlyDataAccordion">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle" data-toggle="collapse" data-parent="#partlyDataAccordion" href="#partlyDataCollapse">
                                    Table of Partly Same Values
                                </a>
                            </div>
                            <div id="partlyDataCollapse" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <div  data-bind="jqueryEditable: partlyValueTable" class="linkDataContainer">                               
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
                -->
            </div>
        </div>        
    </body>
</html>
