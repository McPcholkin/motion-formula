# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{% if motion.telegram.config.token %}
{% if motion.telegram.config.chat_id %}

{# Deploy telegram script #}
motion-telegram-script-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/scripts/telegram.py"
    - source: {{ files_switch(['telegram.py.tmpl.jinja'],
                              lookup='motion-telegram-script-file-managed',
                              use_subpath=True
                             )
             }}
    - mode: 744
    - user: {{ motion.service.user }}
    - group: {{ motion.service.group }}
    - template: jinja
    - makedirs: True
    - context:
      token: {{ motion.telegram.config.token }}
      chat_id: {{ motion.telegram.config.chat_id }}
      url_base: {{ motion.telegram.config.url.base }}
      url_send_photo: {{ motion.telegram.config.url.send_photo }}
      

{% endif %}
{% endif %}



