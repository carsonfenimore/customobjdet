#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Exit script on error.
set -e
# Echo each command, easier for debugging.
set -x

usage() {
  cat << END_OF_USAGE
  Downloads checkpoint and dataset needed for the tutorial.

  --network_type      Can be one of [mobilenet_v1_ssd, mobilenet_v2_ssd],
                      mobilenet_v1_ssd by default.
  --train_whole_model Whether or not to train all layers of the model. false
                      by default, in which only the last few layers are trained.
  --help              Display this help.
END_OF_USAGE
}

network_type="mobilenet_v2_ssd"
train_whole_model="false"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --network_type)
      network_type=$2
      shift 2 ;;
    --train_whole_model)
      train_whole_model=$2
      shift 2;;
    --help)
      usage
      exit 0 ;;
    --*)
      echo "Unknown flag $1"
      usage
      exit 1 ;;
  esac
done

scriptpath=`readlink -f $0`
scriptpathdir=`dirname $scriptpath`
constantsfile="$scriptpathdir/constants.sh"
echo "Sourcing constants from $constantsfile"
source "$constantsfile"

echo "PREPARING checkpoint in ${LEARN_DIR}"
mkdir -p "${LEARN_DIR}"

ckpt_link="${ckpt_link_map[${network_type}]}"
ckpt_name="${ckpt_name_map[${network_type}]}"
cd "${LEARN_DIR}"
echo "===================================="
if [ \! -f "${ckpt_name}.tar.gz" ]; then
   wget -O "${ckpt_name}.tar.gz" "$ckpt_link"
else 
    echo "Not downloading file - already exists"
fi

echo "===================================="
if [ \! -d "${CKPT_DIR}" ]; then
   echo "Extracting "${ckpt_name}" to ${CKPT_DIR}"
   tar zxvf "${ckpt_name}.tar.gz"
   mv "${ckpt_name}" "${CKPT_DIR}"
else
    echo "Not extracting, ${CKPT_DIR} already exists"
fi

echo "===================================="
config_filename="${config_filename_map[${network_type}-${train_whole_model}]}"
srcpipeline="$scriptpathdir/configs/${config_filename}"
echo "COPYING pipeline ${srcpipeline} to ${CKPT_DIR}/pipeline.config"
cd "${OBJ_DET_DIR}"
cp "${srcpipeline}" "${CKPT_DIR}/pipeline.config"

echo "===================================="
echo "REPLACING variables in config file..."
sed -i "s%CKPT_DIR_TO_CONFIGURE%${CKPT_DIR}%g" "${CKPT_DIR}/pipeline.config"
sed -i "s%DATASET_DIR_TO_CONFIGURE%${DATASET_DIR}%g" "${CKPT_DIR}/pipeline.config"

