$(document).ready(function() {
  tinymce.init({selector:'.js--wysiwyg',
    menubar: false,
    height: 300,
    width: '100%',
    statusbar: false,
    browser_spellcheck : true,
    plugins: 'link table',
    toolbar1: 'bold italic underline strikethrough | bullist numlist | cut copy paste | link unlink | table | undo redo',
    paste_word_valid_elements: 'ol,ul,li,b,strong,i,em,u,ins',
    target_list: false,
    link_title: false,
    valid_elements : "@[id|class|style|title],a[rel|rev|href|target|title|class],strong/b,em/i,strike/s,u,"
                      + "#p,-ol[type|compact],-ul[type|compact],-li,br,-blockquote,-div,"
                      + "-span,address,-h1,-h2,-h3,-h4,-h5,-h6,-font[style|color],"
                      + "del[datetime|cite],ins[datetime|cite],q[cite],small,big",
    valid_styles : { '*' : 'color,font-weight,font-style,text-decoration,align' }
    })
});
