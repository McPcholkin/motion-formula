# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

include:
  - {{ sls_service_clean }}

motion-cameras-config-clean-file-directory:
   file.directory:
      - name: "{{ motion.path.config }}/conf.d"           
      - clean: True
      - require:
        - sls: {{ sls_service_clean }}

motion-cameras-mask-clean-file-directory:
   file.directory:
      - name: "{{ motion.path.config }}/mask"           
      - clean: True
      - require:
        - sls: {{ sls_service_clean }}


{% set example_config = motion.path.examples~'/motion-dist.conf' %}
{% if salt['file.file_exists'](example_config) %}

motion-config-clean-file-copy:
  file.copy:
    - name: "{{ motion.path.config }}/motion.conf"
    - source: "{{ motion.path.examples }}/motion-dist.conf"
    - force: True
    - require:
      - sls: {{ sls_service_clean }}


motion-example1-config-clean-file-copy:
  file.copy:
    - name: "{{ motion.path.config }}/camera1-dist.conf"
    - source: "{{ motion.path.examples }}/camera1-dist.conf"
    - require:
      - sls: {{ sls_service_clean }}

motion-example2-config-clean-file-copy:
  file.copy:
    - name: "{{ motion.path.config }}/camera2-dist.conf"
    - source: "{{ motion.path.examples }}/camera2-dist.conf"
    - require:
      - sls: {{ sls_service_clean }}

motion-example3-config-clean-file-copy:
  file.copy:
    - name: "{{ motion.path.config }}/camera3-dist.conf"
    - source: "{{ motion.path.examples }}/camera3-dist.conf"
    - require:
      - sls: {{ sls_service_clean }}

motion-example4-config-clean-file-copy:
  file.copy:
    - name: "{{ motion.path.config }}/camera4-dist.conf"
    - source: "{{ motion.path.examples }}/camera4-dist.conf"
    - require:
      - sls: {{ sls_service_clean }}

{% endif %}


