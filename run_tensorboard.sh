source scripts/constants.sh
sudo docker exec -it tftrain tensorboard  --port 6007 --logdir=./learn_${PROJECT_NAME}/train_output/

