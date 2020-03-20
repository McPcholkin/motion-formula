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


{# Check exposition parameters are present #}
{% if 'exposition' in camera.1 %}

{% for job in camera.1.exposition.items() %}

{% if 'time' in job.1 %}
{% if 'hour' in job.1.time %}
{% if 'minute' in job.1.time %}

{# Trick to update variable in loop
 # https://stackoverflow.com/questions/46939756/setting-variable-in-jinja-for-loop-doesnt-persist-between-iterations 
 # #}
{% set ns = namespace(job_parameters='v4l2-ctl -d ' ~ camera.1.config.videodevice ~ ' ') %}

{# get all parameters for job #}
{% for param, value in job.1.config.items() %}

{# concatenation string with parameters and values #}
{% set ns.job_parameters = ns.job_parameters ~ '--set-ctrl=' ~ param ~ '=' ~ value ~ ' ' %}

{# for param, value in job.1.config.items() #}
{% endfor %}


motion-{{ camera.0 }}-exposition-{{ job.0 }}-cron-present:
  cron.present:
    - name: "{{ ns.job_parameters }}"
    - identifier: "motion-{{ camera.0 }}-exposition-{{ job.0 }}"
    - user: root
    - hour: {{ job.1.time.hour }}
    - minute: {{ job.1.time.minute }}


{# if 'minute' in job.1.time #}
{% else %}

WARNING-motion-{{ camera.0 }}-exposition-{{ job.0 }}-test-show_notification:
  test.show_notification:
    - name: "WARNING cron job for {{ camera.0 }} exposition {{ job.0 }} cannot be created"
    - text: "minute - parameter not defined in pillar!"

{% endif %}

{# if 'hour' in job.1.time #}
{% else %}

WARNING-motion-{{ camera.0 }}-exposition-{{ job.0 }}-test-show_notification:
  test.show_notification:
    - name: "WARNING cron job for {{ camera.0 }} exposition {{ job.0 }} cannot be created"
    - text: "hour - parameter not defined in pillar!"

{% endif %}

{# if 'time' in job.1 #}
{% else %}

WARNING-motion-{{ camera.0 }}-exposition-{{ job.0 }}-test-show_notification:
  test.show_notification:
    - name: "WARNING cron job for {{ camera.0 }} exposition {{ job.0 }} cannot be created"
    - text: "time - parameter not defined in pillar!"

{% endif %}

{# for job in camera.1.exposition.items() #}
{% endfor %}


{# if 'exposition' in camera.1 #}
{% endif %}

{# if motion.cameras #}
{% endfor %}
{% endif %}


