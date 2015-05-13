{literal}

<div class="dataPreviewTableWrapper">
    <div class="preview-story" id = "dataprovenanceView">
       
        <button id="visualizeBtn" class="btn visualizeBtn" onclick="dataProvenance.showGraph();">
           
            Expand/Closes
        </button>
         <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="dataProvenance.showPDF();">
           
            PDF
        </button>
        
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="dataProvenance.showXML();">
           
            XML
        </button>

                <h3 class="preview-title">Provenance</h3>
            </br>
        <div data-bind="visible: isShow" id="provenanceView">
         <div id="cytoscapeweb">
            Cytoscape Web will replace the contents of this div with your graph.
        </div>
        <div >
            <span class="link" id="color">Color me surprised</span>
            <br/ >
            <span class="link" id="colordefault">Default Color</span>
        </div>
        <div id="note">
            
        </div>
       
</div>
</div>
</div>

 <style>
            * { margin: 0; padding: 0; font-family: Helvetica, Arial, Verdana, sans-serif; }

            /* The Cytoscape Web container must have its dimensions set. */
            #cytoscapeweb { width: 100%; height: 550px; }
            #note { width: 100%; text-align: center; padding-top: 1em; }
            .link { text-decoration: underline; color: #0b94b1; cursor: pointer; }
        </style>

        
{/literal}
