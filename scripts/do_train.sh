scriptpath=`readlink -f $0`
scriptpathdir=`dirname $scriptpath`
constantsfile="$scriptpathdir/constants.sh"

source ${scriptpathdir}/constants.sh

${scriptpathdir}/retrain_detection_model.sh \
	--num_training_steps ${NUM_TRAINING_STEPS} \
	--num_eval_steps ${NUM_EVAL_STEPS}

