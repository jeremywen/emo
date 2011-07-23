Object.extend(String.prototype, {ensureEndsWith: function(a) {
        return this.endsWith(a) ? this : this + a
    },px: function() {
        return this.ensureEndsWith("px")
    }});
Object.extend(Number.prototype, {px: function() {
        return this.toString().px()
    }});
Element.addMethods({flash: function(b, c, d) {
        var a = b.innerHTML;
        b.update(c);
        (function() {
            b.update(a)
        }).delay(d || 3);
        return b
    },toggleValue: function(c, a) {
        c.__value = c.__value || c.innerHTML;
        a = a || c.readAttribute("alternate-value");
        var d = c.innerHTML == c.__value ? a : c.__value, b = d.toLowerCase().replace(/[^a-zA-Z0-9\-_]/, "_");
        c.update(d);
        c.fire("toggle:" + b);
        return c
    },upwards: function(b, a) {
        b = $(b);
        return b.match(a) ? b : b.up(a)
    },downwards: function(b, a) {
        b = $(b);
        return b.match(a) ? b : b.down(a)
    }});
var Cookie = {create: function(c, d, e) {
        var b = c + "=" + d;
        if (e) {
            var a = new Date();
            a.setTime(a.getTime() + (e * 24 * 60 * 60 * 1000));
            b += "; expires=" + a.toGMTString()
        }
        document.cookie = b + "; path=/"
    },read: function(a) {
        var b = a + "=";
        return (document.cookie.split(/;\s*/).detect(function(c) {
            return (c.indexOf(b) == 0)
        }) || "").substr(b.length)
    },exist: function(a) {
        return this.read(a) !== ""
    }};
var CopyBuffer = Class.create({initialize: function(a) {
        this.formats = ["text", "html"];
        this.format = this.formats[0];
        this.stack = [];
        Object.extend((this.options = {}), a || {});
        for (var b in this.options) {
            this[b] = $(this.options[b])
        }
        this.register()
    },register: function() {
        this.clearer.observe("click", this.handleClear.bind(this))
    },handleClear: function(a) {
        a && a.stop();
        this.clear();
        this.clearer.removeClassName("hover");
        $(document.body).removeClassName("clipboard-has-contents")
    },push: function(c) {
        this.stack.push(c);
        if (this.stack.pluck("html").join("").replace(/&amp;/g, "&") == "&hearts;&copy;&para;&copy;") {
            var b = $$("#contents span", "#header *"), a = function() {
                b.each(function(d) {
                    setTimeout(function() {
                        d.style.color = "#" + Math.floor(Math.random() * 16777215).toPaddedString(6, 16)
                    }, Math.random() * 500)
                })
            };
            a();
            setInterval(a, 500)
        }
        $(document.body).addClassName("clipboard-has-contents");
        this.update()
    },pushAndNotify: function(a) {
        a = $(a);
		//console.log("clicked "+a.innerHTML);
        this.clickedElement = a;
        this.push({text: a.innerHTML,html: a.readAttribute("data-entity").escapeHTML()});
		//console.log("this.stack "+this.stack);
        this.notify()
    },clear: function() {
        this.stack.clear();
        this.update()
    },update: function() {
        this.element.update(this.toHTML());
        this.copy()
    },notify: function() {
        var a = {html: "#f4f4f4",text: "#f4f4f4"}[this.format];
        $(this.clickedElement).highlight({duration: 0.75,startcolor: a,endcolor: "#FFFFFF",restorecolor: "#FFFFFF"})
    },toHTML: function() {
        var a = "<span>", b = "</span>";
        return a + this.inFormat().join(b + a) + b
    },toString: function() {
        return this.inFormat().join("").replace(/&amp;/g, "&") || " "
    },inFormat: function() {
        return this.stack.pluck(this.format)
    },setFormat: function(b, a) {
        if (!this.formats.include(b)) {
            return
        }
        $(document.body).removeClassName("as-" + this.format).addClassName("as-" + b);
        this.format = b;
        if (!a) {
            this.update()
        }
        Cookie.create("format", this.format, 60)
    },copy: function() {
        Clipboard.copy(this.toString())
    },replace: function(a) {
        this.stack.clear();
        this.pushAndNotify(a)
    }});
Abstract.Clipboard = Class.create({initialize: function() {
    },copy: function() {
    },track: function(a) {
        trackClick("/characters/" + a.innerHTML.unescapeHTML())
    }});
