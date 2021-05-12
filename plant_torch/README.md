# Plant Torch

This is the machine learning part of the happytree project.
We are using a pretrained resnet-18 model as base.

## Installation

First install `python3` then...

Create a new folder `plants` (`happytree/plant_torch/plants`) and add your dataset images for training into the folder.

A good beginning set can be found at [https://www.kaggle.com/alxmamaev/flowers-recognition](https://www.kaggle.com/alxmamaev/flowers-recognition)

Here is an example dir tree:

```bash
├── plants
│   ├── crocus
│   ├── cyclamen
│   ├── daisy
│   ├── dandelion
│   ├── delphinium
│   ├── freesia
│   ├── geranium
│   ├── gerbera
│   ├── gladiolus
│   ├── lilly
│   ├── poppy
│   ├── roses
│   ├── sunflowers
│   ├── tulips
│   └── violet
```

### Training the model

First install the required dependencies. Make sure you are installing them under `python3`

- `pip install numpy`
- `pip install pandas`
- `pip install torch`
- `pip install torchvision`

Now you can run `python3 train.py` to train the model

### Starting the image recognition flask server

First make sure flask is installed and you have the trained weight file in the main folder `plants-resnet.pth`

- `pip install flask`
- `export FLASK_APP=main.py`
- `flask run`

Now you can go to `localhost:5000` and upload an image or make a POST request as multipart form to `localhost:5000`
