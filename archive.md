---
layout: default
name: archive
menu: blog
permalink: /archive/

title: archive
---

# {{ page.title }}
{: .page-title }

<ul>
  {% for post in site.posts %}
    {% capture post_year %}{{ post.date | date: "%Y" }}{% endcapture %}
    {% unless year == post_year %}{% assign year = post_year %}<a name="y{{ year }}"></a><h2>{{ year }}</h2>{% endunless %}
    {% capture post_month %}{{ post.date | date: "%B" }}{% endcapture %}
    {% unless month == post_month %}{% assign month = post_month %}<a name="{{ month | downcase }}{{ year }}"></a><h3>{{ month }}</h3>{% endunless %}

    <li>
      <span class="day">{{ post.date | date: "%d" }}</span>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>