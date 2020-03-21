# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

motion-cameras-mask-clean-file-directory:
   file.directory:
      - name: "{{ motion.path.config }}/mask"           
      - clean: True
      - require:
        - sls: {{ sls_service_clean }}


