# TODO: use constats project!

source /opt/intel/openvino_2021/bin/setupvars.sh && \
     /opt/intel/openvino_2021/deployment_tools/tools/compile_tool/compile_tool -m learn_tesla/openvino_output/frozen_inference_graph.xml -ip U8 -d MYRIAD -VPU_NUMBER_OF_SHAVES 4 -VPU_NUMBER_OF_CMX_SLICES 4 -o learn_tesla/openvino_output/output.blob

