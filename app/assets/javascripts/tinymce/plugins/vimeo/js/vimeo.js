tinyMCEPopup.requireLangPack();

var VimeoDialog = {
    init: function () {
        var f = document.forms[0];

        // Get the selected contents as text and place it in the input
        f.vimeoURL.value = tinyMCEPopup.editor.selection.getContent({ format: 'text' });
    },

    insert: function () {
        // Insert the contents from the input into the document
        var url = document.forms[0].vimeoURL.value;
        if (url === null) { tinyMCEPopup.close(); return; }

        var code, regexRes;
        if(url.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/))
        {
            var parser = document.createElement('a');
            parser.href = url;
            code = parser.pathname;
        } else {
            code = '/'+ url ;
        }

        
        if (code === "") { tinyMCEPopup.close(); return; }
        tinyMCEPopup.editor.execCommand('mceInsertContent', false,
            '<div id="video-tag"><iframe width="500" height="281" frameborder="0" allowfullscreen="" src="//player.vimeo.com/video'+ code +'?badge=0"></iframe></div>');
        tinyMCEPopup.close();
    }
};

tinyMCEPopup.onInit.add(VimeoDialog.init, VimeoDialog);
