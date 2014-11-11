function checkAnswer() {
  if ($("#guess").val() === answer){
    alert("Correct!")
  } else {
    alert("Nope,"+$(".name").text()+" is from " + answer)
  }
}
