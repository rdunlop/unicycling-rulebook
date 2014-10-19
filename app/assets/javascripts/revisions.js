function getStats(id) {
    var body = tinymce.get(id).getBody(), text = tinymce.trim(body.innerText || body.textContent);

    return {
        chars: text.length,
        words: text.split(/[\w\u2019\'-]+/).length
    };
}

$(document).ready(function() {
  //= form.text_area :background, {class: "js--wysiwyg js--wordcount", data: { wordCountField: 'countdown', maxCharacters: $MAX_CHARACTERS.to_s } }
  $('.js--wordcountNOTWORKING').each(function(i, elem) {
    tmc = tinyMCE.editors[elem.id];
    tmc.onKeyDown.add(function(ed, e) {
      console.log("key pressed " + ed);
    });
  });
});
function limitText(limitField, limitCount, limitNum) {
  if (limitField.value.length > limitNum) {
    limitField.value = limitField.value.substring(0, limitNum);
  } else {
    limitCount.value = limitNum - limitField.value.length;
  }
}
