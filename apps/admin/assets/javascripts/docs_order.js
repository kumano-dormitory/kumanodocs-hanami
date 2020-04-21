function setAttributes(element, attrs) {
  for (key in attrs) {
    element.setAttribute(`${key}`, attrs[key]);
  }
};

function post_docs_order(){
  $(function() {
    console.log("post_docs_order()");
    var button = document.getElementById("post_docs_order_btn");
    button.innerHTML = "<i class=\"p-icon--spinner u-animation--spin\"></i> 保存中";
    button.disabled = "disabled";

    var doc_id_list = $("#sortable").sortable("toArray"); // ["3", "8", ...]
    var form = document.getElementById("form_for_doc_order");
    // var formData = new FormData(form);
    for(var i=0; i < doc_id_list.length; i++){
      console.log(doc_id_list[i]);
      console.log(i);
      var dataDiv = document.createElement('div');
      var numberInput = document.createElement('input');
      setAttributes(numberInput, {type:'hidden', name:'document[order][][number]', id:`document-order-${i}-number`, value:i+1})
      var documentIdInput = document.createElement('input');
      setAttributes(documentIdInput, {type:'hidden', name:'document[order][][document_id]', id:`document-order-${i}-document_id`, value:doc_id_list[i]})
      dataDiv.appendChild(numberInput);
      dataDiv.appendChild(documentIdInput);
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

    var form = document.getElementById("post_docs_order_btn");
    form.onclick = post_docs_order;
});
