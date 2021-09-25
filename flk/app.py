from flask import Flask,jsonify,request
import werkzeug
import sys
import cv2
import numpy as np
import os
import base64
sys.path.append("./flk/Mask_RCNN/demo")
sys.path.append("./flk/Mask_RCNN")

from train_mask_rcnn_demo import *
from mrcnn.visualize import random_colors,get_mask_contours,draw_mask


app = Flask(__name__)

@app.route("/api",methods=["GET"])
def function():
    if(request.method == 'GET'):
        request.headers = None
        d = {}
        s = os.listdir("./uploadedimages")
        file_ = "./uploadedimages/" + s[0]
        img = cv2.imread(file_)
        image = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        test_model, inference_config = load_inference_model(1,'./flk/mask_rcnn_object_0005.h5')
        # Detect results
        r = test_model.detect([image])[0]
        object_count = len(r["class_ids"])
        colors = random_colors(object_count)
        for i in range(object_count):
            # 1. Mask
            mask = r["masks"][:, :, i]
            contours = get_mask_contours(mask)
            for cnt in contours:
                cv2.polylines(img, [cnt], True, colors[i], 2)
                img = draw_mask(img, [cnt], colors[i])
        print(object_count)
        cv2.imwrite("./flk/detect.jpg", img)
        with open("./flk/detect.jpg", "rb") as img_file:
            b64_string = base64.b64encode(img_file.read()).decode('ascii')
        d["object"] = object_count            
        d["image"] = b64_string
        os.remove(file_)
        os.remove("./flk/detect.jpg")
        return jsonify(d)

@app.route('/upload',methods = ['POST'])
def upload():
    if(request.method == 'POST'):
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save('uploadedimages/'+filename)
        return jsonify({"message":"Img Uplo one"})


if __name__ == "__main__":
    app.run(port=4000,debug=True,host="0.0.0.0")
