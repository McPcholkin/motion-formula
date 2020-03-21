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
  - {{ sls_service_running }}

{# Create mask files for each camera #}
{% if motion.cameras %}
{% for camera in motion.cameras.items() %}


{% if 'base64' in camera.1 %}


{# create mask file #}
{% if 'mask_file' in camera.1.config %}
{% if 'mask_file' in camera.1.base64 %}

motion-{{ camera.0 }}-mask-file-file-decode:
  file.decode:
    - name: {{ camera.1.config.mask_file }}
    - encoded_data: |
        {{ camera.1.base64.mask_file | indent(8) }}
    - encoding_type: base64
    - require:
      - sls: {{ sls_package_install }}
    - watch_in:
      - sls: {{ sls_service_running }}

{% endif %}
{% endif %}


{# create mask privacy file #}
{% if 'mask_privacy' in camera.1.config %}
{% if 'mask_privacy' in camera.1.base64 %}

motion-{{ camera.0 }}-mask-privacy-file-decode:
  file.decode:
    - name: {{ camera.1.config.mask_privacy }}
    - encoded_data: |
        {{ camera.1.base64.mask_privacy | indent(8) }}
    - encoding_type: base64
    - require:
      - sls: {{ sls_package_install }}
    - watch_in:
      - sls: {{ sls_service_running }}

{% endif %}
{% endif %}


{% endif %}


{# ############################################### #}



{% endfor %}
{% endif %}


