{$link_summary_output}
<br />
{checkActionsTpl location="tpl_pligg_pagination_start"}
{$search_pagination}
{checkActionsTpl location="tpl_pligg_pagination_end"}



{literal}

<script type="text/javascript">
// Original JavaScript code by Chirp Internet: www.chirp.com.au
// Please acknowledge use of this code by including this header.

function Hilitor(id, tag)
{

  var targetNode = document.getElementById(id) || document.body;
  var hiliteTag = tag || "EM";
  var skipTags = new RegExp("^(?:" + hiliteTag + "|SCRIPT|FORM|SPAN)$");
  var colors = ["#ff6", "#a0ffff", "#9f9", "#f99", "#f6f"];
  var wordColor = [];
  var colorIdx = 0;
  var matchRegex = "";

  this.setRegex = function(input)
  {
    input = input.replace(/^[^\w]+|[^\w]+$/g, "").replace(/[^\w'-]+/g, "|");
    matchRegex = new RegExp("\\b(" + input + ")\\b","i");
  }

  this.getRegex = function()
  {
    return matchRegex.toString().replace(/^\/\\b\(|\)\\b\/i$/g, "").replace(/\|/g, " ");
  }

  // recursively apply word highlighting
  this.hiliteWords = function(node)
  {
    if(node == undefined || !node) return;
    if(!matchRegex) return;
    if(skipTags.test(node.nodeName)) return;

    if(node.hasChildNodes()) {
      for(var i=0; i < node.childNodes.length; i++)
        this.hiliteWords(node.childNodes[i]);
    }
    if(node.nodeType == 3) { // NODE_TEXT
      if((nv = node.nodeValue) && (regs = matchRegex.exec(nv))) {
        if(!wordColor[regs[0].toLowerCase()]) {
          wordColor[regs[0].toLowerCase()] = colors[colorIdx++ % colors.length];
        }

        var match = document.createElement(hiliteTag);
        match.appendChild(document.createTextNode(regs[0]));
        //match.style.backgroundColor = wordColor[regs[0].toLowerCase()];
        match.style.fontStyle = "inherit";
        match.style.color = "red";

        var after = node.splitText(regs.index);
        after.nodeValue = after.nodeValue.substring(regs[0].length);
        node.parentNode.insertBefore(match, after);
      }
    }
  };

  // remove highlighting
  this.remove = function()
  {
    var arr = document.getElementsByTagName(hiliteTag);
    while(arr.length && (el = arr[0])) {
      el.parentNode.replaceChild(el.firstChild, el);
    }
  };

  // start highlighting at target node
  this.apply = function(input)
  {
    if(input == undefined || !input) return;
    this.remove();
    this.setRegex(input);
    this.hiliteWords(targetNode);
  };

}

</script>



<script type="text/javascript">

var content= $("#leftcol-wide").find('.title').find('h2').find("a:contains("+$("#searchsite")[0].value+")");
var keyword= $("#searchsite")[0].value;

var myHilitor = new Hilitor (content);
//$("#leftcol-wide").find('.title').find('h2').find("a:contains("+$("#searchsite")[0].value+")")

myHilitor.apply(keyword);

//$("div:contains('John')").css("text-decoration", "underline");

//$("#searchsite")[0].value


//$("#leftcol-wide")[0]

for (i=0; i<=$("#searchsite")[0].value.length; i++) 
{
//$("#leftcol-wide").find('.title').find('h2').find("a:contains("+$("#searchsite")[0].value+")").css('color','red');
}


//$("#leftcol-wide").find("span:contains("+$("#searchsite")[0].value+")").css("color","red");

</script>
{/literal}