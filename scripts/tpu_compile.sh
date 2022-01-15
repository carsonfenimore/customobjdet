#sudo docker run -it --rm -v $(pwd)/$2:/tmpout -v $(pwd):/tmp jiankaiwang/edgetpucompiler:14.1 edgetpu_compiler -o /tmpout /tmp/$1
scriptpath=`readlink -f $0`
scriptpathdir=`dirname $scriptpath`
constantsfile="$scriptpathdir/constants.sh"

source ${scriptpathdir}/constants.sh
mkdir -p $TPU_OUTPUT 
edgetpu_compiler -o $TPU_OUTPUT ${OUTPUT_DIR}/output_tflite_graph.tflite
