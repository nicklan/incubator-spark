#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Ensure that there is a tachyon conf
#
# Argument must be the dns name of a tachyon master

usage="Usage: $0 TACHYON_MASTER_HOSTNAME"

# if no args specified, show usage
if [ $# -ne 1 ]; then
  echo $usage
  exit 1
fi

bin=`cd "$( dirname "$0" )"; pwd`

TACHYON_CONF_DIR="$bin/../conf/"
if [ ! -e "$TACHYON_CONF_DIR/tachyon-env.sh" ]; then
  # Create a default config that can be overridden later
  cp "$TACHYON_CONF_DIR/tachyon-env.sh.template" "$TACHYON_CONF_DIR/tachyon-env.sh"
  sed -i "s/TACHYON_MASTER_ADDRESS=localhost/TACHYON_MASTER_ADDRESS=$1/" "$TACHYON_CONF_DIR/tachyon-env.sh"
  TOTAL_MEM=`awk '/MemTotal/{print $2}' /proc/meminfo`
  TOTAL_MEM=$[TOTAL_MEM * 2 / 3]
  sed -i "s/TACHYON_WORKER_MEMORY_SIZE=1GB/TACHYON_WORKER_MEMORY_SIZE=${TOTAL_MEM}KB/" "$TACHYON_CONF_DIR/tachyon-env.sh"
fi
