/*requires download-icon.js*/

$(document).ready(function(){
  // making sexy unobtrusive CSS possible since 2006
  $("html").addClass("js");

  addFeedButton();
  downloadIcon();
  addTwitter();
  drawGraphs();
  $("#flickr-pic").flickrPolaroid();
  githubActivity();
});