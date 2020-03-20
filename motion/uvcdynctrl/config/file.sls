# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{# Create pan and tilt control for each camera #}
{% if motion.cameras %}
{% for camera in motion.cameras.items() %}

motion-{{ camera.0 }}-uvcdynctrl-wrapper-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/control/{{ camera.0 }}_control.sh"
    - source: {{ files_switch(['camera_control.sh.tmpl.jinja'],                              lookup='motion-{{ camera.0 }}-uvcdynctrl-wrapper-file-managedi',
                              use_subpath=True
                        )
        }}
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - makedirs: True
    - context:
      turn_step: {{ motion.uvcdynctrl.config.turn_step }}
      camera_dev: {{ camera.1.config.videodevice }}


{% endfor %}
{% endif %}