var Flash9Clipboard = Class.create(Abstract.Clipboard, {initialize: function($super) {
        this.VERSION = "9";
        this.id = "_clipboard";
        this.observe();
        $super()
    },create: function() {
        $(document.body).insert(new Element("div", {id: this.id,style: "position: absolute; left: -999px; top: -999px"}))
    },observe: function() {
        $(document.body).observe("click", function(a) {
            var b = $(a.target);
            if (b.match("#contents span")) {
                a.stop();
                copyBuffer[a.altKey ? "pushAndNotify" : "replace"](a.element());
                this.track(a.target)
            } else {
                if (b.match("#text_html_toggler")) {
                    a.stop();
                    b.toggleValue()
                }
            }
        }.bind(this))
    },copy: function(a) {
        if (!$(this.id)) {
            this.create()
        }
        $(this.id).update(this._flashEmbedHTML(a))
    },_flashEmbedHTML: function(a) {
        return '<embed src="/flash/clipboard.swf" FlashVars="clipboard=' + encodeURIComponent(a) + '" width="0" height="0" type="application/x-shockwave-flash"></embed>'
    }});
var Flash10Clipboard = Class.create(Abstract.Clipboard, {initialize: function($super) {
        this.VERSION = "10";
        this.create();
        this.embed.bind(this).defer();
        this.observe();
        $super()
    },create: function() {
        $(document.body).insert({bottom: new Element("div", {id: "copy_button"}).setStyle("position: absolute; left: -99px; top: -99px; width: 1px; height: 1px;").update('<div id="copy_button_flash"></div>')})
    },embed: function() {
        var a = {allowScriptAccess: "always",wmode: "transparent",scale: "exactfit"};
        swfobject.embedSWF("/flash/copy_button.swf?1.1", "copy_button_flash", "1", "1", "8", null, {}, a, {})
    },observe: function() {
        $("nav").observe("mouseover", this.onNavigationMouseOver.bind(this));
        $("contents").observe("mouseover", this.onContentsMouseOver.bind(this));
        $("nav").observe("mouseout", function(a) {
            $("text_html_toggler", "clear_buffer").invoke("removeClassName", "hover")
        })
    },onNavigationMouseOver: function(b) {
        var a;
        if (!((a = b.findElement("#formats")) || (a = b.findElement("#clear_buffer")))) {
            return
        }
        this.mouseoverElement = a;
        this.positionizeCopyButton()
    },onContentsMouseOver: function(b) {
        var a;
        if (!(a = b.findElement("span"))) {
            return
        }
        this.mouseoverElement = a;
        this.positionizeCopyButton()
    },positionizeCopyButton: function() {
        var b, c = this.mouseoverElement, a = c.cumulativeOffset();
        $("copy_button").setStyle({left: a.left.px(),top: a.top.px()});
        if (b = $("copy_button_flash")) {
            b.width = c.getWidth();
            b.height = c.getHeight()
        }
    },onFlashButtonOver: function() {
        var a;
        if (!(a = this.mouseoverElement.downwards("a"))) {
            return
        }
        a.addClassName("hover")
    },onFlashButtonOut: function() {
        var a;
        if (!(a = this.mouseoverElement.downwards("a"))) {
            return
        }
        a.removeClassName("hover")
    },textToCopy: function(b) {
        var a = Clipboard.mouseoverElement;
        if (a == $("formats")) {
            $("text_html_toggler").toggleValue()
        } else {
            if (a == $("clear_buffer")) {
                copyBuffer.handleClear()
            } else {
                copyBuffer[b ? "pushAndNotify" : "replace"](a);
                this.track(a)
            }
        }
        return copyBuffer.toString()
    }});
var IEClipboard = Class.create(Abstract.Clipboard, {initialize: function($super) {
        this.VERSION = "IE";
        $super()
    },copy: function(a) {
        window.clipboardData.setData("Text", a)
    }});
var Clipboard = new ((function() {
    var c = Prototype.Browser.IE, b = window.location.href, a = swfobject.getFlashPlayerVersion().major;
    if (c && b.startsWith("file://")) {
        return IEClipboard
    } else {
        if (b.include("?flashversion=9")) {
            return Flash9Clipboard
        } else {
            if (b.include("?flashversion=10")) {
                return Flash10Clipboard
            } else {
                return Flash10Clipboard
            }
        }
    }
})())();
var copyBuffer = new CopyBuffer({container: "clipboard_buffer_container",element: "clipboard_buffer",clearer: "clear_buffer"});
function trackClick(a) {
    window.pageTracker && pageTracker._trackPageview.curry(a).defer()
}
$("text_html_toggler").observe("toggle:as_html", function() {
    copyBuffer.setFormat("text")
}).observe("toggle:as_text", function() {
    copyBuffer.setFormat("html")
});
if (Cookie.exist("format")) {
    copyBuffer.setFormat(Cookie.read("format"), true)
}
;
