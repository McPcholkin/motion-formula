# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

motion-config-file-file-managed:
  file.managed:
    - name: {{ map.config_path }}
    - source: {{ files_switch(['ini.tmpl.jinja'],
                              lookup='motion-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: root
    - makedirs: False
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        TEMPLATE: {{ TEMPLATE | json }}
        exclude: 'not_used'
        config: {{ motion.config }}
        spacer: {{ motion.config_spacer }}
