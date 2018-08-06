motion:
  config:
    target_dir: '/srv/motion'
    webcontrol_localhost: 'off'
    on_picture_save: '/etc/motion/telegram_send.py %f'
  cams:
    cam1:
      videodevice: '/dev/v4l/by-id/usb-041e_4051-video-index0'
      text_left: 'CAMERA_1'
      rotate: 0
      width: 640
      height: 480
      framerate: 3
      target_dir: '/srv/motion/cam1'
      stream_port: 8081
      auto_brightness: 'off'
      exp_fix: True
      exp_param:
        exp_day:
          exp_fix_power_freq: 0
          exp_fix_gamma: 1
          exp_time:
            hour: 6
            minute: 1
        exp_night:
          exp_fix_power_freq: 1
          exp_fix_gamma: 2
          exp_time:
            hour: 19
            minute: 30

      cam2:
        videodevice: '/dev/v4l/by-id/usb-Image_Processor_Lenovo_EasyCamera_Lenovo'
        text_left: 'CAMERA_2'
        rotate: 0
        width: 640
        height: 480
        framerate: 2
        target_dir: '/srv/motion/cam2'
        stream_port: 8082
        mask_file: /etc/motion/mask/cam2_mask.pgm
        base64_mask_file: |
          UDUKIyBDUkVBVE9SOiBHSU1QIFBOTSBGaWx0ZXIgVmVyc2lvbiAxLjEKNjQwIDQ4MAoyNTUKAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          ...
          ////////////////////////////////

