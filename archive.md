---
layout: default
name: archive
menu: blog
permalink: /archive/

title: archive
---

# {{ page.title }}
{: .page-title }

<table>
  {% for post in site.posts_sorted %}
    {% capture post_year %}
      {{ post.date | date: "%Y" }}
    {% endcapture %}

    {% unless year == post_year %}
      {% assign year = post_year %}
      <tr>
        <td colspan="2">
          <a name="y{{ year }}"></a>
          <h2>{{ year }}</h2>
        </td>
      </tr>
    {% endunless %}

    <tr>
      <td>{{ post.date | date: "%b %d" }}</td>
      <td><a href="{{ post.url }}">{{ post.title }}</a></td>
    </tr>
  {% endfor %}
</table>
