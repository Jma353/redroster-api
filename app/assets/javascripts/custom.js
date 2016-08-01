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
			if (!json.success) {
				$(".email-result").html(json.data.error); 
			} else {
				$(".email-result").html("Thanks for signing up for the beta!  We'll send you a beta key extremely soon.");
			}
			
		}); 
		return false; 

	}); 


	// AJAX request for adding email 
	$(".submit-pass").on("click", function () {
		var data = { "pass" : $(".pass-field").val().trim() } 
		$.ajax({
			type: "POST", 
			url: "/beta",
			data: data, 
			dataType: "JSON",
		}).success(function (json) {
			// If error 
			if (!json.success) {
				$(".beta-testers").html("You are not authorized to see these"); 
			} else { 
				var listOfTesters = ""; 
				json.data.forEach(function (d) {
					listOfTesters += d.email + "</br>"; 
				}); 
				$(".beta-testers").html(listOfTesters); 
			}
			
		}); 
		return false; 

	}); 



}); 








