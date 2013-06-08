---
layout: default
name: tags
menu: blog
permalink: /tags/

title: tags
---

# {{ page.title }}
{: .page-title }

{% for tag in site.tags %}
  <h2 id="{{ tag[0] }}">{{ tag[0] }}</h2>

  <ul>
  {% for post in tag[1] %}
    <li><a href="{{ post.url }}">{{ post.title }}</a> ({{ post.date | date_to_string }})</li>
  {% endfor %}
  </ul>
{% endfor %}
