# DR-Lyapunov-Function-Search
This repo contains implementations for the paper: "Distributionally Robust Lyapunov Function Search Under Uncertainty"

You can find the paper here: https://arxiv.org/pdf/2212.01554.pdf

## Instructions
In this work, we compare six different formulations in searching a Lyapunov function for uncertain dynamical systems. These formulations include Baseline sum-of-squares (SOS), chance-constrained (CC) SOS, distributionally robust chance-constrained (DRCC) SOS, baseline neural network (NN), CC-NN, and DRCC-NN.

The sum-of-squares (SOS)-based formulations are implemented using Matlab, while the neural network-based formulations can be found in the provided Jupyter notebook files.

The folder "L4DC_saved_models" contains the pre-trained network model parameters for the simulation examples. The folder "Uncertainty_Info" contains the offline uncertainty samples used in training the CC-NN and DRCC-NN formulation.

## Citation

If you found our method or code useful in your research, please consider citing the paper as follows:

```
@misc{long2022distributionally,
      title={Distributionally Robust Lyapunov Function Search Under Uncertainty}, 
      author={Kehan Long and Yinzhuang Yi and Jorge Cortes and Nikolay Atanasov},
      year={2022},
      eprint={2212.01554},
      archivePrefix={arXiv},
      primaryClass={math.OC}
}
```


## License & Acknowledgements

DR-LF Search is licensed under the MIT license. 
