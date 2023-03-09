# monte-carlo
An animated Monte Carlo simulation

![](https://user-images.githubusercontent.com/91302084/194731847-43bd3aed-401b-4310-a1cd-65a13c71f9ed.gif)

Assuming geometric brownian motion $S\left ( t \right ) = S\left ( 0 \right ) \cdot e^{t\left ( \mu - \frac{1}{2} \sigma^{2} \right ) + \sigma\cdot W\left ( t \right ) }$, with $t \leq T$, the paramters of the simulation can be tweaked as follows:

| Parameter | Variable |
| --- | --- |
| $S\left ( 0 \right )$ – Initial price | `S_ZERO` |
| $\mu$ – Drift | `DRIFT` |
| $\sigma$ – Volatility | `VOLATILITY` |
| $T$ – Time steps | `TIME_STEP_COUNT` |

$W\left ( t \right )$ is – by default – a normally distributed random number with mean 0 and the same volatility as the rest of the model ($\sigma$ listed previously).

The number of time steps, simulations, and corresponding histogram bins can also be controlled through `TIME_STEP_COUNT`, `SIMULATION_COUNT`, and `HISTOGRAM_BIN_COUNT`, respectively.
