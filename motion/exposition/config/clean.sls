# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

{# Clean cron job for each camera #}
{% if motion.cameras %}
{% for camera in motion.cameras.items() %}


motion-{{ camera.0 }}-exposition-day-cron-absent:
  cron.absent:
    - identifier: "motion-{{ camera.0 }}-exposition-day"
    - user: root

motion-{{ camera.0 }}-exposition-night-cron-absent:
  cron.absent:
    - identifier: "motion-{{ camera.0 }}-exposition-night"
    - user: root


{% endfor %}
{% endif %}




