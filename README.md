# Counting_Pipes

## Overview

Companies that manufacture, process, and sell pipes of different material face problems in the inventory management of these pipes. Checking and matching the number of pipes to the inventory is a fairly difficult task because of the labour and visual dependency required in it.

We trained a mask-rcnn model and built a flutter application which can do this task very easily, thus slightly reducing the costs incured by the companies for these tasks.

### Sample Screenshots
![Alt text](Images/img1.png?raw=true "Prediction1")

![Alt text](Images/img2.png?raw=true "Prediction2")

The application sends an image to a server, which contains the trained model to detect and count pipe in an image. The servers runs the model on the image and returns the predicted image to the application, which is displayed on the screen.

We trained a mask-rcnn model, since there was no pre-trained model to detect pipes in an image. We created and annotated the dataset of pipe images ourselves which is available [here](kaggle.com/vijayshankar756/pipedataset).

## How-To-Run

1) An emulator is required since the application can only be run on an emulator as of now.
2) Follow the requirements.txt file to setup the local host for the application.
3) Run app.py in flk folder to start the server
4) Run main.dart in lib folder to run the application on the emulator

## Demo Video

https://drive.google.com/drive/folders/1SpgXv5hz6b5I5Xtd5rKa9Qf3FoYn6zvS?usp=sharing

## Future Vision

1) The application can only be run on an emulator with the local host server running on the same system. We can scale it up for general purpose by deploying the model on internet instead of using a localhost.

2) Training the model on more images, since as of now it might not detect some pipes in an image.

3) Even with a well-trained model. it is possible that some pipes may remain undetected. We can tackle this situation by providing the user, the authority to mark the undetected pipes and increase the count manually.

4) Storing the predicted image and count in a centralised storage system for better inventory management.
