# Notebooks

Author: Sławomir Górawski

## Description

This repository contains [Jupyter](https://jupyter.org/) notebooks supplementing my Master's thesis.
They contains interactive calculations done for the thesis, that can be used to derive the same results, and also experiment with different assumptions.

## Usage

### Google Colab

All the notebooks are hosted on Google Colab, which is the easiest way to interact with them. Links:

* [Autoscaling vs fixed provisioning](https://colab.research.google.com/drive/1eVQzYNCB5R1CaLmCmhUF9rP-w-ycKPEJ?usp=sharing)
* [Storage class choices](https://colab.research.google.com/drive/1dgabyi5wA1oDMK4mOVw4J3JcH2t2gzmB?usp=sharing)
* [Content Delivery Network](https://colab.research.google.com/drive/15VM3N_JM5RGsmhIwfyd8I4Q8LREH70uS?usp=sharing)
* [Data transfer costs](https://colab.research.google.com/drive/1ZzCTEj4U-ScpLUEPo3WLf4klTiSiAAFn?usp=sharing) 

The instructions for running specific notebooks are contained within them.

### Local

For local usage Python 3 is required, some reasonably recent version (3.10–3.13). To run the notebooks locally, perform the following steps:

(Recommended) Create a virtual environment. On Linux or macOS:

    python3 -m venv venv
    source venv/bin/activate

On Windows:

    py -m venv venv
    venv\Scripts\activate

(This is not strictly required, but otherwise all dependencies will be installed globally, which is usually not desired.)

For a more detailed explanation see https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/.

Install dependencies:

    pip install -r requirements.txt

Now, execute:

    jupyter lab

This should open the browser UI with the executable notebooks.
