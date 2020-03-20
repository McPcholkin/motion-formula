# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

motion-uvcdynctrl-package-clean-pkg-removed:
  pkg.removed:
    - pkgs: {{ motion.uvcdynctrl.pkg.name }}
