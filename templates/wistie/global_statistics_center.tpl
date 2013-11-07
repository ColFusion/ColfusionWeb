<style type="text/css">
{literal}
  h1
  {
    font-size: 23px;
    color: #629ACB; 
    margin: 5% 30%;
  }
  .gStatTable
  {
    font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
    width:100%;
    border-collapse:collapse;
    width: 80%;
    margin-left: 10%;
  }
  .gStatTable td, .gStatTable th 
  {
    font-size:1.1em;
    border:1px solid #629ACB;
    padding:3px 7px 2px 7px;
  }
  .gStatTable th 
  {
    font-size:1.2em;
    text-align:left;
    padding-top:5px;
    padding-bottom:4px;
    background-color:#629ACB;
    color:#ffffff;
  }
  .gStatTable tr.alt td 
  {
    color:#000000;
    background-color:#629ACB;
  }
{/literal}
</style>


<h1>Global Statistics</h1>


<table class="gStatTable">
  <tr>
    <th >Data Type</th>
    <th>Total Number</th>
  </tr>
  <tr>
    <td>Datasets</td>
    <td>{$numberOfStories}</td>
  </tr>
  <tr>
    <td>Variables</td>
    <td>{$numberOfDvariables}</td>
  </tr>
  <tr>
    <td>Relationships</td>
    <td>{$numberOfRelationships}</td>
  </tr>
  <tr>
    <td>Records</td>
    <td>{$numberOfRecords}</td>
  </tr>
  <tr>
    <td>Users</td>
    <td>{$numberOfUsers}</td>
  </tr>
</table>






