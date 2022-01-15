# TODO: Use project name from constants!

source /opt/intel/openvino_2021/bin/setupvars.sh && \
    python /opt/intel/openvino_2021/deployment_tools/model_optimizer/mo.py \
    --input_model learn_tesla/frozen_graph/frozen_inference_graph.pb \
    --tensorflow_use_custom_operations_config /opt/intel/openvino_2021/deployment_tools/model_optimizer/extensions/front/tf/ssd_v2_support.json \
    --tensorflow_object_detection_api_pipeline_config learn_tesla/source_model_ckpt/pipeline.config \
    --reverse_input_channels \
    --output_dir learn_tesla/openvino_output/ \
    --data_type FP16
