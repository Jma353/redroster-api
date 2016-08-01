$(document).ready(function () {

	// To animate in image divs
	$(function() {

		// Scrollex for intro 
	  $(".spotlight").scrollex({ top: '-10%', bottom: '-10%',
	  	enter: function () {
	  		$(this).animate({ "opacity" : 1 }, 1000); 
	  	}
		}); 

		// Scrollex for features 
	  $('.features').scrollex({ top: '-20%', bottom: '-20%',
	    enter: function() {
    		$("li.one").animate({ "opacity" : 1 }, function () {
    			$("li.two").animate({ "opacity" : 1 }, function () {
    				$("li.three").animate({ "opacity" : 1 });
    			}); 
    		});  
	    }
	  });

		// Scrollex for beta signup  
	  $(".beta-section").scrollex({ top: '-10%', bottom: '-10%',
	  	enter: function () {
	  		$(this).animate({ "opacity" : 1 }, 1000); 
	  	}
		}); 

	});

	// AJAX request for adding email 
	$(".submit-email").on("click", function () {
		var data = { "email" : $(".email-field").val().trim() } 
		$.ajax({
			type: "POST", 
			url: "/home",
			data: data, 
			dataType: "JSON",
		}).success(function (json) {
			// If error 
			console.log(json); 
			if (!json.success) {
				
			} 
			
			$(".email-result").html("Fuck me"); 


		}); 
		return false; 

	}); 



}); 