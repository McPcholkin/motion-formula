# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

motion-service-clean-service-dead:
  service.dead:
    - name: {{ motion.service.name }}
    - enable: False


motion-daemon-clean-file-managed:
  file.managed:
    - name: {{ motion.path.default_daemon}}
    - contents:
      - '####################################'
      - '# File managed by Salt.'
      - '# Your changes will be overwritten.'
      - '####################################'
      - 'start_motion_daemon=no'
