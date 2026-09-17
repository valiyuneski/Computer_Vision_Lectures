# Image Classification with Transfer Learning — Business-Focused Presentation

## Slide 1 — Title / Why This Matters
- Image Classification with Transfer Learning on CIFAR-10
- Goal: ship a working image classifier fast and cheap by reusing an existing pretrained model instead of building one from scratch

## Slide 2 — The Business Problem
- Business need: automatically classify images into 10 categories (airplane → truck)
- Why this has business value: automated image classification powers sorting, quality control, moderation, and search — it replaces manual review with speed, scale, and lower cost
- Dataset chosen: CIFAR-10 (50k train / 10k test, 32x32 RGB) — a small, free, pre-labeled dataset that lets us validate the approach cheaply before spending on production data

## Slide 3 — What We Did & Why
- Key decision: do NOT train from scratch — reuse ImageNet-pretrained CNNs as frozen feature extractors and only train a small task-specific head
- Business rationale: training from scratch needs massive data, GPU time, and expertise; transfer learning delivers with ~0 base-training cost
- Ran a backbone comparison (ResNet50 vs EfficientNetB0) — a technology/vendor selection exercise with identical head and training recipe for a fair apples-to-apples test
- Scoped the working set to 10k of the 50k training images to cut compute and time during the comparison

## Slide 4 — How We Measured Success
- Primary metric: test accuracy on the held-out 10k images — the % of new, unseen images the classifier labels correctly
- Secondary metrics: training loss curve (is the model actually learning?) and training time/cost per model
- Baseline: random guessing = 10%; any result above that is real signal
- Success = (1) clearly beat the baseline, and (2) select the backbone with the best accuracy per unit of compute

## Slide 5 — The Approach (technical summary)
- Frozen ResNet50 feature extractor + small head: GlobalAveragePooling → Dense 128 → Dense 64 → softmax
- Adam (lr 0.001), categorical crossentropy, 20 epochs; only the head (~270k params) is trained
- Same head and recipe applied to EfficientNetB0 for an identical comparison

## Slide 6 — Results
- ResNet50: **36.8% test accuracy** — steady loss reduction, no overfitting
- EfficientNetB0: **10.0%** — stuck at random-guess level, never learned
- Winner: ResNet50, by **26.8 points**
- Compute note: ResNet50 was ~5x slower per epoch (~20s vs ~7s), but accuracy per dollar is what matters — the cheaper model returned nothing

## Slide 7 — Business Analysis: Why EfficientNet Failed
- Root cause: EfficientNet's stem downsamples 32x32 inputs too aggressively — features are destroyed before the head ever sees them
- Business lesson: the "cheaper and faster" model is only better if it actually performs; what sounds like the better vendor can lose on your real data
- Setup was identical for both models — only empirical testing on our data revealed the difference

## Slide 8 — Key Business Takeaways
- Transfer learning is a fast, low-cost path to a working classifier — no huge data or GPU budget required
- Measure against a baseline on data the model has never seen, not on training performance
- Empirical evaluation beats intuition: the outcome (10% vs 36.8%) overturned expectations about which model was better
- Small input images (32x32) are a real constraint some models can't handle

## Slide 9 — Next Steps / Roadmap
- Scale up: use all 50k images + data augmentation → expected accuracy gain at modest extra cost
- Fine-tune part of the base now that the pipeline is proven
- Test a custom small CNN: if it matches frozen-ImageNet accuracy it also cuts runtime/inference cost in production
- End state: a production-ready classifier with known accuracy and cost trade-offs