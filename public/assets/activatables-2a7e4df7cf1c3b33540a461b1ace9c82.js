/*
Activatables -- Make sets of elements active/inactive through anchors.
Copyright (c) 2009 Andreas Blixt
MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
var activatables=function(){function n(n,t){for(var e=n.className.split(/\s+/),a=t?f:c,r=!1,i=0;i<e.length;i++)(e[i]==f||e[i]==c)&&(r?delete e[i--]:(e[i]=a,r=!0));r||e.push(a),n.className=e.join(" ")}function t(){for(var n=location.hash||"#",t=n.substring(1).split("&"),e={},a=0;a<t.length;a++){var r=t[a].split("=");r[0]&&(e[r[0]]=r[1]||null)}return e}function e(n){var t=[];for(var e in n)n[e]&&t.push(e+"="+n[e]);location.hash=m="#"+t.join("&")}function a(){var n=location.hash;if(n!=m){var e=t();for(var a in e)a in l&&l[a](e[a]);m=n}}function r(n){var e=t();return e[n]}function i(n,a){var r=t();r[n]=a,e(r)}function o(t,e){function a(e){if(!(e in f))return!1;for(var a in f)if(a!=e)for(var r=0;r<f[a].length;r++)n(f[a][r],!1);for(var r=0;r<f[e].length;r++)n(f[e][r],!0);return i(t,e),!0}function o(n,t){if(n instanceof Array)for(var e=0;e<n.length;e++)o(n[e],t);else{if("object"!=typeof n){if("string"==typeof n){var r=t?t.slice(0):[],i=document.getElementById(n);if(!i)throw'Could not find "'+n+'".';if(r.push(i),c||(c=n),f[n]=r,n in v)for(var l=function(n){return function(t){return a(n),t||(t=window.event),t.preventDefault&&t.preventDefault(),t.returnValue=!1,!1}}(n),e=0;e<v[n].length;e++){var u=v[n][e];if(u.addEventListener)u.addEventListener("click",l,!1);else{if(!u.attachEvent)throw"Unsupported event model.";u.attachEvent("onclick",l)}f[n].push(u)}return r}throw"Unexpected type."}for(var h in n){var r=o(h,t);o(n[h],r)}}return t}var f={},c=y;l[t]=a,o(e),c&&(a(r(t))||a(c))}for(var f="active",c="inactive",v={},l={},u=/#([A-Za-z][A-Za-z0-9:._-]*)$/,h=document.getElementsByTagName("a"),s=0;s<h.length;s++){var p=h[s];if((p.pathname==location.pathname||"/"+p.pathname==location.pathname)&&p.search==location.search){var d=u.exec(p.href);if(d){var g=d[1];g in v?v[g].push(p):v[g]=[p]}}}var m=location.hash;setInterval(a,250);var y=null,d=u.exec(m);return d&&(y=d[1]),o}();