# Overview

This repo contains various files to support: end-to-end edge AI. This includes:
  - GPU-accelerated training of mobilenet v2
  - Exporting models to MyriadX (Luxonis depthai)
  - Exporting models to Coral TPU
  - And more!

# Training 


## Set up your data:
  - TODO: all scripts from here on should accept PROJECT_NAME as an arg, so we arent modifying any scripts...
  - First define your project by setting PROJECT_NAME in scripts/constants.sh
  - Create a directory in scripts/images_{PROJECT_NAME}
  - Put your map of numbers to class into a file called "label_map.pbtxt" inside scripts/images_{PROJECT_NAME}
  - Put train images/labelImg xmls inside scripts/images_{PROJECT_NAME}/train
  - Put test images/labelImg xmls inside scripts/images_{PROJECT_NAME}/test

## Train
Run the docker:

    ./run1152.sh

Inside the container:

        # Grab mobilenet v2 checkpoints
        # This also copies the template pipeline config
        # NOTE: we use the myriad one as a source and produce TWO pipeline configs:
        #  - one without quantization graph_rewriter
        #  - one WITH the quantization graph_rewriter
        ./scripts/prepare_checkpoint.sh

        # take the dataset, generate the tfrecords
        # The pipeline from prepare_checkpoint.sh will reference these
        # tfrecords.
        ./scripts/prepare_dataset.sh   

        # Actually run the detection phase
        # outputs various checkpoints in the train_output directory
        ./scripts/do_train.sh

In another console run the tensorboard script:

        ./run_tensorboard.sh

Wait til training is done. Can watch tensorboard by going to http://<host>:6007

# POST-TRAINING:

## Coral / TPU-Deployment:
From within the tf1152 docker export the fine-tuned model to tensorflow lite:

        ./scripts/convert_checkpoint_to_edgetpu_tflite.sh

Convert tensforlite to edgetpu:

        ./scripts/tpu_compile.sh

Copy you tpu-compiled model from learn_${PROJECT} to your device

    

## MyriadX-Deployment:
From within the tf1152 docker generate OpenVINO IR:
    
        ./scripts/openvino_frozen_to_ir.sh

Convert IR to blob

        ./scripts/openvino_ir_to_blob.sh

To place ot inside where, say, depthai_demo cna find it, create a json under depthai/resources/nn/<modeldir>/<modeldir>.json:
 
        {
            "nn_config":
            {
                "output_format" : "detection",
                "NN_family" : "mobilenet",
                "confidence_threshold" : 0.5,
                "input_size": "300x300"
            },
            "mappings":
            {
                "labels":
                [
                    "unknown",
                    "tesla"
                ]
            }
        }

And put the blob along side it
TODO: Generate this json by parsing the labelmap, as its the only thing that changes...

    
# Notes on what was modified to make all these scripts work
 - Modified model_main.py to have an "allow_growth" option on the session_config - to avoid blowing up on GPU due to OOM
 - Modified generate_tfrecord.py:63 to fix something in the tfrecord scripts that wasn't working...

    label_map_dict = label_map_util.get_label_map_dict(args.labels_path)

 - Add in openvino
 - merge in the tpu compiler...
