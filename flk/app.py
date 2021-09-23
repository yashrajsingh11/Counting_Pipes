from flask import Flask,jsonify,request
import werkzeug
import sys
import cv2
import pandas as pd
import numpy as np
sys.path.append("./flk/Mask_RCNN/demo")
sys.path.append("./flk/Mask_RCNN")

from train_mask_rcnn_demo import *
from mrcnn.visualize import random_colors,get_mask_contours,draw_mask


app = Flask(__name__)

@app.route("/api",methods=["GET"])
def function():
    if(request.method == 'GET'):
        d = {}
        file_ = "./flk/6.jpg"
        img = cv2.imread(file_)
        image = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        test_model, inference_config = load_inference_model(1,'./flk/mask_rcnn_object_0005.h5')
        # Detect results
        r = test_model.detect([image])[0]
        object_count = len(r["class_ids"])
        colors = random_colors(object_count)
        df = {}
        j = 1
        for i in range(object_count):
            # 1. Mask
            mask = r["masks"][:, :, i]
            contours = get_mask_contours(mask)
            contour1 = np.array(contours).squeeze()
            df["contours" + str(j)] = contour1.tolist()
            j = j + 1
            for cnt in contours:
                cv2.polylines(img, [cnt], True, colors[i], 2)
                img = draw_mask(img, [cnt], colors[i])
        print(object_count)
        # print(df)
        d["location"] = df
        cv2.imwrite("./flk/detect.jpg", img)
        d["object"] = object_count            
        d["image"] = "./flk/detect.jpg"
        return jsonify(d)

@app.route('/upload',methods = ['POST'])
def upload():
    if(request.method == 'POST'):
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save('uploadedimages/'+filename)
        return jsonify({"message":"Img Uplo one"})


if __name__ == "__main__":
    app.run(port=4000,debug=True)
