$(document).ready(function(){
	$("a").each(function(){
		link = $(this);
		if (link.attr("id").match(/IDShowComment/)) {
			id = link.attr("id").replace("IDShowCommentLink", "");
			link.click(function(){
				return false;
			})			
		}
	})
})