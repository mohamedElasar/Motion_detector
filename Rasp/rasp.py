import cv2,time
import numpy as np
import uuid
import requests
import os
from pathlib import Path
cwd = os.getcwd()



# data = open('ahmed.jpg','rb').read()
# r = requests.post('http://127.0.0.1:8000/api/image/',data=data)

first_frame=None

video=cv2.VideoCapture(0)

def get_latest_image(dirpath, valid_extensions=('jpg','jpeg','png')):
    """
    Get the latest image file in the given directory
    """

    # get filepaths of all files and dirs in the given dir
    valid_files = [os.path.join(dirpath, filename) for filename in os.listdir(dirpath)]
    # filter out directories, no-extension, and wrong extension files
    # valid_files = [f for f in valid_files if '.' in f and \
    #     f.rsplit('.',1)[-1] in valid_extensions and os.path.isfile(f)]

    if not valid_files:
        raise ValueError("No valid images in %s" % dirpath)

    return max(valid_files, key=os.path.getmtime)


while True:
    check,frame = video.read()
    gray=cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray=cv2.GaussianBlur(gray,(21,21),0)

    if first_frame is None:
        first_frame=gray
        continue

    delta_frame=cv2.absdiff(first_frame,gray)
    thresh_frame=cv2.threshold(delta_frame,30,255,cv2.THRESH_BINARY)[1]
    thresh_frame=cv2.dilate(thresh_frame,None,iterations=2)

    # print(thresh_frame)
    # if thresh_frame.any([[255]]):
    if 255 in thresh_frame[:,:]:
        print('hi')
        cv2.imwrite(f'{uuid.uuid4()}.{"jpg"}', frame)

        url = 'https://shielded-fjord-30824.herokuapp.com/api/image/'
        files = {'image_url': open(get_latest_image(cwd,'jpg'), 'rb')}
        response = requests.post(url, files=files)


        time.sleep(5)
        continue

    # cv2.imshow("Gray Frame",gray)
    # cv2.imshow("Delta Frame",delta_frame)
    # cv2.imshow("Threshold Frame",thresh_frame)

        # cv2.imshow("Color Frame",frame)

    key=cv2.waitKey(1000)

    if key==ord('q'):

        break


video.release()
cv2.destroyAllWindows
