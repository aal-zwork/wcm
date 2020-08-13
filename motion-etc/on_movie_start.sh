#! /usr/bin/env bash
[[ ! -z "$DEBUG" ]] && echo "[LOG:$BASHPID] run $0" 
if [ $# -eq 0 ]; then
  echo "[ERR] command line contains no arguments"
  exit 1
fi
WCM_STORER=${RCLONE_REMOTE_NAME:-"wcm-storer"}
WCM_ID=${MOTION_ALIAS:-$(hostname)}

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

subdir=/$cam_id/$year/$month/$day/$hour
remotedir=$WCM_ID$subdir

if [[ -z "$remotedir" ]]; then echo "[ERR] mkdir remotedir is ''"; else
  [[ ! -z "$DEBUG" ]] && echo "[LOG] rclone mkdir $WCM_STORER:$remotedir" 
  rclone mkdir $WCM_STORER:$remotedir &
fi

# AUDIO REСORD
[[ -z "$MOTION_AUDIO" ]] && exit 0
audio_hw_name_var="MOTION_AUDIO_$cam_id"
audio_hw=${!audio_hw_name_var:-"plughw:0"}
ps_line=$(ps aux | grep -e [a]record.-D.$audio_hw.*.wav)
arecord_pid=$(echo $ps_line | awk '{print $1}')
if [[ ! -z "$arecord_pid" ]]; then kill -9; fi
if [[ -z "$audio_hw" ]]; then echo "[WRN] arecord audio_hw for cam($cam_id) is ''"; else
  #audiofilepath=$target_dir$subdir/$hour$minutes$seconds-$event.wav
  audiofilepath=$filepath.wav
  if [[ -z "$audiofilepath" ]]; then echo "[ERR] arecord audiofilepath is ''"; else
    [[ ! -z "$DEBUG" ]] && echo "[LOG] mkdir -p $target_dir$subdir; (arecord -D $audio_hw -r 16000 -f S16_LE $audiofilepath &)" 
    mkdir -p $target_dir$subdir;
    arecord -D $audio_hw -r 16000 -f S16_LE $audiofilepath &
  fi
fi
