function setAttributes(element, attrs) {
  for (key in attrs) {
    element.setAttribute(`${key}`, attrs[key]);
  }
};

function post_article_order(){
  $(function() {
    console.log("post_article_order()");
    var button = document.getElementById("post_article_order_btn");
    button.innerHTML = "<i class=\"p-icon--spinner u-animation--spin\"></i> 保存中";
    button.disabled = "disabled";

    var article_id_list = $("#sortable").sortable("toArray"); // ["3", "8", ...]
    var form = document.getElementById("form_for_article_order");
    // var formData = new FormData(form);
    for(var i=0; i < article_id_list.length; i++){
      console.log(article_id_list[i]);
      console.log(i);
      var dataDiv = document.createElement('div');
      var numberInput = document.createElement('input');
      setAttributes(numberInput, {type:'hidden', name:'meeting[articles][][number]', id:`meeting-articles-${i}-number`, value:i+1})
      var articleIdInput = document.createElement('input');
      setAttributes(articleIdInput, {type:'hidden', name:'meeting[articles][][article_id]', id:`meeting-articles-${i}-article_id`, value:article_id_list[i]})
      dataDiv.appendChild(numberInput);
      dataDiv.appendChild(articleIdInput);
      form.appendChild(dataDiv);
    }
    form.submit();
  });
};

$(function() {
    $( "#sortable" ).sortable({
      axis: "y",
      placeholder: "ui-state-highlight"
    });
    $( "#sortable" ).disableSelection();

    var form = document.getElementById("post_article_order_btn");
    form.onclick = post_article_order;
});
