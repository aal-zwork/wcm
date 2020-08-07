#! /usr/bin/env bash
[[ ! -z "$DEBUG" ]] && echo "[LOG] run $0" 
if [ $# -eq 0 ]; then
  echo "[ERR] command line contains no arguments"
  exit 1
fi
WCM_STORER=${RCLONE_REMOTE_NAME:-"wcm-storer"}
WCM_ID=${MOTION_ALIAS:-/wcm}

year=$1; month=$2; day=$3
hour=$4; minutes=$5; seconds=$6
event=$7; frame_n=$8; cam_id=$9
change_pxl=${10}
noise=${11}
marea_w=${12}; marea_h=${13}
marea_x=${14}; marea_y=${15}
event_text=${16}
filepath=${17}
movie_type_n=${18}
target_dir=${19}

[[ -z "$filepath" ]] && (echo "[ERR] video rclone copy wrong filepath is ''"; exit)

dirpath=$(dirname $filepath)
subdir=${dirpath/$target_dir/}
[[ -z "$subdir" ]] && (echo "[ERR] video rclone copy wrong subdir is ''"; exit)

remotedir=$WCM_ID$subdir
[[ -z "$remotedir" ]] && (echo "[ERR] video rclone copy wrong remotedir is ''"; exit)

# VIDEO COPY
[[ ! -z "$DEBUG" ]] && echo "[LOG] video rclone copy $filepath $WCM_STORER:$remotedir" 
rclone copy $filepath $WCM_STORER:$remotedir &


# AUDIO COPY
[[ -z "$MOTION_AUDIO" ]] && exit 0
[[ -z "$MOTION_CAM_AUDIO" ]] && audio_hw="plughw:1" || audio_hw="${MOTION_CAM_AUDIO[$cam_id]}"
#ps_line=$(ps aux | grep -e [a]record.-D.$audio_hw.*-$event.wav)
basenfp=$(basename $filepath)
ps_line=$(ps aux | grep -e [a]record.-D.$audio_hw.*$basename.wav)
arecord_pid=$(echo $ps_line | awk '{print $1}')
if [[ -z "$arecord_pid" ]]; then echo "[ERR] kill arecord_pid is ''"; else
  [[ ! -z "$DEBUG" ]] && echo "[LOG] kill $arecord_pid"
  kill $arecord_pid

  #audiofilepath=$(echo $ps_line | awk '{print $11}')
  audiofilepath=$filepath.wav
  if [[ -z "$audiofilepath" ]]; then echo "[ERR] audio rclone copy  wrong audiofilepath is ''"; else
    [[ ! -z "$DEBUG" ]] && echo "[LOG] sleep 5 && (kill -9 $arecord_pid; rclone copy $audiofilepath $WCM_STORER:$remotedir &)"
    sleep 5 && (kill -9 $arecord_pid; rclone copy $audiofilepath $WCM_STORER:$remotedir &)
  fi
fi
