#/bin/bash
###########################################
# Sentiment Demo Load Script
# author: Jean-Philippe Player jp@hortonworks.com
# based on script by: Paul Codding paul@hortonworks.com
#
# This script loads all the files for the Refine demo.
# It uses webhcat to run a pig and a hive script.
# 
# Requires WebHDFS turned on for the Namenode.
# Requires WebHCat.
###########################################


## PLease edit these variables ############
LOCAL_DEMO_DIR="C:\Sentiment_2"
NN_HOST=127.0.0.1
WEBHCAT_HOST=127.0.0.1
USER=sandbox
DEBUG=false
DRYRUN=false
#Required on ec2: need external IP for a datanode
#Required on sandbox: hack since WebHDFS not enabled
EC2_DATANODE_HOST=$NN_HOST
###########################################

BASE=`pwd`
DATA_DIR="$LOCAL_DEMO_DIR/data"

# Source the webhcat library functions
. webhcatlib

echo "Edit this script to configure WebHDFS location"
echo "Current configuration:"
echo " LOCAL_DEMO_DIR=\"$LOCAL_DEMO_DIR\""
echo " NN_HOST=$NN_HOST"
echo " WEBHCAT_HOST=$WEBHCAT_HOST"
echo " USER=$USER"
echo " DEBUG=$DEBUG"
echo " DRYRUN=$DRYRUN"
echo " EC2_DATANODE_HOST=$EC2_DATANODE_HOST"
echo ""
echo "You need WebHDFS enabled for this script to work."
echo "If not, enter a value for EC2_DATANODE_HOST as a workaround."
echo "Press a key to continue or Ctrl-c to quit."
pause

# IMPORTANT: Initialize webhcatlib
hdfs_connect $USER $NN_HOST $WEBHCAT_HOST $EC2_DATANODE_HOST 

cd "$DATA_DIR"
hdfs_put "dictionary.tsv" "/data/dictionary"
hdfs_put "time_zone_map.tsv" "/data/time_zone_map"

cd tweets.rc
# sandbox can't handle this much data
#for FILE in `ls Tweets.*.rc.gz`; do
#	hdfs_put "$FILE" "/data/tweets"
#done
hdfs_put 00 "/data/tweets"
hdfs_put 01 "/data/tweets"
hdfs_put 02 "/data/tweets"
hdfs_put 03 "/data/tweets"
hdfs_put 04 "/data/tweets"
hdfs_put 05 "/data/tweets"
hdfs_put 06 "/data/tweets"

cd "$BASE"
cd hive
hdfs_put "hiveddl.sql" "/user/$USER/script"
#hive_exec "/user/$USER/script/hiveddl.sql"
cd ..

cd "$BASE"

echo ""
echo "${txtbld}Complete!${txtrst}"
