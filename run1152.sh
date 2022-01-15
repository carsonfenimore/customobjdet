echo
echo "IMPORTANT: Remember to make sure the batch_size in pipeline config is not too big!!!"
echo

SCRIPTS_DIR=${PWD}/scripts 
source $SCRIPTS_DIR/constants.sh

DETECT_DIR=${PWD}/output_${PROJECT_NAME}
mkdir -p $DETECT_DIR

sudo docker run --name tftrain \
--runtime=nvidia    \
--rm -it --privileged -p 6007:6007 \
--mount type=bind,src=${DETECT_DIR},dst=/tensorflow/models/research/learn_${PROJECT_NAME} \
--mount type=bind,src=${SCRIPTS_DIR},dst=/tensorflow/models/research/scripts \
detect-tutorial-tf1152-gpu
