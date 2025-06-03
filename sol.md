B7-13 (https://colab.research.google.com/github/google-deepmind/alphaevolve_results/blob/master/mathematical_results.ipynb#scrollTo=v3kEu5yVeJ2h) can be encoded as MINLP, more precisely nonconvex QCQP
The QCQP all have similar nonconvex constraints:  squares of sum affine expression >= affine/quadratic expression.

The results found from MINLP formulations and alpha evolve are listed below.

prob12 (maxim):
n = 26: obj = 2.923088 (xp9.6.0, 930 seconds), sota obj = 2.937 (alpha)
n = 32: obj = 2.630473 (xp9.6.0, 937 seconds), sota obj = 2.635 (alpha)

prob13 (maxim):
n = 21: obj = 2.364246 (xp9.6.0, 535 seconds), sota obj = 2.364 (alpha)
