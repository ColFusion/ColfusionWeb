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
        <script type="text/javascript" src="{$appRootPath}/javascripts/knockout-2.3.0.js"></script>
        <script type="text/javascript" src="{$appRootPath}/javascripts/dataMatchChecker.js"></script>      
    </head>
    <body>
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
                                    <td data-bind="text: name" class="profileContent">Ccode</td>
                                    <td data-bind="visible: isOwned()" rowspan="2" style="display: none;"><button data-bind="click: $root.removeRelationship.bind($data, rid)" class="btn deleteRelBtn">Delete</button></td>
                                </tr>                            
                                <tr><td class="profileHeader">Creator:</td><td data-bind="text: creator" class="profileContent">gz2000</td></tr>
                                <tr><td class="profileHeader">CreatedTime:</td><td data-bind="text: createdTime" class="profileContent">2013-07-17 22:04:43</td></tr>
                                <tr><td class="profileHeader">Description:</td><td data-bind="text: description" class="profileContent">This description is long enough. This description is long enough. This description is long enough.</td></tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="span4">
                        <div data-bind="template: { name: 'linkProfile-template', data: fromDataset }" class="fromProfile linkProfile">          
                            <table class="linkProfileTable">
                                <tbody><tr>
                                        <td data-bind="text: ($data == $parent.fromDataset()) ? 'From:' : 'To:'" style="font-weight: bold;">From Dataset:</td>
                                    </tr>
                                    <tr>
                                        <td class="linkProfileHeader">Dataset:</td>
                                        <td class="linkProfileContent">
                                            <a data-bind="text: name, attr: {href: '/Colfusion/story.php?title=' + sid()}" href="/Colfusion/story.php?title=1777">Test Data PReview</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="linkProfileHeader">Table:</td>
                                        <td class="linkProfileContent" data-bind="text: currentTable">small.xlsx</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="span4">
                        <div data-bind="template: { name: 'linkProfile-template', data: toDataset }" class="toProfile linkProfile">          
                            <table class="linkProfileTable">
                                <tbody><tr>
                                        <td data-bind="text: ($data == $parent.fromDataset()) ? 'From:' : 'To:'" style="font-weight: bold;">To Dataset:</td>
                                    </tr>
                                    <tr>
                                        <td class="linkProfileHeader">Dataset:</td>
                                        <td class="linkProfileContent">
                                            <a data-bind="text: name, attr: {href: '/Colfusion/story.php?title=' + sid()}" href="/Colfusion/story.php?title=1776">abc</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="linkProfileHeader">Table:</td>
                                        <td class="linkProfileContent" data-bind="text: currentTable">small.xls</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        {/literal}
        <div id="navListContainer">
            <ul class="nav nav-list" style="padding: 0">
                <li class="nav-header"><span style="margin-left: 15px;">Links</span></li>
                <li class="selected linkLi">
                    <a>
                        <table class="link">
                            <tr>
                                <td class="fromPart linkPart linkPartText">
                                    Ccode
                                </td>
                                <td class="toPart linkPart linkPartText">
                                    Ccode
                                </td>
                            </tr>
                        </table>
                    </a>
                </li>
                <li class="linkLi"> 
                    <a>
                        <table class="link">
                            <tr>
                                <td class="fromPart linkPart linkPartText">
                                    StateNme
                                </td>
                                <td class="toPart linkPart linkPartText">
                                    StateNme
                                </td>
                            </tr>
                        </table>
                    </a>
                </li>
            </ul>
        </div>
        <div id="tableContainer">
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
    </body>
</html>
