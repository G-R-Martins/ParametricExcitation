# **Parametric Excitation**
Source code of a parametric excitation research developed at `University of São Paulo`.

## Introduction 

### Reduced order model (ROM)
The [main code](https://github.com/G-R-Martins/ParametricExcitation/tree/main/Matlab) (write in [Matlab](https://www.mathworks.com/products/matlab.html) **R2019a**) is a simple tool to evaluate, using a ROM, the dynamics of a vertical slender beam under parametric excitation. This code also can do a comparison with some numerical simulations (in the present case, an in-house FEM solver was used, called **Giraffe**).

- Assumptions about the model:
  1. Bernoulli-Euler beam formulation;
  2. Considering small strain hypothesis, but large displacement;
  3. Temporal-spatial separation of the response using three modes;
  4. Galerkin's method with three sinusoidal shape functions.

### Mathematical formulation
Obtaining the ROM can be a laborious task, thus to help with this, a [Wolfram Mathematica](https://www.wolfram.com/mathematica/) script is provided [here](https://github.com/G-R-Martins/ParametricExcitation/blob/main/Mathematica/NonDim-Eqs.nb). With this script one can obtain and check the nondimensional equations of the ROM and easily adapte it to perform some different pre/postprocessing.

### FEM solver - Giraffe
The **Giraffe** (Generic Interface For Finite Element) software was used to evaluate numerically the beam. It is a FEM-based solver, also developed at `University of São Paulo` by prof. [Alfredo Gay Neto](http://sites.poli.usp.br/p/alfredo.gay/) and his research group. In this study, it is used the Timoshenko's geometrically exact beam formulation implemented in Giraffe to describe the structure.


## Using the code

For now, there is no GUI ~~and this will probably take some time, if it actually happens~~ to this program. But, as it is only some scripts to solve a system of equations and postprocess the results, this should not be a problem. 

You can change some I/O options in the `main.m` file according to your needs. To do this, you just have to change the parameters for the `GeneralOptions` constructor:
```matlab 
genOpt = GeneralOptions(...
    1,... evaluate FEM model in water
    1,... evaluate FEM model in air
    1,... evaluate ROM model in water
    1,... evaluate ROM model in air
    [1 1],... plot tensions [top bottom]
    1,... plot results in multiple tabs (if false individual figures are opened, like in the paper and in ".\figs" folder)
    1,... save ALL figures (the default option is to save PDF figures)
    0,... export .mat
    1 ... load .mat
);
```
The last option must be true unless you will read Giraffe monitors.

The user can choose the excitation scenarios to plot/evaluate in the `main` file:

```matlab
genOpt.SolOpt.n_plot = [2 4]; % to evaluate the first and second Mathieu's instabilities
```

The saving option in `GeneralOptions` constructor can be changed for only one specific scenario and model in the `SetModel.m` file. 
For example, to save only the ROM scalogram for the immersed structure, set the save option to false in `GeneralOptions` at `main.m` and in `SetModel.m` choose:
```matlab
...block of code
if gOpt.include_ROM_water
    % ROM options: damping coefficient, immersed?, natural frequency, top tension 
    rom{2} = ROM(0.112982, true, gOpt.ROM_freq_water(n), 33.4405); 
    rom{2}.SetOutputOptions(...
    0, ... save displacement time series
    1, ... save scalogram (this option MUST BE TRUE OR 1)
    0, ... save tension 
    0, ... show phaseSpace
    1  ... show scalogram
    );
    ... block of code
end
... block of code
```

