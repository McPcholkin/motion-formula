# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{% if motion.telegram.config.token %}
{% if motion.telegram.config.chat_id %}

     
{# Deploy motion_bot script #}
motion-telegram-bot-script-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/scripts/motion_bot.py"
    - source: {{ files_switch(['motion_bot.py.tmpl.jinja'],
                              lookup='motion-telegram-bot-script-file-managed',
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
      snmp_host: {{ motion.telegram.snmp.config.host }}
      snmp_oid: {{ motion.telegram.snmp.config.oid }}
      known_mac_list_file: "{{ motion.path.config }}/scripts/known_mac_list.txt"

{# Deploy telegram script #}
motion-telegram-send-script-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/scripts/telegram_send.py"
    - source: {{ files_switch(['telegram_send.py.tmpl.jinja'],
                              lookup='motion-telegram-send-script-file-managed',
                              use_subpath=True
                             )
             }}
    - mode: 744
    - user: {{ motion.service.user }}
    - group: {{ motion.service.group }}
    - template: jinja
    - makedirs: True
    - context:
      url_base: {{ motion.telegram.config.url.base }}
      url_send_photo: {{ motion.telegram.config.url.send_photo }}

 
{# if motion.telegram.config.token #}
{# if motion.telegram.config.chat_id #}
{% endif %}
{% endif %}

{% if motion.telegram.snmp.config.host %}
{% if motion.telegram.snmp.mac_list %}

{# Deploy SNMP check script #}
motion-telegram-snmp-script-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/scripts/snmp_check.py"
    - source: {{ files_switch(['snmp_check.py.tmpl.jinja'],
                              lookup='motion-telegram-snmp-script-file-managed',
                              use_subpath=True
                             )
             }}
    - mode: 744
    - user: {{ motion.service.user }}
    - group: {{ motion.service.group }}
    - template: jinja
    - makedirs: True
    - context:
      snmp_community: {{ motion.telegram.snmp.config.community }}
      snmp_port: {{ motion.telegram.snmp.config.port }}


{# Deploy known MAK list #}
motion-telegram-known-mac-list-file-managed:
  file.managed:
    - name: "{{ motion.path.config }}/scripts/known_mac_list.txt"
    - mode: 600
    - user: {{ motion.service.user }}
    - group: {{ motion.service.group }}
    - makedirs: True
    - contents:
      {% for mac in motion.telegram.snmp.mac_list %}
      - {{ mac }}
      {% endfor %} 
 

{# if motion.telegram.snmp.mac_list #}
{# if motion.telegram.snmp.config.host #}
{% endif %}
{% endif %}



