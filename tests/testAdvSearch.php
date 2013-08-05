<html>
    <head>
        <script type="text/javascript" src="jquery-1.9.1.js"></script>
        <script type="text/javascript" src="searchJS.js"></script>
    </head>
    <body>
        <div class="advanced">
        <div id="advancedsearch" style="border: none; margin: 20px; padding: 0px;">
        <h2>Advanced Search</h2><br />
        <table style="width: 100%">
            <tr style="width: 100%">
                <td style="width: 80px !important;">Search for: </td>
                <td ><input type="text" id="search" style="width:100%" /></td>
            </tr>           
        </table>
        <table id="conditionTable" style="width: 100%">
            <tr style="width: 100%">
                <td style="width: 80px !important;">Where</td>
                <td><input type ="text"  name="variable[]" style="width: 100%" /></td>
                <td width="50">
                    <select name="select[]">
                        <option value="">---- condition ----</option>
                        <option value="like">contains</option>
                        <option value="=">equal</option>
                        <option value="<>">not equal</option>
                        <option value="<">less than</option>
                        <option value=">">greater than</option>
                        <option value="<=">less or equal</option>
                        <option value=">=">greater or equal</option>
                    </select>
                </td>
                <td><input type="text"  name="condition[]" style="width: 100%" /></td>
                <td style="width: 10px"><input type="button" name="add" value="add" onClick="addCondition();" /></td>
            </tr>           
        </table>
        <table style="width: 100%">
            <tr style="width: 100%">
                <td style="width: 80px !important;">Category: </td>
                <td><input type="text" style="width:100%" /></td>
            </tr>
            <tr>
                <td colspan="2"><input type="button" value="Search" onclick="showResult()" /></td>
            </tr>
        </table>
    </div>

    <form id="joinRequestToNewPage" method="post" action="../visualization/dashboard.php" targe="visualizationWindow">
        <input type="hidden" name="dataset" />        
    </form>

    <!-- advanced search result -->
    <div id="resultDiv" style="border: none; margin: 0px; padding: 0px; visibility:hidden;"></div>
    </div>
           
    </body>
</html>