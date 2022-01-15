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

scriptpath=`readlink -f $0`
scriptpathdir=`dirname $scriptpath`
constantsfile="$scriptpathdir/constants.sh"
echo "Sourcing constants from $constantsfile"
source "$constantsfile"


echo "PREPARING label map..."
cd "${OBJ_DET_DIR}"
mkdir -p "${DATASET_DIR}"
cp "${IMAGES_SOURCE_DIR}/label_map.pbtxt" "${DATASET_DIR}"

echo "CONVERTING dataset to TF Record..."
python $scriptpathdir/generate_tfrecord.py -x ${IMAGES_SOURCE_DIR}/train/ -l ${DATASET_DIR}/label_map.pbtxt -o ${DATASET_DIR}/train.record
python $scriptpathdir/generate_tfrecord.py -x ${IMAGES_SOURCE_DIR}/test/ -l ${DATASET_DIR}/label_map.pbtxt -o ${DATASET_DIR}/test.record
