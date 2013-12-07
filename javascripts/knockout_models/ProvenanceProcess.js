function getRootPath() {
       var pathName = window.location.pathname.substring(1);
       var webName = pathName == '' ? '' : pathName.substring(0, pathName.indexOf('/'));
       //return window.location.protocol + '//' + window.location.host + '/'+ webName + '/';
       return webName;
       } 

function dataProvenanceModel(sid) {
	var self = this;
	self.isShow = ko.observable(false);

	self.showGraph = function() {
		if (self.isShow()) {
            self.isShow(false);
        }
		else {
            drawCyto(sid);
            self.isShow(true);
        }

    };
    self.showXML = function(){
        var url = "target/"+sid+".xml";
        return window.open(url, '_blank', 'fullscreen=yes'); return false;
    };
    self.showPDF = function(){
        var url = "target/"+sid+".pdf";
        return window.open(url, '_blank', 'fullscreen=yes'); return false;
    };
}

function drawCyto(sid) {
                // id of Cytoscape Web container div
                var div_id = "cytoscapeweb";
                
                // NOTE: - the attributes on nodes and edges
                //       - it also has directed edges, which will automatically display edge arrows

                var filepath = "target/"+sid+"_visual.xml";

                var xmlll=file_get_contents(filepath);
                
                if(xmlll.indexOf('404')!==-1)
                {
                    xml='<graphml><key attr.name="label" attr.type="string" for="all" id="label"/><key attr.name="weight" attr.type="double" for="node" id="weight"/><graph edgedefault="directed"><node id="1"><data key="label">File Not Found!</data><data key="weight">2.0</data></node></graph></graphml>';

                }
                else
                {
                   xml=xmlll;

                }
     

                function rand_color() {
                    function rand_channel() {
                        return Math.round( Math.random() * 255 );
                    }
                    
                    function hex_string(num) {
                        var ret = num.toString(16);
                        
                        if (ret.length < 2) {
                            return "0" + ret;
                        } else {
                            return ret;
                        }
                    }
                    
                    var r = rand_channel();
                    var g = rand_channel();
                    var b = rand_channel();
                    
                    return "#" + hex_string(r) + hex_string(g) + hex_string(b); 
                }

               

                // visual style we will use
                var visual_style = {
                    global: {
                        backgroundColor: "#ABCFD6"
                    },
                    nodes: {
                        shape: {
                            discreteMapper: {
                                attrName: "id",
                                entries: [
                                    { attrValue: 1, value: "ELLIPSE" },
                                    { attrValue: 2, value: "ELLIPSE" },
                                    { attrValue: 3, value: "RECTANGLE" },
                                    { attrValue: 4, value: "OCTAGON" },
                                    { attrValue: 5, value: "OCTAGON" },
                                    { attrValue: 6, value: "PARALLELOGRAM" },
                                    { attrValue: 7, value: "PARALLELOGRAM" }
                                ]
                            }
                        },
                        labelFontSize: 13,
                        labelFontWeight: "bold",
                        labelFontStyle: {
                            discreteMapper: {
                                attrName: "id",
                                entries: [
                                    { attrValue: 6, value: "italic" },
                                    { attrValue: 7, value: "italic" }
                                ]
                            }
                        },
                        borderWidth: 3,
                        borderColor: "#ffffff",
                        
                        size: {
                            defaultValue: 35,
                            continuousMapper: { attrName: "weight", minValue: 35, maxValue: 75}
                        },
                        
                        color: {
                            discreteMapper: {
                                attrName: "id",
                                entries: [
                                    { attrValue: 1, value: "#0B94B1" },
                                    { attrValue: 2, value: "#0B94B1" },
                                    { attrValue: 3, value: "#dddd00" },
                                    { attrValue: 4, value: "#FF00FF" },
                                    { attrValue: 5, value: "#FF00FF" }
                                ]
                            }
                        },
                        labelHorizontalAnchor: "center"
                    },

                    edges: {
                        width: 3,
                        color: "#0B94B1",
                        curvature: 100,
                        style: {
                            discreteMapper: {
                                attrName: "id",
                                entries: [
                                    { attrValue: 11, value: "SOLID" },
                                    { attrValue: 22, value: "DOT" },
                                    { attrValue: 33, value: "DOT" },
                                    { attrValue: 44, value: "DOT" },
                                    { attrValue: 55, value: "DOT" },
                                    { attrValue: 66, value: "LONG_DASH" },
                                    { attrValue: 77, value: "LONG_DASH" }
                                ]
                            }
                        },
                        targetArrowShape :{
                            discreteMapper: {
                                attrName: "id",
                                entries: [
                                    { attrValue: 11, value: "DELTA" },
                                    { attrValue: 22, value: "DELTA" },
                                    { attrValue: 33, value: "DELTA" },
                                    { attrValue: 44, value: "DELTA" },
                                    { attrValue: 55, value: "DELTA" },
                                    { attrValue: 66, value: "NONE" },
                                    { attrValue: 77, value: "NONE" }
                                ]
                            }
                        }
                    }
                };
                
                // initialization options
                var options = {
                    swfPath: "swf/CytoscapeWeb",
                    flashInstallerPath: "swf/playerProductInstall"
                };

                var layout = {
                    name:    "Tree",
                    options: {breadthSpace: 150}
                };
                
                var vis = new org.cytoscapeweb.Visualization(div_id, options);
                
      
                vis.ready(function() {
                
                    // add a listener for when nodes and edges are clicked
                    document.getElementById("color").onclick = function(){
                        visual_style.global.backgroundColor = rand_color();
                        vis.visualStyle(visual_style);
                    };

                    document.getElementById("colordefault").onclick = function(){
                        visual_style.global.backgroundColor = "#ABCFD6";
                        vis.visualStyle(visual_style);
                    };
                    
                    vis.addListener("click", "nodes", function(event) {
                        handle_click(event);
                    })
                    .addListener("click", "edges", function(event) {
                        handle_click(event);
                    });
                    
                    function handle_click(event) {
                         var target = event.target;
                         
                         clear();
                         print("event.group = " + event.group);
                         for (var i in target.data) {
                            var variable_name = i;
                            var variable_value = target.data[i];
                            print( "event.target.data." + variable_name + " = " + variable_value );
                         }
                    }
                    
                    function clear() {
                        document.getElementById("note").innerHTML = "";
                    }
                
                    function print(msg) {
                        document.getElementById("note").innerHTML += "<p>" + msg + "</p>";
                    }
                });

                var draw_options = {
                    // your data goes here
                    network: xml,
                    
                    // show edge labels too
                    edgeLabelsVisible: true,
                    
                    // let's try another layout
                    layout: layout,
                    
                    // set the style at initialisation
                    visualStyle: visual_style,
                    
                    // hide pan zoom
                    panZoomControlVisible: true 
                };
                
                vis.draw(draw_options);
            };