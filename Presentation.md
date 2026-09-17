# CIFAR-10 Classification — Presentation

## Slide 1 — Title
- Image Classification with Transfer Learning on CIFAR-10

## Slide 2 — The Problem
- Classify 32x32 RGB images into 10 classes (airplane → truck)
- 50k train / 10k test images, mutually exclusive classes

## Slide 3 — EDA
- Showed sample images per class (10 classes x 8 samples)
- Balanced labels, 10k images chosen to save training time

## Slide 4 — Preprocessing
- Pixel normalization: 0–255 → 0–1
- One-hot encoding of labels (10 outputs)

## Slide 5 — Model: Transfer Learning
- Pretrained **ResNet50** on ImageNet as feature extractor (frozen)
- Head: GlobalAveragePooling → Dense 128 → Dense 64 → softmax
- Optimizer: Adam (lr 0.001), loss: categorical crossentropy, 20 epochs

### Explanation
- **ResNet50 (frozen feature extractor)**: ResNet50 is a 50-layer CNN pretrained on ~1.2M ImageNet images. We keep its image weights **frozen** (`trainable=False`), so it behaves as a fixed, already-trained feature extractor: it outputs generic visual features (edges → textures → object parts). We do **not** retrain it — we only learn the head, so we need far fewer images/time/gradient steps than training from scratch.
- **Why freeze?** The ImageNet features are generic enough for any image task, and freezing avoids destroying them (and avoids overfitting on the small 10k-image subset).
- **GlobalAveragePooling**: converts the last feature maps (e.g. `H×W×2048`) into a single feature vector of length **2048** by averaging each channel. It replaces a big Flatten + Dense stack, drastically reducing parameters and overfitting, and it works for any input size.
- **Dense 128 → Dense 64 (ReLU)**: small fully-connected layers that learn **task-specific** combinations of the generic features (filters that are discriminative for CIFAR-10's 10 classes).
- **Softmax (10 outputs)**: normalizes the last layer scores into 10 probabilities that sum to 1 → predicted class = argmax.
- **Adam (lr 0.001)**: adaptive optimizer with per-parameter learning rates + momentum; lr 0.001 is a safe common default.
- **Categorical crossentropy**: standard loss for multi-class one-hot labels — penalizes confidently-wrong predictions.
- **20 epochs**: passes over the training set. Only the ~270k head parameters are trained; the frozen ResNet base just passes each image forward.

## Slide 6 — Results
- **ResNet50: ~37% test accuracy** (steady loss reduction, no overfitting)
- **EfficientNetB0: 10%** — failed to learn (stuck at random-guess level)
- ResNet50 beat EfficientNet by ~27%

## Slide 7 — Why EfficientNet Failed
- EfficientNet's stem downsamples 32x32 images too aggressively → features destroyed before the head
- Shortcut/resizing workaround needed → ResNet better suited to small images

## Slide 8 — Key Takeaways
- Transfer learning works, but pretrained base must match input size
- Small input (32x32) limits deep ImageNet models
- Same pipeline repeated with Sequential API gave identical results

## Slide 9 — Further Improvements
- Use all 50k images, data augmentation
- Unfreeze/fine-tune part of the base
- Custom small CNN instead of ImageNet models