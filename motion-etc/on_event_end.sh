#! /usr/bin/env bash
PREFLOG="[LOG:$BASHPID]"
PREFWRN="[WRN:$BASHPID]"
PREFERR="[ERR:$BASHPID]"
[[ ! -z "$DEBUG" ]] && echo "$PREFLOG run $0" 
if [ $# -eq 0 ]; then
  echo "$PREFERR command line contains no arguments"
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

