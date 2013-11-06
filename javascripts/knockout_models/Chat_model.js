$(document).ready(function(){
	onlineUsers.init();
});

var onlineUsers = {

	data : {
		lastID 		: 0,
		noActivity	: 0
	},

	init : function(){
		// We use the working variable to prevent
		// multiple form submissions:
		
		var working = false;
		// Converting the #chatLineHolder div into a jScrollPane,
		// and saving the plugin's API in chat.data:
		
		onlineUsers.data.jspAPI = $('#chatLineHolder').jScrollPane({
			verticalDragMinHeight: 12,
			verticalDragMaxHeight: 12
		}).data('jsp');

		// Submitting a new chat entry:
		
		$('#submitButton').click(function(){
			
			var text = $('#chatText').val();
			if(text.length == 0){
				return false;
			}
			
			if(working) return false;
			working = true;
			
			// Assigning a temporary ID to the chat:
			var tempID = 't'+Math.round(Math.random()*1000000),
				params = {
					id			: tempID,
					author		: onlineUsers.data.name,
					text		: text.replace(/</g,'&lt;').replace(/>/g,'&gt;')
				};
			
			$.ajax({
		        url: '/Colfusion/chat/chatController.php?action=submitChat&details='+params.text, 
		        type: 'get',
		        dataType: 'json',
		        success: function (data) {
					working = false;
				
					$('#chatText').val('');
					params['id'] = data.id;
			        }
    			});
			return false;
		});
		
		(function getChatsTimeoutFunction(){
			onlineUsers.getChats(getChatsTimeoutFunction);
		})();

		(function getUsersTimeoutFunction(){
			onlineUsers.getUsers(getUsersTimeoutFunction);
		})();
	},
	// The addChatLine method ads a chat entry to the page
	
	addChatLine : function(params){
		
		// All times are displayed in the user's timezone
		
		var d = new Date();

		if(params.time) {
			
			d.setHours(params.time.hours,params.time.minutes);
		}
		
		params.time = (d.getHours() < 10 ? '0' : '' ) + d.getHours()+':'+
					  (d.getMinutes() < 10 ? '0':'') + d.getMinutes();
		
		var markup = onlineUsers.render('chatLine',params),
			exists = $('#chatLineHolder .chat-'+params.id);

		if(exists.length){
			exists.remove();
		}
		
		if(!onlineUsers.data.lastID){
			// If this is the first chat, remove the
			// paragraph saying there aren't any:
			
			$('#chatLineHolder p').remove();
		}
		
		// If this isn't a temporary chat:
		if(params.id.toString().charAt(0) != 't'){
			var previous = $('#chatLineHolder .chat-'+(+params.id - 1));
			if(previous.length){
				previous.after(markup);
			}
			else onlineUsers.data.jspAPI.getContentPane().append(markup);
		}
		else onlineUsers.data.jspAPI.getContentPane().append(markup);
		
		// As we added new content, we need to
		// reinitialise the jScrollPane plugin:
		
		onlineUsers.data.jspAPI.reinitialise();
		onlineUsers.data.jspAPI.scrollToBottom(true);
		
	},
	getChats : function(callback){
		$.ajax({
	        url: '/Colfusion/chat/chatController.php?action=getChats&lastID='+onlineUsers.data.lastID, 
	        type: 'get',
	        dataType: 'json',
	        success: function (data) {
				for(var i=0;i<data.chats.length;i++){
					onlineUsers.addChatLine(data.chats[i]);
				}
				
				if(data.chats.length){
					onlineUsers.data.noActivity = 0;
					onlineUsers.data.lastID = data.chats[i-1].id;
				}
				else{
					// If no chats were received, increment
					// the noActivity counter.
					onlineUsers.data.noActivity++;
				}
				
				if(!onlineUsers.data.lastID){
					onlineUsers.data.jspAPI.getContentPane().html('<p class="noChats">No chats yet</p>');
				}
				
				// Setting a timeout for the next request,
				// depending on the chat activity:
				
				var nextRequest = 1000;
				
				// 2 seconds
				if(onlineUsers.data.noActivity > 3){
					nextRequest = 2000;
				}
				
				if(onlineUsers.data.noActivity > 10){
					nextRequest = 5000;
				}
				
				// 15 seconds
				if(onlineUsers.data.noActivity > 20){
					nextRequest = 15000;
				}
			
				setTimeout(callback,nextRequest);
	        }
    	});
	},
	getUsers : function(callback){
		$.ajax({
	        url: '/Colfusion/chat/chatController.php?action=getAllOnlineUsers', 
	        type: 'get',
	        dataType: 'json',
	        success: function (data) {
	            var users = [];
				if(data.users){
					for(var i=0; i< data.users.length;i++){
						if(data.users[i]){
							users.push(onlineUsers.render('user',data.users[i]));
						}
					}
				}
				var message = '';
				
				if(data.total<1){
					message = 'No one is online';
				}
				else {
					message = data.total+' '+(data.total == 1 ? 'person':'people')+' online';
				}
				
				users.push('<p class="count">'+message+'</p>');
				
				$('#chatUsers').html(users.join(''));
				
				setTimeout(callback,15000);
	        }
    	});
	},
	render : function(template,params){
		
		var arr = [];
		switch(template){
			
			case 'chatLine':
				arr = [
					'<div class="chat chat-',params.id,' rounded"><span class="author">',params.author,
					':</span><span class="text">',params.text,'</span><span class="time">',params.time,'</span></div>'];
			break;
			
			case 'user':
				arr = [
					'<div class="user" title="',params.name,'"><img src="',
					params.gravatar,'" width="30" height="30" onload="this.style.visibility=\'visible\'" /></div>'
				];
			break;
		}
		
		// A single array join is faster than
		// multiple concatenations
		
		return arr.join('');
		
	},
}

$.fn.defaultText = function(value){
	
	var element = this.eq(0);
	element.data('defaultText',value);
	
	element.focus(function(){
		if(element.val() == value){
			element.val('').removeClass('defaultText');
		}
	}).blur(function(){
		if(element.val() == '' || element.val() == value){
			element.addClass('defaultText').val(value);
		}
	});
	
	return element.blur();
}