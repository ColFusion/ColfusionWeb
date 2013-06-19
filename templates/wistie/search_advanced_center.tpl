        <div class="pagewrap">
            {literal}
				<style content="text/css">
					.commoncss
					{
						border: 3px solid #4169E1;
						padding: 10px;
						text-align : justify;
					}
				</style>
                <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js" type="text/javascript"></script>
				<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
				<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
				<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
				<link rel="stylesheet" href="/resources/demos/style.css" />
				<script>
					function advsubmit(form){
						alert("in the advsubmit method");
						if(document.getElementById('search').value) {
							form.submit();
						} else {
							document.getElementById('response').style.color = '#a44848';
							document.getElementById('search').focus();	
						} 
					}
				</script>
                
				<script type="text/javascript">
						$(document).ready(function()
						{
							$("#dettitle").click(function(){
							$("#hide").slideToggle();
							});
						});
						//functions for datepicker
						$(function() {
                            $( "#totalHouseholdsYear" ).datepicker({
                            changeMonth: true,
                            changeYear: true,
                            dateFormat: "yy-mm-dd",
                            yearRange: "1940:2023"
                            });
                        });
                                                  
                        $(function() {
							$( "#totalHouseholdsYearEnd" ).datepicker({
                            changeMonth: true,
                            changeYear: true,
                            dateFormat: "yy-mm-dd",
                            yearRange: "1940:2023"
                            });
                        });
						
						$(function() {
                            $( "#totalfamilyHouseholdsYear" ).datepicker({
                              changeMonth: true,
                              changeYear: true,
                              dateFormat: "yy-mm-dd",
                              yearRange: "1940:2023",
                              showButtonPannel: true
                             });
                            });
                                                  
                        $(function() {
                          $( "#totalfamilyHouseholdsYearEnd" ).datepicker({
                            changeMonth: true,
                            changeYear: true,
                            dateFormat: "yy-mm-dd",
                            yearRange: "1940:2023",
                            showButtonPannel: true
                            });
                          });
				</script>
				<script type="text/javascript">
					//jquery for the show and hide functionality
				function show_hide_function()
				{
                                   
                    if(document.getElementById("totalhouseholdsButton1").value=="Show")
                        {
                            document.getElementById("totalhouseholdsButton1").value="Hide";
                        }
                    else 
                        {
                            document.getElementById("totalhouseholdsButton1").value="Show";
                        }
                    $("#tohide").slideToggle();
                    getDatasetstotalval();
                }    
                                    
                                    
                                
                function show_hide_function1()
                {
                    if(document.getElementById("totalfamilyhouseholdsButton1").value=="Show")
                        {
                            document.getElementById("totalfamilyhouseholdsButton1").value="Hide";
                        }
                    else 
                        {
                            document.getElementById("totalfamilyhouseholdsButton1").value="Show";
                        }
                    $("#tohide1").slideToggle();
                    getDatasetsavgval();
                }
				</script>
				
				
				<script type="text/javascript">
                                   function verify()
                                    {
									//this is for calculating the total value
                                        if(window.XMLHttpRequest)
                                        {
                                            xmlhttp= new XMLHttpRequest();
                                        }
                                        
                                        var test4=document.getElementById("totalHouseholdsYearEnd").value;
                                        var test3=document.getElementById("dname").value;
                                        var test= document.getElementById("totalHouseholdsLocation").value;
                                        var test2= document.getElementById("totalHouseholdsYear").value;
                                        xmlhttp.open("POST","advancedsearch_underconstruction.php",true);
                                        xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                                        xmlhttp.send("Location="+test+"&YearStart="+test2+"&Dname="+test3+"&YearEnd="+test4);

                                        xmlhttp.onreadystatechange=function()
                                        {
                                        if (xmlhttp.readyState==4 )
                                          {
                                          document.getElementById("result").innerHTML=xmlhttp.responseText;
                                          }
                                        }
                                    }
                                    
                                    function verify1()
                                    {
									//this is for calculating the average value
                                        if(window.XMLHttpRequest)
                                        {
                                            xmlhttp= new XMLHttpRequest();
                                        }
                                        var test4=document.getElementById("totalfamilyHouseholdsYearEnd").value;
                                        var test3=document.getElementById("dname1").value;
                                        var test= document.getElementById("totalfamilyHouseholdsLocation").value;
                                        var test2= document.getElementById("totalfamilyHouseholdsYear").value;
                                        xmlhttp.open("POST","advancedsearch_underconstruction.php",true);
                                        xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                                        xmlhttp.send("Location1="+test+"&YearStart1="+test2+"&Dname1="+test3+"&YearEnd1="+test4);

                                        xmlhttp.onreadystatechange=function()
                                        {
                                        if (xmlhttp.readyState==4 )
                                          {
                                          document.getElementById("result1").innerHTML=xmlhttp.responseText;
                                          }
                                        }
                                    }
                                    
                                    //gets the datasets and the location for total value
                                    function getDatasetstotalval()
                                    {
                                        //for the datasets
                                        if(window.XMLHttpRequest)
                                        {
                                            xmlhttp= new XMLHttpRequest();
                                        }
                                        
                                        //getting the data set for totoal value
                                        value1 = document.getElementById("totoalvaluelocations").value;
                                        xmlhttp.open("POST","onload.php",true);
                                        xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                                        xmlhttp.send("totoalvaluelocations="+value1);

                                        xmlhttp.onreadystatechange=function()
                                        {
                                        if (xmlhttp.readyState==4 )
                                          {
                                            document.getElementById("totoalvaluelocations").innerHTML=xmlhttp.responseText;
                                          }
                                        }
                                    }
                                    
                                    //gets the datasets and the location for average value
                                    function getDatasetsavgval()
                                    {
                                        //for the datasets
                                        if(window.XMLHttpRequest)
                                        {
                                            xmlhttp= new XMLHttpRequest();
                                        }
                                        
                                        //getting the data set for totoal value
                                        value2 = document.getElementById("avgvaluelocations").value;
                                        xmlhttp.open("POST","onload.php",true);
                                        xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                                        xmlhttp.send("avgvaluelocations="+value2);

                                        xmlhttp.onreadystatechange=function()
                                        {
                                        if (xmlhttp.readyState==4 )
                                          {
                                            document.getElementById("avgvaluelocations").innerHTML=xmlhttp.responseText;
                                          }
                                        }
                                    }
									
									$(function()
                                      {
                                          if(window.XMLHttpRequest)
                                        {
                                            xmlhttp= new XMLHttpRequest();
                                        }
                                        
                                        //getting the data set for totoal value
                                        value1 = document.getElementById("totalval").value;
                                        xmlhttp.open("POST","onload.php",true);
                                        xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                                        xmlhttp.send("totalval="+value1);

                                        xmlhttp.onreadystatechange=function()
                                        {
                                        if (xmlhttp.readyState==4 )
                                          {
                                            var data = new Array();
                                            data= xmlhttp.responseText.split( ',' );
                                            $( "#dname" ).autocomplete({
                                               source: data 
                                            });
											$( "#dname1" ).autocomplete({
                                               source: data 
                                            });
                                          }
                                        }
                                      });

                                </script>
                                <script type="text/javascript">
                                    function reset_empty()
                                    {
                                        $('#result').empty();
                                    }
                                    function reset_empty1()
                                    {
                                        $('#result1').empty();
                                    }
                                    
                                </script>
            {/literal}
            <div id="categories">
                <h2 id="cattitle">Search by Categories</h2>
                <ul>
                    {section name=thecat loop=$cat_array}
                        {if $lastspacer eq ""}{assign var=lastspacer value=$cat_array[thecat].spacercount}{/if}
                        {if $cat_array[thecat].auto_id neq 0}
                        
                        {if $cat_array[thecat].spacercount < $submit_lastspacer}</ul></li>{/if}
                        {if $cat_array[thecat].spacercount > $submit_lastspacer}<ul>{/if}
                        <li{if $cat_array[thecat].principlecat neq 0} class="dir"{/if}>
                            <a href="{$URL_queuedcategory, $cat_array[thecat].safename}
                               {php}
                               global $URLMethod;
                               if ($URLMethod==2) print "/";
                               {/php}">{$cat_array[thecat].name}</a>
                            {if $cat_array[thecat].principlecat eq 0}
                        <li>
                        {else}{/if}{assign var=submit_lastspacer value=$cat_array[thecat].spacercount}{/if}
                    {/section}
                    {checkActionsTpl location="tpl_widget_categories_end"}
                    {if $cat_array[thecat].spacercount < $submit_lastspacer}{$lastspacer|repeat_count:'</ul></li>'}{/if}
                </ul>
            </div>
			<div id="detailed">
				<h2 id="dettitle">Advanced Search</h2>
				<!--This fieldset is for total number of Households for a specific year and a location-->
		<form action="advancedsearch_underconstruction.php" method="post">		
        <fieldset class="commoncss" id="totalHouseholds" style="padding: 10">
            <legend>Total Value</legend>
            <div id="totalhouseholds">
                <div id="totalhouseholdstext" style="float: left">Total Datasets for a Specific Time Period
                </div>
                <div id="totalhouseholdsButton" style="float: right">
                    <input value="Show" id="totalhouseholdsButton1" type="button" onclick="show_hide_function()"/>
                </div>
                <div style="clear: both"></div>
                <div id="tohide" style="display: none" style="float: left">
                   <br/>
                   <div>
                       <p>
                        Please choose the Specific Dataitem
                        <br/>
                        <br/>
                        <div class="ui-widget1" id="totalval" value="true">
                            <label for="dname">Datasets: </label>
                            <input id="dname" />
                        </div>
                        <br/>
                        <br/>
                       Please choose the Specific Location and Year
                       <br/>
                       <br/>
                        Location:&nbsp;<span id="totoalvaluelocations" value="true"></span>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <p>Start Date: &nbsp;<input type="text" id="totalHouseholdsYear"/>
                        &nbsp; &nbsp;&nbsp;&nbsp;
                        End Date:&nbsp;<input type="text" id="totalHouseholdsYearEnd"></p>
                        
                       </p>
                       <div>
                           <input value="Display Result" name="totalhouseholdsButton2" type="button" onclick="verify()"/>
                           <input value="Reset" type="button" onclick="reset_empty()"/>
                           <br/>
                           <div id="result"></div>
                       </div>
                   </div>    
                </div>
          </div>   
		<br/>
        </fieldset>
        <!--This fieldset is for total number of Family Households which contains Family Households, Married Couples and Male and Female households-->
        <br/> 
        <fieldset class="commoncss" id="totalFamilyHouseholds" style="padding: 10">
            <br/>
            <legend>Average Value</legend>
            <!--This div is for total number of Family Households for a specific year and a location-->
            <div id="totalfamilyhouseholds">
                <div id="totalfamilyhouseholdstext1" style="float: left">Average Value Of Datasets for a Specific Time Period
                </div>
                <div id="totalfamilyhouseholdsButton" style="float: right">
                    <input value="Show" id="totalfamilyhouseholdsButton1" type="button" onclick="show_hide_function1()"/>
                </div>
                <div style="clear: both"></div>
                <div id="tohide1" style="display: none" style="float: left">
                   <br/>
                   <div>
                       <p>
                        Please choose the Specific Dataset
                        <br/>
                        <br/>
                        <div class="ui-widget2" id="avgval" value="true">
                            <label for="dname1" id="">Datasets: </label>
                            <input id="dname1" />
                        </div>
                        <br/>
                        <br/>
                       Please choose the Specific Location and Year
                       <br/>
                       <br/>
                        Location:&nbsp;
                        <span id="avgvaluelocations" value="true"></span>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<br/>
						<br/>
                        Start Date: &nbsp;<input type="text" id="totalfamilyHouseholdsYear"/>
                        &nbsp; &nbsp;&nbsp;&nbsp;
                        End Date:&nbsp;<input type="text" id="totalfamilyHouseholdsYearEnd">
						<br/>
                       <div>
                           <input value="Display Result" name="totalfamilyhouseholdsButton2" type="button" onclick="verify1()"/>
                           <input value="Reset" type="button" onclick="reset_empty1()"/>
                           <br/>
                           <div id="result1"></div>
                       </div>
                   </div>    
                </div>
          </div>
            <br/>
		</fieldset>
		</form>
			</div>
        </div>
    