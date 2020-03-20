# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

{# Clean cron job for each camera #}
{% if motion.cameras %}
{% for camera in motion.cameras.items() %}


{# Check exposition parameters are present #}
{% if 'exposition' in camera.1 %}

{% for job in camera.1.exposition.items() %}


motion-{{ camera.0 }}-exposition-{{ job.0 }}-cron-absent:
  cron.absent:
    - identifier: "motion-{{ camera.0 }}-exposition-{{ job.0 }}"
    - user: root


{# for job in camera.1.exposition.items() #}
{% endfor %}


{# if 'exposition' in camera.1 #}
{% endif %}

{# if motion.cameras #}
{% endfor %}
{% endif %}


