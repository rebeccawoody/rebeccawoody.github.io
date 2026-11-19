---
layout: page
title: Almanac
permalink: /almanac/
description: An evolving almanac highlighting stars that are relevant to my own work, and others that are personally interesting and/or interesting in pop culture.
nav: true
nav_order: 4
horizontal: true
---

<!-- pages/almanac.md -->
<!-- Only entries with `live: true` are shown. Flip that flag on a stub to publish it. -->
{% assign research_stars = site.almanac | where_exp: "s", "s.live and s.group == 'research'" | sort: "order" %}
{% assign personal_stars = site.almanac | where_exp: "s", "s.live and s.group == 'personal'" | sort: "order" %}
<div class="projects">
  <div class="container">
    {% if research_stars.size > 0 %}
    <div class="row row-cols-1">
    {% for entry in research_stars %}
      {% include almanac_horizontal.liquid %}
    {% endfor %}
    </div>
    {% endif %}
    {% if research_stars.size > 0 and personal_stars.size > 0 %}
    <hr class="almanac-divider my-5">
    {% endif %}
    {% if personal_stars.size > 0 %}
    <div class="row row-cols-1">
    {% for entry in personal_stars %}
      {% include almanac_horizontal.liquid %}
    {% endfor %}
    </div>
    {% endif %}
  </div>
</div>
