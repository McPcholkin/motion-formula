# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import motion with context %}

motion-uvcdynctrl-package-install-pkg-installed:
  pkg.installed:
    - pkgs: {{ motion.uvcdynctrl.pkg.name }}
