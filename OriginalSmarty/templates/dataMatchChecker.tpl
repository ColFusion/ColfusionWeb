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
        <script type="text/javascript" src="{$appRootPath}/javascripts/dataMatchChecker.js"></script>      
    </head>
    <body>
        <ul class="nav nav-tabs">
            <li class="active in"><a href="#home" data-toggle="tab">Home</a></li>
            <li><a href="#profile" data-toggle="tab">Profile</a></li>
            <li><a href="#messages" data-toggle="tab">Messages</a></li>
            <li><a href="#settings" data-toggle="tab">Settings</a></li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane active" id="home">
                <div class="addSynonymPanel">
                    <div class="addSynonymInputWrapper">
                        Value 
                        <input type="text" class="synonymInput fromSynonymInput"/>
                        in <span style="font-weight: bold;">From</span> part is equal to value 
                        <input type="text" class="synonymInput toSynonymInput"/>
                        in <span style="font-weight: bold;">To</span> part.
                        <button class="btn addSynonymBtn">Add</button>
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
                                    <div class="linkDataContainer">
                                        <table class="linkDataTable">
                                            <thead>
                                                <tr><th>FromColumnName</th><th>ToColumnName</th></tr>
                                            </thead>
                                            <tbody>
                                                <tr><td>FromData1</td><td>ToData1</td></tr>
                                                <tr><td>FromData2</td><td>ToData2</td></tr>
                                                <tr><td>FromData3</td><td>ToData3</td></tr>
                                                <tr><td>FromData4</td><td>ToData4</td></tr>
                                                <tr><td>FromData5</td><td>ToData5</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>  
                <div class="accordionWrapper">
                    <div class="accordion" id="sameDataAccordion">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle" data-toggle="collapse" data-parent="#sameDataAccordion" href="#sameDataCollapse">
                                    Table of Same Values
                                </a>
                            </div>
                            <div id="sameDataCollapse" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <div class="linkDataContainer">
                                        <table class="linkDataTable">
                                            <thead>
                                                <tr><th>FromColumnName</th><th>ToColumnName</th></tr>
                                            </thead>
                                            <tbody>
                                                <tr><td>FromData1</td><td>ToData1</td></tr>
                                                <tr><td>FromData2</td><td>ToData2</td></tr>
                                                <tr><td>FromData3</td><td>ToData3</td></tr>
                                                <tr><td>FromData4</td><td>ToData4</td></tr>
                                                <tr><td>FromData5</td><td>ToData5</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
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
                                    <div class="linkDataContainer">
                                        <table class="linkDataTable">
                                            <thead>
                                                <tr><th>FromColumnName</th><th>ToColumnName</th></tr>
                                            </thead>
                                            <tbody>
                                                <tr><td>FromData1</td><td>ToData1</td></tr>
                                                <tr><td>FromData2</td><td>ToData2</td></tr>
                                                <tr><td>FromData3</td><td>ToData3</td></tr>
                                                <tr><td>FromData4</td><td>ToData4</td></tr>
                                                <tr><td>FromData5</td><td>ToData5</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                                <tr><td>FromData</td><td>ToData</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
            </div>
            <div class="tab-pane" id="profile"></div>
            <div class="tab-pane" id="messages"></div>
            <div class="tab-pane" id="settings"></div>
        </div>
    </body>
</html>
