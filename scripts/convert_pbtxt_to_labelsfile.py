import argparse
import tensorflow.compat.v1 as tf
from object_detection.utils import dataset_util, label_map_util

parser = argparse.ArgumentParser(
    description="Convert pbtxt to labels file")
parser.add_argument("-l",
                    "--labels_path",
                    help="Path to the labels (.pbtxt) file.", type=str)
parser.add_argument("-o",
                    "--output_path",
                    help="Path of output labels file (.txt) file.", type=str)
args = parser.parse_args()

label_map_dict = label_map_util.get_label_map_dict(args.labels_path)
with open(args.output_path, "w") as outf:
    for key in label_map_dict.keys():
        outf.write(f'{key} {label_map_dict[key]}\n')
    outf.close()



