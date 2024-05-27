# Created referring to:
# Amazon Web Services, Inc. 2023. 'Lambda function handler in Python'.
# Retrieved from https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
#
# Amazon Web Services, Inc. 2023. 'Deploy Python Lambda functions with .zip file archives'.
# Retrieved from https://docs.aws.amazon.com/lambda/latest/dg/python-package.html
#
# Machado, D. 2022. 'Handling AWS Lambda Python Dependencies'.
# Retrieved from https://www.serverless.com/blog/handling-aws-lambda-python-dependencies
#
# OpenCV. n.d. 'Image file reading and writing - imread()'.
# Retrieved from https://docs.opencv.org/3.4/d4/da8/group__imgcodecs.html#ga288b8b3da0892bd651fce07b3bbd3a56
#
# Messersmith, M. 2018. 'Answer to: Convert byte array back to numpy array [duplicate]'
# Retrieved from https://stackoverflow.com/a/53379777
#
# NumPy Developers. 2022. 'numpy.frombuffer'
# Retrieved from https://numpy.org/doc/stable/reference/generated/numpy.frombuffer.html
#
# NumPy Developers. 2022. 'Scalars'
# Retrieved from https://numpy.org/doc/stable/reference/arrays.scalars.html
#
# Ieong, K H. 2017. 'Answer to: Getting json body in aws Lambda via API gateway'.
# Retrieved from https://stackoverflow.com/a/41656022
#
# Modifies the objectdetection.py script given to students in FIT5225 Assignment 1, 
# as per the following from the FIT5225 Assignment 2 brief:
#
#  "Please note that you should update your Yolo script that
#  you were given in your first assignment to suit the AWS Lambda function. 
#  This includes removing any Flask-related code, incorporating the Lambda
#  function and required libraries to read the image from S3
#  buckets, and storing the S3 URL and tags in the database."

from sys import path
path.append('dependencies')

from traceback import format_exc
from typing import Dict, List, Any
from base64 import b64decode
from numpy import argmax, array, frombuffer, ubyte
import cv2
import os
import json

STATUS_CODE: str = "statusCode"
HEADERS: str = "headers"
BODY: str = "body"

def get_response(code: int, body: Dict) -> Dict:
  return {
        STATUS_CODE: code,
        HEADERS: {
          "Content-Type": "application/json"
        },
        BODY: json.dumps(body)
      }


def handler(event: Dict, context: Any):
  """
  The input event should be a JSON object of the form
  {
    "image": "BASE64-encoded image here"
  }
  This function returns a response of the form
  {
  "tags": [
      {
        "tag": "SOME OBJECT",
        "count": 2
      },
      {
        "tag": "SOME OTHER OBJECT"
      }
    ]
  }
  """

  # MODIFIED FUNCTIONS PROVIDED IN ASSIGNMENT 1 BY FIT5225 TEACHING TEAM >>>
  confthres = 0.3
  nmsthres = 0.1

  def get_labels(labels_path):
      # load the COCO class labels our YOLO model was trained on
      lpath=os.path.sep.join([yolo_path, labels_path])

      LABELS = open(lpath).read().strip().split("\n")
      return LABELS


  def get_weights(weights_path):
      # derive the paths to the YOLO weights and model configuration
      weightsPath = os.path.sep.join([yolo_path, weights_path])
      return weightsPath

  def get_config(config_path):
      configPath = os.path.sep.join([yolo_path, config_path])
      return configPath

  def load_model(config_path, weights_path):
      # load our YOLO object detector trained on COCO dataset (80 classes)
      net = cv2.dnn.readNetFromDarknet(config_path, weights_path)
      return net

  def do_prediction(image, net, LABELS) -> List[Dict]:

      (H, W) = image.shape[:2]
      # determine only the *output* layer names that we need from YOLO
      ln = net.getLayerNames()
      ln = [ln[i - 1] for i in net.getUnconnectedOutLayers()]

      # construct a blob from the input image and then perform a forward
      # pass of the YOLO object detector, giving us our bounding boxes and
      # associated probabilities
      blob = cv2.dnn.blobFromImage(image, 1 / 255.0, (416, 416),
                                  swapRB=True, crop=False)
      net.setInput(blob)
      layer_outputs = net.forward(ln)

      # initialize our lists of detected bounding boxes, confidences, and
      # class IDs, respectively
      boxes = []
      confidences = []
      class_ids = []

      # loop over each of the layer outputs
      for output in layer_outputs:
          # loop over each of the detections
          for detection in output:
              # extract the class ID and confidence (i.e., probability) of
              # the current object detection
              scores = detection[5:]
              class_id = argmax(scores)
              confidence = scores[class_id]

              # filter out weak predictions by ensuring the detected
              # probability is greater than the minimum probability
              if confidence > confthres:
                  # scale the bounding box coordinates back relative to the
                  # size of the image, keeping in mind that YOLO actually
                  # returns the center (x, y)-coordinates of the bounding
                  # box followed by the boxes' width and height
                  box = detection[0:4] * array([W, H, W, H])
                  (center_x, center_y, width, height) = box.astype("int")

                  # use the center (x, y)-coordinates to derive the top and
                  # and left corner of the bounding box
                  x = int(center_x - (width / 2))
                  y = int(center_y - (height / 2))

                  # update our list of bounding box coordinates, confidences,
                  # and class IDs
                  boxes.append([x, y, int(width), int(height)])

                  confidences.append(float(confidence))
                  class_ids.append(class_id)

      # apply non-maxima suppression to suppress weak, overlapping bounding boxes
      idxs = cv2.dnn.NMSBoxes(boxes, confidences, confthres,
                              nmsthres)

      # Keep a dictionary of detected objects and counts
      detected_objects: Dict = {}
      if len(idxs) > 0:
          for i in idxs.flatten():
            obj: str = LABELS[class_ids[i]]
            if obj in detected_objects:
              detected_objects[obj] += 1
            else:
              detected_objects[obj] = 1
      
      return [ {
        "tag": tag,
        "count": count
      } for tag, count in detected_objects.items() ]

  try:
    yolo_path = "yolo_tiny_configs/"
    labelsPath = "coco.names"
    cfgpath = "yolov3-tiny.cfg"
    wpath = "yolov3-tiny.weights"
    Lables = get_labels(labelsPath)
    CFG = get_config(cfgpath)
    weights = get_weights(wpath)

    try:
      # Retrieve the image from the request body
      request_body: Dict = json.loads(event["body"])
      base64_encoded_image: str = request_body["image"]

      # Decode the image
      image_bytes: bytes = b64decode(base64_encoded_image)
      image_buffer = frombuffer(image_bytes, ubyte)
      # The original script uses imread, which according to https://docs.opencv.org/3.4/d4/da8/group__imgcodecs.html#ga288b8b3da0892bd651fce07b3bbd3a56,
      # defaults to flag=IMREAD_COLOR, so we use that here for decoding to preserve the original behaviour.
      image: cv2.Mat = cv2.imdecode(image_buffer, cv2.IMREAD_COLOR)
      image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

      # Load network
      nets = load_model(CFG, weights)
      detected_tags: List[Dict] = do_prediction(image, nets, Lables)

      # Return detected objects
      return get_response(200, {
        "tags": detected_tags
      })
    except Exception as e:
      return get_response(400, {
        "Message": "Bad Request",
        "Error": str(e.__class__),
        "Traceback": str(format_exc())
      })
  except:
      return get_response(500, {
        "Message": "Internal Server Error"
      })
