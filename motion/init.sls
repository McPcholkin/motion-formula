{%- from "motion/map.jinja" import map with context -%}

motion_service:
  pkg.installed:
    - pkgs: {{ map.pkgs }}
  service.running:
    - name: {{ map.service }}  

enable_motion_daemon:
  file.managed:
    - name: {{ map.files.daemon_default }}
    - contents:
      - 'start_motion_daemon=yes'
    - require:
      - pkg: motion_service

main_config:
  file.managed:
    - name: {{ map.files.main_config }}
    - source: salt://{{ slspath }}/files/motion.conf.jinja
    - template: jinja
    - makedirs: True
    - require:
      - pkg: motion_service
    - watch_in:
      - service: motion_service

make_storage_dir:
  file.directory:
    - name: {{ map.config.target_dir }}
    - makedirs: True
    - require_in:
      - service: motion_service

make_cameras_conf_dir:
  file.directory:
    - name: {{ map.config.camera_dir }}
    - makedirs: True
    - require_in:
      - file: main_config

make_mask_dir:
  file.directory:
    - name: {{ map.files.mask_dir }}
    - makedirs: True
    - require_in:
      - file: main_config

{% set cams = salt['pillar.get']('motion:cams', False) %}
{% if cams %}
{% for cam in cams %}

config_for_camera_{{ cam }}:
  file.managed:
    - name: {{ map.config.camera_dir }}/{{ cam }}.conf
    - mekedirs: True
    - source:  salt://{{ slspath }}/files/cam_template.conf.jinja
    - template: jinja
    - watch_in:
      - service: motion_service
    - context:
      cam_name: {{ cam }}
      videodevice: {{ salt['pillar.get']('motion:cams:'~cam~':videodevice', '/dev/video'~loop.index ) }}
      text_left: {{ salt['pillar.get']('motion:cams:'~cam~':text_left', 'CAM-'~loop.index ) }}
      rotate: {{ salt['pillar.get']('motion:cams:'~cam~':rotate', '0' ) }}
      width: {{ salt['pillar.get']('motion:cams:'~cam~':width', map.config.width ) }}
      height: {{ salt['pillar.get']('motion:cams:'~cam~':height', map.config.height ) }}
      framerate: {{ salt['pillar.get']('motion:cams:'~cam~':framerate', map.config.framerate ) }}
      target_dir: {{ salt['pillar.get']('motion:cams:'~cam~':target_dir', map.config.target_dir~'/cam'~loop.index ) }}
      stream_port: {{ salt['pillar.get']('motion:cams:'~cam~':stream_port', '808'~loop.index ) }}
      mask_file: {{ salt['pillar.get']('motion:cams:'~cam~':mask_file', False ) }}
      auto_brightness: '{{ salt['pillar.get']('motion:cams:'~cam~':auto_brightness', map.config.auto_brightness ) }}'


{# ------------  temp solution ------------ #}
{% set pgm_file = salt['pillar.get']('motion:cams:'~cam~':mask_file', False ) %}
{% if pgm_file %}
{% if not salt['file.file_exists' ](pgm_file) %} 

create_pgm_mask_for_{{ cam }}:
  file.managed:
    - name: /tmp/{{ cam }}_mask.base64
    - contents_pillar: motion:cams:{{ cam }}:base64_mask_file

decode_mask_file_for_{{ cam }}:
  cmd.run:
    - name: 'base64 -d /tmp/{{ cam }}_mask.base64 > {{ pgm_file }}'
    - require:
      - file: create_pgm_mask_for_{{ cam }}
    - require_in:
      - file: config_for_camera_{{ cam }}
    - watch_in:
      - service: motion_service

{% endif %}
{% endif %}
{# -------------------------------------- #}

{# ------------- fix exposition on cheep old webcam ------------- #}
{% set exp_fix = salt['pillar.get']('motion:cams:'~cam~':exp_fix', False ) %}
{% if exp_fix %}
{% set exp_fix_scripts = salt['pillar.get']('motion:cams:'~cam~':exp_param', False ) %}
{% if exp_fix_scripts %}
{% for exp_fix_script in exp_fix_scripts %}

create_{{ exp_fix_script }}_for_camera_{{ cam }}:
  file.managed:
    - name: {{ map.files.exp_fix_dir }}/{{ exp_fix_script }}_{{ cam }}.sh
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - source: salt://{{ slspath }}/files//exp_fix.sh.jinja
    - template: jinja
    - context:
      cam_name: {{ cam }}
      cam_dev: {{ salt['pillar.get']('motion:cams:'~cam~':videodevice', '/dev/video'~loop.index ) }}
      exp_fix_power_freq: {{ salt['pillar.get']('motion:cams:'~cam~':exp_param:'~exp_fix_script~':exp_fix_power_freq', '0' ) }}
      exp_fix_gamma: {{ salt['pillar.get']('motion:cams:'~cam~':exp_param:'~exp_fix_script~':exp_fix_gamma', '1' ) }}

add_cron_job_{{ exp_fix_script }}_{{ cam }}:
  cron.present:
    - name: 'bash {{ map.files.exp_fix_dir }}/{{ exp_fix_script }}_{{ cam }}.sh'
    - user: root
    - hour: {{ salt['pillar.get']('motion:cams:'~cam~':exp_param:'~exp_fix_script~':exp_time:hour', '10' ) }}
    - minute: {{ salt['pillar.get']('motion:cams:'~cam~':exp_param:'~exp_fix_script~':exp_time:minute', '10' ) }}

{% endfor %}
{% endif %}
{% endif %}

{% endfor %}
{% endif %}
