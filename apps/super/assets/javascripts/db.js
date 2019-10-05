function post_cmd() {
  var command = document.getElementById("cmd-input").value;
  var csrf_token = document.getElementById("csrf_token").value;

  $.ajax({
    url: "/super/db",
    method: "POST",
    cache: false,
    data: {cmd: command, _csrf_token: csrf_token}
  }).done(function(data, status, xhr) {
    $("#result").append(data);
    document.getElementById("cmd-input").value = "";
  });
}


var form = document.getElementById('command-form');
form.addEventListener("submit", function(event) {
  post_cmd();
  event.preventDefault();
}, false);
