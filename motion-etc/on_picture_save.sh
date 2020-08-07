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

dirpath=$(dirname $filepath)
subdir=${dirpath/$target_dir/}
remotedir=$WCM_ID$subdir

[[ ! -z "$DEBUG" ]] && echo "[LOG] rclone copy $filepath $WCM_STORER:$remotedir" 
[[ ! -z "$filepath" ]] && [[ ! -z "$remotedir" ]] && (rclone copy $filepath $WCM_STORER:$remotedir &) || \
  echo "[ERR] rclone copy wrong filepath($filepath) or remotedir($remotedir)"
