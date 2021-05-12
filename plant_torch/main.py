from PIL import Image
import torchvision.transforms.functional as TF
from flask import Flask, request
import torch
import torchvision
from torch.utils.data import random_split
from torchvision.datasets import ImageFolder
from torch.utils.data.dataloader import DataLoader
from classes.image_classification_model import ImageClassificationModel
from classes.device_data_loader import DeviceDataLoader, to_device, get_default_device
from classes.transformer import transformer

app = Flask(__name__)

transformer = transformer()
base_dir = "plants"

dataset = ImageFolder(base_dir, transform=transformer)
validation_size = 100
training_size = len(dataset) - validation_size
train_ds, val_ds = random_split(dataset, [training_size, validation_size])

train_dl = DataLoader(train_ds, batch_size=32, shuffle=True)
val_dl = DataLoader(val_ds, batch_size=32)

model = ImageClassificationModel()


@torch.no_grad()
def evaluate(model, val_loader):
    model.load_state_dict(torch.load("plants-resnet.pth"))
    model.eval()
    outputs = [model.validation_step(batch) for batch in val_loader]
    return model.validation_epoch_end(outputs)


device = get_default_device()
train_dl = DeviceDataLoader(train_dl, device)
val_dl = DeviceDataLoader(val_dl, device)
model = to_device(ImageClassificationModel(), device)
evaluate(model, val_dl)


def predict_image(img, model):
    # Convert to a batch of 1
    xb = to_device(img.unsqueeze(0), device)
    # Get predictions from model
    yb = model(xb)
    # Pick index with highest probability
    _, preds = torch.max(yb, dim=1)
    # Retrieve the class label
    return dataset.classes[preds[0].item()]


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        if 'image' not in request.files:
            return 'there is no image in form!'
        image = request.files['image']
        image = Image.open(image)
        image = TF.to_tensor(image)
        prediction = predict_image(image, model)
        return prediction

    return '''
    <h1>Recognize a plant! 🌿</h1>
    <form method="post" enctype="multipart/form-data">
      <input type="file" name="image">
      <input type="submit">
    </form>
    '''
