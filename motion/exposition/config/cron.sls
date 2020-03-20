# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}


{# Create cron job for each camera #}
{% if motion.cameras %}
{% for camera in motion.cameras.items() %}


{# Check if all parameters are present #}
{% if 'exposition' in camera.1 %}
{% if 'day' in camera.1.exposition %}
{% if 'night' in camera.1.exposition %}
{% if 'power_line_frequency' in camera.1.exposition.day %}
{% if 'power_line_frequency' in camera.1.exposition.night %}
{% if 'gamma' in camera.1.exposition.day %}
{% if 'gamma' in camera.1.exposition.night %}
{% if 'time' in camera.1.exposition.day %}
{% if 'time' in camera.1.exposition.night %}
{% if 'hour' in camera.1.exposition.day.time %}
{% if 'hour' in camera.1.exposition.night.time %}
{% if 'minute' in camera.1.exposition.day.time %}
{% if 'minute' in camera.1.exposition.night.time %}


motion-{{ camera.0 }}-exposition-day-cron-present:
  cron.present:
    - name: "v4l2-ctl --set-ctrl=power_line_frequency={{  camera.1.exposition.day.power_line_frequency }} --set-ctrl=gamma={{ camera.1.exposition.day.gamma }} -d {{ camera.1.config.videodevice }}"
    - identifier: "motion-{{ camera.0 }}-exposition-day"
    - user: root
    - hour: {{ camera.1.exposition.day.time.hour }}
    - minute: {{ camera.1.exposition.day.time.minute }}


motion-{{ camera.0 }}-exposition-night-cron-present:
  cron.present:
    - name: "v4l2-ctl --set-ctrl=power_line_frequency={{  camera.1.exposition.night.power_line_frequency }} --set-ctrl=gamma={{ camera.1.exposition.night.gamma }} -d {{ camera.1.config.videodevice }}"
    - identifier: "motion-{{ camera.0 }}-exposition-night"
    - user: root
    - hour: {{ camera.1.exposition.night.time.hour }}
    - minute: {{ camera.1.exposition.night.time.minute }}



{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}
{% endif %}


{% endfor %}
{% endif %}




