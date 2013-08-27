---
layout: default
name: cookies
permalink: /cookies/
disqus_id: page-1

title: Netscape-format cookies file generator
---

# {{ page.title }}
{: .page-title }

Converts `document.cookie` into a Netscape-format cookies file which is (among other things) suitable for use with [wget](http://www.gnu.org/software/wget), e.g:

    wget --load-cookies cookies.txt http://example.org

**Note**: line breaks and other whitespace in the input don't matter.

<table class="table table-condensed">
  <tbody>
    <tr>
      <td><label for="domain">Domain</label></td>
      <td><input type="text" id="domain" value="example.org" class="input-block-level"></td>
    </tr>

    <tr>
      <td><label for="cookies">Input</label></td>
      <td><textarea id="input" rows="10">remember_me=true; APISID=DijdSAOAjgwijnhFMndsjiejfdSDNSgfsikasASIfgijsowITITeoknsd; static_files=iy1aBf1JhQR</textarea></td>
    </tr>

    <tr>
      <td></td>
      <td><button class="btn" id="generate">Generate</button></td>
    </tr>

    <tr>
      <td><label class="control-label" for="output">Output</label></td>
      <td><textarea id="output" rows="10" wrap="off"></textarea></td>
    </tr>
  </tbody>
</table>

{% include disqus-comments.html %}