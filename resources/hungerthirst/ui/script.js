
$(document).ready(function(){

  window.addEventListener("message", function(event){
    if (event.data.action == "updateStatus"){
      updateStatus(event.data.status);
    }
    else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
      }
    }
  });
  function updateStatus(status){
    var hunger = status[0]
    var thirst = status[1]
    setProgress(hunger.percent,'.progress-hunger');
    setProgress(thirst.percent,'.progress-thirst');
  }
  function setProgress(percent, element){
    $(element).width(percent);
  }

});
