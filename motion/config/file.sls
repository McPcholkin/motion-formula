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

motion-config-file-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/motion.conf"
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
    - watch_in:
      - sls: {{ sls_service_running }}
    - context:
        config: {{ motion.config }}

{# ############################################################################# #}

{# Create config for each camera #}
{% if motion.cameras %}
{% for camera in motion.cameras.items() %}

motion-{{ camera.0 }}-config-file-file-managed:
  file.managed:
    - name: "{{ motion.config.camera_dir }}/{{ camera.0 }}.conf"
    - source: {{ files_switch(['ini.tmpl.jinja'],
                              lookup='motion-{{ camera.0 }}-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: root
    - makedirs: False
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - watch_in:
      - sls: {{ sls_service_running }}
    - context:
        config: {{ camera.1.config }}

{# ############################################### #}

motion-{{ camera.0 }}-target-dir-file-directory:
  file.directory:
    - name: {{ camera.1.config.target_dir }}
    - user: {{ motion.service.user }}
    - group:  {{ motion.service.group }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}

{# ############################################### #}


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


{# ############################################### #}


{# Cleanup examples #}
motion-default-camera1-config-file-file-absent:
  file.absent:
    - name: "{{ motion.path.config }}/camera1-dist.conf"

motion-default-camera2-config-file-file-absent:
  file.absent:
    - name: "{{ motion.path.config }}/camera2-dist.conf"

motion-default-camera3-config-file-file-absent:
  file.absent:
    - name: "{{ motion.path.config }}/camera3-dist.conf"

motion-default-camera4-config-file-file-absent:
  file.absent:
    - name: "{{ motion.path.config }}/camera4-dist.conf"
