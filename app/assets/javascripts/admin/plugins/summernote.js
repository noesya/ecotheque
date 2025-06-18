/*global $ */
window.summernoteManager = {
    configs: {},

    init: function () {
        'use strict';
        this.setConfigs();
        this.initEditors();
        this.monkeyPatchDropdownButtons();
        this.monkeyPatchDropdownClosing();
    },

    setConfigs: function () {
        'use strict';
        this.setConfig('default', {
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic']],
                ['para', ['ul', 'ol']],
                ['insert', ['link', 'unlink']],
                ['view', ['codeview']]
            ],
            styleTags: [
                'p',
                'h3'
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['b', 'strong', 'i', 'em', 'a', 'ul', 'ol', 'li', 'p', 'h3'], ['href', 'target'])
            }
        });

        this.setConfig('without_styles', {
            toolbar: [
                ['font', ['bold', 'italic']],
                ['para', ['ul', 'ol']],
                ['insert', ['link', 'unlink']],
                ['view', ['codeview']]
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['b', 'strong', 'i', 'em', 'a', 'ul', 'ol', 'li', 'p'], ['href', 'target'])
            }
        });

        this.setConfig('mini', {
            toolbar: [
                ['font', ['bold', 'italic']],
                ['insert', ['link', 'unlink']],
                ['view', ['codeview']]
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['b', 'strong', 'i', 'em', 'a', 'p'], ['href', 'target'])
            }
        });

        window.SUMMERNOTE_CONFIGS = this.configs;
    },

    setConfig: function (key, data) {
        'use strict';
        this.configs[key] = data;
    },

    initEditors: function () {
        'use strict';
        $('[data-provider="summernote"]').each(this.initEditor.bind(this));
    },

    initEditor: function (_, element) {
        'use strict';
        var config = $(element).attr('data-summernote-config'),
            options = {};
        config = config || 'default';
        options = this.configs[config];
        options['lang'] = 'fr-FR';
        $(element).summernote(options);
    },

    monkeyPatchDropdownButtons: function () {
        'use strict';
        // https://github.com/summernote/summernote/issues/4170
        $('button[data-toggle="dropdown"]').each(function () {
            $(this).removeAttr('data-toggle')
                .attr('data-bs-toggle', 'dropdown');
        });
    },

    monkeyPatchDropdownClosing: function () {
        'use strict';
        $(document).on('click', '.note-dropdown-menu .dropdown-item', function (e) {
            var dropdownMenu = e.currentTarget.parentNode,
                dropdownBtn = dropdownMenu.previousElementSibling;
            dropdownMenu.classList.remove('show');
            dropdownBtn.classList.remove('show');
        });
    },

    pasteSanitizedClipboardContent: function (allowedTags, allowedAttributes, event) {
        'use strict';
        var text = event.originalEvent.clipboardData.getData('text/plain'),
            html = event.originalEvent.clipboardData.getData('text/html');

        event.preventDefault();
        if (html) {
            html = html.toString();
            html = this.cleanHtml(html);
            html = this.sanitizeTags(html, allowedTags);
            html = this.sanitizeAttributes(html, allowedAttributes);
            document.execCommand('insertHTML', false, html);
        } else {
            document.execCommand('insertText', false, text);
        }
    },

    cleanHtml: function (html) {
        'use strict';
        // remove allMicrosoft Office tag
        html = html.replace(/<!\[if !supportLists[\s\S]*?endif\]>/g, '');
        // remove all html comments
        html = html.replace(/<!--[\s\S]*?-->/g, '');
        // remove all microsoft attributes,
        html = html.replace(/( class=(")?Mso[a-zA-Z]+(")?)/g, ' ');
        // ensure regular quote
        html = html.replace(/[\u2018\u2019\u201A]/g, '\'');
        // ensure regular double quote
        html = html.replace(/[\u201C\u201D\u201E]/g, '"');
        // ensure regular ellipsis
        html = html.replace(/\u2026/g, '...');
        // ensure regular hyphen
        html = html.replace(/[\u2013\u2014]/g, '-');
        return html;
    },

    sanitizeTags: function (html, allowedTags) {
        'use strict';
        var allowedTagsRegex = allowedTags.map(function (e) {
                return '(?!' + e + ')';
            }).join(''),
            tagStripper = new RegExp('</?' + allowedTagsRegex + '\\w*\\b[^>]*>', 'ig');

        return html.replace(tagStripper, '');
    },

    sanitizeAttributes: function (html, allowedAttributes) {
        'use strict';
        var div = document.createElement('div');
        div.innerHTML = html;
        this.sanitizeElementAttributes(div, allowedAttributes);
        return div.innerHTML;
    },

    sanitizeElementAttributes: function (elmt, allowedAttributes) {
        'use strict';
        var children = elmt.children,
            child,
            i,
            j;
        for (i = 0; i < children.length; i += 1) {
            child = children[i];
            for (j = child.attributes.length - 1; j >= 0; j -= 1) {
                if ($.inArray(child.attributes[j].name, allowedAttributes) < 0) {
                    child.removeAttributeNode(child.attributes[j]);
                }
            }

            if (child.children.length) {
                this.sanitizeElementAttributes(child, allowedAttributes);
            }
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
};

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.summernoteManager.init();
});
