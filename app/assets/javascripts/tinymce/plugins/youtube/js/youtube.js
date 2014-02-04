tinyMCEPopup.requireLangPack();

var YoutubeDialog = {
    init: function () {
        var f = document.forms[0];

        // Get the selected contents as text and place it in the input
        f.youtubeURL.value = tinyMCEPopup.editor.selection.getContent({ format: 'text' });
    },

    insert: function () {
        // Insert the contents from the input into the document
        var url = document.forms[0].youtubeURL.value;
        if (url === null) { tinyMCEPopup.close(); return; }

        var code, regexRes;
        regexRes = url.match("[\\?&]v=([^&#]*)");
        code = (regexRes === null) ? url : regexRes[1];
        if (code === "") { tinyMCEPopup.close(); return; }
        tinyMCEPopup.editor.execCommand('mceInsertContent', false,
            '<iframe width="420" height="315" frameborder="0" allowfullscreen="true" src="//www.youtube.com/embed/'+ code + '"> </iframe>');
        tinyMCEPopup.close();
    }
};

tinyMCEPopup.onInit.add(YoutubeDialog.init, YoutubeDialog);
