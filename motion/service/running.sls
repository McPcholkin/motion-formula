# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

include:
  - {{ sls_config_file }}

motion-service-running-service-running:
  service.running:
    - name: {{ motion.service.name }}
    - enable: True
    - require:
      - sls: {{ sls_config_file }}

motion-daemon-enabled-file-managed:
  file.managed:
    - name: {{ motion.path.default_daemon}}
    - contents:
      - '####################################'
      - '# File managed by Salt.'
      - '# Your changes will be overwritten.'
      - '# '
      - '# default: start_motion_daemon=no '
      - '####################################'
      - 'start_motion_daemon=yes'
    - require:
      - sls: {{ sls_package_install }}
    - require_in:
      - service: motion-service-running-service-running
